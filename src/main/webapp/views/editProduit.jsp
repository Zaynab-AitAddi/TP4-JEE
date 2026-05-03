<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="metier.ProduitMetier, dao.model.Produit, dao.model.User, dao.model.Role, util.ValidationUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // Contrôle d'accès
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }
    if (currentUser.getRole() != Role.ADMIN && currentUser.getRole() != Role.MANAGER) {
        response.sendError(403, "Accès refusé");
        return;
    }

    ProduitMetier produitMetier = ProduitMetier.getInstance();
    Produit produit = null;
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Traitement de la mise à jour
        String idStr       = request.getParameter("id");
        String nom         = request.getParameter("nom");
        String description = request.getParameter("description");
        String prixStr     = request.getParameter("prix");
        String categorie   = request.getParameter("categorie");

        if (ValidationUtil.isEmpty(idStr) || ValidationUtil.isEmpty(nom) ||
                ValidationUtil.isEmpty(description) || ValidationUtil.isEmpty(prixStr) ||
                ValidationUtil.isEmpty(categorie)) {
            error = "Tous les champs sont obligatoires";
            try { produit = produitMetier.getProduitById(Long.parseLong(idStr)); } catch (Exception ignored) {}
        } else {
            try {
                Long id = Long.parseLong(idStr);
                produit = produitMetier.getProduitById(id);
                if (produit == null) {
                    response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=Produit+non+trouve");
                    return;
                }
                if (!ValidationUtil.isValidPrice(prixStr)) {
                    error = "Prix invalide";
                } else {
                    produit.setNom(nom);
                    produit.setDescription(description);
                    produit.setPrix(Double.parseDouble(prixStr));
                    produit.setCategorie(categorie);
                    if (produitMetier.updateProduit(produit)) {
                        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?success=Produit+modifie+avec+succes");
                        return;
                    } else {
                        error = "Erreur lors de la modification";
                    }
                }
            } catch (NumberFormatException e) {
                error = "Format invalide";
            }
        }
    } else {
        // GET : charger le produit depuis l'id dans l'URL
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=ID+produit+manquant");
            return;
        }
        try {
            produit = produitMetier.getProduitById(Long.parseLong(idStr));
            if (produit == null) {
                response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=Produit+non+trouve");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=ID+invalide");
            return;
        }
    }
    
    String[] categories = {"Électronique","Accessoires","Logiciels","Livres","Vêtements","Maison","Jardin","Sports","Autres"};
    String[] catEmojis  = {"📱","🎧","💻","📚","👕","🏠","🌿","⚽","📦"};
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier un Produit - Gestion des Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; min-height: 100vh; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); box-shadow: 0 10px 30px rgba(0,0,0,0.1); padding: 1rem 0; }
        .navbar-brand { font-weight: 800; font-size: 1.6rem; color: white !important; }
        .nav-link { color: rgba(255,255,255,0.85) !important; font-weight: 500; transition: all 0.3s ease; }
        .nav-link:hover { color: white !important; }
        .user-badge { display: inline-flex; align-items: center; gap: 8px; padding: 0.5rem 1rem; border-radius: 30px; font-size: 0.85rem; font-weight: 600; background: rgba(255,255,255,0.2); color: white; }
        .page-header { background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.85) 100%); padding: 3rem 0; margin-bottom: 2rem; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .page-header h1 { font-size: 2.5rem; font-weight: 800; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 0.5rem; }
        .page-header p { color: #666; font-size: 1.1rem; }
        .form-container { max-width: 900px; margin: 0 auto; padding: 0 1rem 3rem; }
        .back-link { display: inline-flex; align-items: center; gap: 10px; background: white; padding: 0.8rem 1.5rem; border-radius: 50px; color: #667eea; text-decoration: none; font-weight: 600; margin-bottom: 2rem; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .back-link:hover { transform: translateX(-5px); color: #764ba2; }
        .product-info-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 20px; padding: 1.5rem; margin-bottom: 2rem; color: white; box-shadow: 0 10px 30px rgba(102,126,234,0.3); }
        .product-info-title { font-size: 0.9rem; opacity: 0.9; margin-bottom: 0.5rem; letter-spacing: 1px; }
        .product-info-value { font-size: 1.8rem; font-weight: 800; }
        .form-card { background: white; border-radius: 25px; box-shadow: 0 20px 40px rgba(0,0,0,0.08); overflow: hidden; }
        .form-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 1.5rem 2rem; color: white; }
        .form-header h3 { margin: 0; font-weight: 700; font-size: 1.3rem; }
        .form-body { padding: 2rem; }
        .form-group { margin-bottom: 1.8rem; }
        .form-label { font-weight: 700; color: #333; margin-bottom: 0.6rem; display: flex; align-items: center; gap: 8px; }
        .required-field::after { content: '*'; color: #dc3545; margin-left: 4px; }
        .form-control, .form-select { border: 2px solid #e9ecef; border-radius: 12px; padding: 0.85rem 1.2rem; font-size: 1rem; transition: all 0.3s ease; }
        .form-control:focus, .form-select:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.15); }
        textarea.form-control { resize: vertical; min-height: 120px; }
        .form-actions { display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 2px solid #f0f0f0; }
        .btn-update { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); border: none; color: white; padding: 0.9rem 2rem; font-weight: 700; border-radius: 12px; transition: all 0.3s ease; flex: 1; }
        .btn-update:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(40,167,69,0.3); color: white; }
        .btn-cancel { background: #6c757d; border: none; color: white; padding: 0.9rem 2rem; font-weight: 700; border-radius: 12px; transition: all 0.3s ease; flex: 1; text-align: center; text-decoration: none; display: flex; align-items: center; justify-content: center; }
        .btn-cancel:hover { background: #5a6268; transform: translateY(-3px); color: white; }
        .footer { background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%); color: white; text-align: center; padding: 2rem; margin-top: 3rem; }
        .footer p { margin: 0; opacity: 0.9; }
        @media (max-width: 768px) { .form-actions { flex-direction: column; } }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/views/dashboard.jsp">
                <i class="fas fa-box"></i> Gestion Produits
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/views/dashboard.jsp"><i class="fas fa-home"></i> Accueil</a>
                    </li>
                    <li class="nav-item">
                        <span class="user-badge"><i class="fas fa-user-circle"></i> <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="nav-link" href="<%= request.getContextPath() %>/views/logout.jsp"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="page-header">
        <div class="container-fluid px-4">
            <h1><i class="fas fa-edit"></i> Modifier un Produit</h1>
            <p>Mettez à jour les informations du produit dans le système</p>
        </div>
    </div>

    <div class="form-container">
        <a href="<%= request.getContextPath() %>/views/dashboard.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour à la liste des produits
        </a>

        <% if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle"></i> <strong>Erreur!</strong> <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <% if (produit != null) { %>
        <div class="product-info-card">
            <div class="row align-items-center">
                <div class="col-auto"><i class="fas fa-tag" style="font-size:2.5rem;opacity:0.9;"></i></div>
                <div class="col">
                    <div class="product-info-title">PRODUIT #<%= produit.getIdProduit() %></div>
                    <div class="product-info-value"><%= produit.getNom() %></div>
                </div>
                <div class="col-auto">
                    <span class="badge bg-white text-dark px-3 py-2 rounded-pill">
                        <i class="fas fa-calendar"></i> Modification en cours
                    </span>
                </div>
            </div>
        </div>

        <div class="form-card">
            <div class="form-header">
                <h3><i class="fas fa-pencil-alt"></i> Formulaire de modification</h3>
            </div>
            <div class="form-body">
                <form method="POST" action="<%= request.getContextPath() %>/views/editProduit.jsp" id="editForm">
                    <input type="hidden" name="id" value="<%= produit.getIdProduit() %>">

                    <div class="form-group">
                        <label class="form-label required-field"><i class="fas fa-heading"></i> Nom du produit</label>
                        <input type="text" id="nom" name="nom" required
                               value="<%= produit.getNom() %>" class="form-control"
                               placeholder="Ex: iPhone 15 Pro, Laptop Dell XPS, ...">
                        <small class="text-muted">Le nom doit être unique et descriptif</small>
                    </div>

                    <div class="form-group">
                        <label class="form-label required-field"><i class="fas fa-align-left"></i> Description</label>
                        <textarea id="description" name="description" required rows="5"
                                  class="form-control" placeholder="Décrivez le produit en détail..."><%= produit.getDescription() %></textarea>
                        <small class="text-muted">Description complète du produit</small>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label required-field"><i class="fas fa-euro-sign"></i> Prix (€)</label>
                                <input type="number" id="prix" name="prix" required
                                       value="<%= produit.getPrix() %>" step="0.01" min="0" class="form-control" placeholder="0.00">
                                <small class="text-muted">Prix en euros (TTC)</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label required-field"><i class="fas fa-folder"></i> Catégorie</label>
                                <select id="categorie" name="categorie" required class="form-select">
                                    <option value="">-- Sélectionner une catégorie --</option>
                                    <% for (int i = 0; i < categories.length; i++) {
                                        boolean selected = categories[i].equals(produit.getCategorie()); %>
                                    <option value="<%= categories[i] %>" <%= selected ? "selected" : "" %>>
                                        <%= catEmojis[i] %> <%= categories[i] %>
                                    </option>
                                    <% } %>
                                </select>
                                <small class="text-muted">Catégorie pour organiser les produits</small>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="mb-2"><i class="fas fa-eye"></i> Aperçu :</h6>
                        <div class="row">
                            <div class="col-md-6"><strong>Nom:</strong> <span id="previewNom"><%= produit.getNom() %></span></div>
                            <div class="col-md-6"><strong>Prix:</strong> <span id="previewPrix"><%= produit.getPrix() %></span> €</div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-update"><i class="fas fa-save"></i> Mettre à jour</button>
                        <a href="<%= request.getContextPath() %>/views/dashboard.jsp" class="btn btn-cancel">
                            <i class="fas fa-times"></i> Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-circle"></i>
            <strong>Produit non trouvé!</strong> Le produit demandé n'existe pas.
        </div>
        <div class="text-center">
            <a href="<%= request.getContextPath() %>/views/dashboard.jsp" class="btn btn-primary btn-lg">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
        </div>
        <% } %>
    </div>

    <div class="footer"><p>&copy; Zaynab AITADDI -TP4- JEE MVC1</p></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('nom')?.addEventListener('input', function() {
            document.getElementById('previewNom').textContent = this.value || '---';
        });
        document.getElementById('prix')?.addEventListener('input', function() {
            document.getElementById('previewPrix').textContent = this.value || '0';
        });
        document.getElementById('editForm')?.addEventListener('submit', function(e) {
            const nom = document.getElementById('nom').value.trim();
            const prix = parseFloat(document.getElementById('prix').value);
            if (nom.length < 2) { e.preventDefault(); alert('Le nom doit contenir au moins 2 caractères'); return; }
            if (isNaN(prix) || prix <= 0) { e.preventDefault(); alert('Le prix doit être supérieur à 0'); return; }
        });
    </script>
</body>
</html>
