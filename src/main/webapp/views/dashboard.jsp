<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="metier.ProduitMetier, dao.model.Produit, dao.model.User, dao.model.Role, java.util.List" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // Contrôle d'accès : rediriger si non connecté
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    // Charger les produits
    ProduitMetier produitMetier = ProduitMetier.getInstance();
    String search = request.getParameter("search");
    List<Produit> produits;
    if (search != null && !search.trim().isEmpty()) {
        produits = produitMetier.searchProduits(search);
    } else {
        produits = produitMetier.getAllProduits();
    }

    boolean isAdminOrManager = currentUser.getRole() == Role.ADMIN || currentUser.getRole() == Role.MANAGER;
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord - Gestion des Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body { background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; min-height: 100vh; }
        .navbar { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); box-shadow: 0 8px 24px rgba(102,126,234,0.2); }
        .navbar-brand { font-weight: 700; font-size: 1.6rem; color: white !important; letter-spacing: -0.5px; }
        .nav-link { color: rgba(255,255,255,0.85) !important; font-weight: 500; transition: all 0.3s ease; }
        .nav-link:hover { color: white !important; }
        .user-badge { display: inline-block; padding: 0.4rem 0.9rem; border-radius: 20px; font-size: 0.8rem; font-weight: 600; background-color: rgba(255,255,255,0.2); color: white; margin-left: 0.5rem; }
        .role-admin { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%) !important; }
        .role-manager { background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%) !important; }
        .role-user { background: linear-gradient(135deg, #198754 0%, #146c43 100%) !important; }
        .page-header { background: linear-gradient(135deg, rgba(255,255,255,0.95) 0%, rgba(255,255,255,0.85) 100%); padding: 2.5rem; border-bottom: 2px solid rgba(102,126,234,0.1); margin-bottom: 2.5rem; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .page-header h1 { color: #333; font-weight: 700; margin-bottom: 0.5rem; font-size: 2.2rem; }
        .page-header p { color: #666; margin: 0; font-size: 1.05rem; }
        .search-section { background: white; padding: 1.8rem; border-radius: 14px; margin-bottom: 2.5rem; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .search-section .form-control { border-radius: 10px; border: 1.5px solid #e0e0e0; padding: 0.9rem 1.2rem; transition: all 0.3s ease; }
        .search-section .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.3rem rgba(102,126,234,0.15); }
        .product-card { background: white; border-radius: 14px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); transition: all 0.4s cubic-bezier(0.23,1,0.320,1); overflow: hidden; }
        .product-card:hover { box-shadow: 0 12px 32px rgba(102,126,234,0.25); transform: translateY(-8px); }
        .product-card-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1.5rem; }
        .product-card-body { padding: 1.8rem; }
        .product-id { font-size: 0.8rem; opacity: 0.9; margin-bottom: 0.5rem; font-weight: 600; }
        .product-name { font-size: 1.35rem; font-weight: 700; color: #333; margin-bottom: 0.8rem; }
        .product-category { display: inline-block; padding: 0.4rem 0.85rem; border-radius: 8px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; font-size: 0.8rem; font-weight: 600; margin-bottom: 1rem; }
        .product-description { color: #666; margin-bottom: 1.2rem; font-size: 0.95rem; line-height: 1.5; }
        .product-price { font-size: 1.8rem; font-weight: 700; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); background-clip: text; -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 1.5rem; }
        .product-actions { display: flex; gap: 0.8rem; }
        .btn-sm-action { padding: 0.65rem 1.2rem; font-size: 0.9rem; border-radius: 8px; text-decoration: none; transition: all 0.3s ease; flex: 1; text-align: center; font-weight: 600; border: none; cursor: pointer; }
        .btn-edit { background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%); color: white; }
        .btn-edit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(13,110,253,0.3); color: white; }
        .btn-delete { background: linear-gradient(135deg, #dc3545 0%, #bb2d3b 100%); color: white; }
        .btn-delete:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(220,53,69,0.3); color: white; }
        .btn-view-only { background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%); color: white; cursor: default; opacity: 0.7; }
        .role-info-message { background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%); border-left: 4px solid #0d6efd; padding: 0.8rem 1.2rem; border-radius: 10px; margin-bottom: 1.5rem; font-size: 0.9rem; }
        .table-responsive { background: white; border-radius: 14px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); overflow: hidden; }
        .table { margin: 0; }
        .table thead th { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); border-bottom: 2px solid #dee2e6; font-weight: 700; color: #333; padding: 1.2rem; }
        .table tbody tr { transition: all 0.3s ease; }
        .table tbody tr:hover { background-color: #f8f9ff; }
        .empty-state { background: white; border-radius: 14px; padding: 4rem 2rem; text-align: center; box-shadow: 0 4px 16px rgba(0,0,0,0.08); border: 2px dashed #e0e0e0; }
        .empty-state-icon { font-size: 4.5rem; margin-bottom: 1.5rem; }
        .btn-add-product { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; color: white; border-radius: 10px; padding: 0.85rem 1.8rem; font-weight: 600; transition: all 0.3s ease; }
        .btn-add-product:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(102,126,234,0.35); color: white; }
        .btn-add-product-disabled { background: linear-gradient(135deg, #adb5bd 0%, #6c757d 100%); border: none; color: white; border-radius: 10px; padding: 0.85rem 1.8rem; font-weight: 600; cursor: not-allowed; opacity: 0.6; }
        .footer { background: linear-gradient(135deg, #2d3748 0%, #1a202c 100%); color: white; text-align: center; padding: 2.5rem; margin-top: 4rem; }
        .footer p { margin: 0; opacity: 0.9; }
        .view-toggle { margin-bottom: 2rem; display: flex; gap: 0.8rem; }
        .view-toggle .btn { border-radius: 10px; font-weight: 600; padding: 0.6rem 1.2rem; }
        .view-toggle .btn.active { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .list-view { display: none; }
        .grid-view { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2rem; }
        @media (max-width: 768px) { .grid-view { grid-template-columns: 1fr; gap: 1.5rem; } }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/views/dashboard.jsp">📦 Gestion Produits</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/views/dashboard.jsp">Accueil</a>
                    </li>
                    <li class="nav-item">
                        <% if (isAdminOrManager) { %>
                        <a class="nav-link btn-add-product ms-md-3" href="<%= request.getContextPath() %>/views/addProduit.jsp">
                            ➕ Ajouter Produit
                        </a>
                        <% } else { %>
                        <span class="nav-link btn-add-product-disabled ms-md-3">🔒 Accès limité</span>
                        <% } %>
                    </li>
                    <li class="nav-item ms-3">
                        <span class="user-badge">🧑 <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                        <span class="user-badge role-<%= currentUser.getRole().name().toLowerCase() %>">
                            <%= currentUser.getRole().getLabel() %>
                        </span>
                    </li>
                    <li class="nav-item ms-3">
                        <a class="nav-link" href="<%= request.getContextPath() %>/views/logout.jsp">🚪 Déconnexion</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Page Header -->
    <div class="page-header">
        <div class="container-fluid">
            <h1>📊 Gestion des Produits</h1>
            <p>Bienvenue, <%= currentUser.getPrenom() %>! Voici la liste complète de vos produits.</p>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container-fluid px-4">
        <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <strong>✅ Succès!</strong> <%= successMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <strong>❌ Erreur!</strong> <%= errorMsg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <% } %>

        <% if (currentUser.getRole() == Role.USER) { %>
        <div class="role-info-message">
            <strong>ℹ️ Mode Consultation uniquement</strong><br>
            Vous êtes connecté en tant qu'utilisateur standard. Vous pouvez consulter et rechercher des produits,
            mais vous ne pouvez pas ajouter, modifier ou supprimer des produits.
        </div>
        <% } %>

        <!-- Search -->
        <div class="search-section">
            <form method="GET" action="<%= request.getContextPath() %>/views/dashboard.jsp" class="search-form">
                <div class="input-group">
                    <input type="text" name="search" class="form-control form-control-lg"
                           placeholder="🔍 Rechercher un produit..." value="<%= search != null ? search : "" %>">
                    <button class="btn btn-primary" type="submit">Rechercher</button>
                    <% if (search != null && !search.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/views/dashboard.jsp" class="btn btn-secondary">✕ Réinitialiser</a>
                    <% } %>
                </div>
            </form>
        </div>

        <!-- View Toggle -->
        <div class="view-toggle d-flex justify-content-end">
            <button class="btn btn-outline-primary btn-sm" onclick="toggleView('list')">📋 Tableau</button>
            <button class="btn btn-outline-primary btn-sm active" onclick="toggleView('grid')">📦 Grille</button>
        </div>

        <!-- Products Grid -->
        <div class="grid-view" id="grid-view">
            <% if (produits != null && !produits.isEmpty()) {
                for (Produit p : produits) { %>
            <div class="product-card">
                <div class="product-card-header">
                    <div class="product-id">#<%= p.getIdProduit() %></div>
                </div>
                <div class="product-card-body">
                    <div class="product-name"><%= p.getNom() %></div>
                    <div class="product-category"><%= p.getCategorie() %></div>
                    <p class="product-description"><%= p.getDescription() %></p>
                    <div class="product-price"><%= p.getPrix() %> €</div>
                    <div class="product-actions">
                        <% if (isAdminOrManager) { %>
                        <a href="<%= request.getContextPath() %>/views/editProduit.jsp?id=<%= p.getIdProduit() %>"
                           class="btn-sm-action btn-edit">✏️ Modifier</a>
                        <a href="<%= request.getContextPath() %>/views/deleteProduit.jsp?id=<%= p.getIdProduit() %>"
                           class="btn-sm-action btn-delete"
                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit?');">🗑️ Supprimer</a>
                        <% } else { %>
                        <span class="btn-sm-action btn-view-only">🔒 Lecture seule</span>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } } else { %>
            <div class="empty-state w-100">
                <div class="empty-state-icon">📦</div>
                <h3>Aucun produit trouvé</h3>
                <p>
                    <% if (search != null && !search.isEmpty()) { %>
                        Aucun produit ne correspond à "<strong><%= search %></strong>".
                    <% } else if (isAdminOrManager) { %>
                        Commencez par <a href="<%= request.getContextPath() %>/views/addProduit.jsp">ajouter un nouveau produit</a>.
                    <% } else { %>
                        Contactez un administrateur pour ajouter des produits.
                    <% } %>
                </p>
            </div>
            <% } %>
        </div>

        <!-- Products Table -->
        <div class="list-view" id="list-view">
            <% if (produits != null && !produits.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nom</th><th>Description</th><th>Catégorie</th><th>Prix</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Produit p : produits) { %>
                        <tr>
                            <td><strong>#<%= p.getIdProduit() %></strong></td>
                            <td><%= p.getNom() %></td>
                            <td><%= p.getDescription() %></td>
                            <td><span class="product-category"><%= p.getCategorie() %></span></td>
                            <td><strong><%= p.getPrix() %> €</strong></td>
                            <td>
                                <% if (isAdminOrManager) { %>
                                <a href="<%= request.getContextPath() %>/views/editProduit.jsp?id=<%= p.getIdProduit() %>" class="btn btn-sm btn-primary">✏️ Modifier</a>
                                <a href="<%= request.getContextPath() %>/views/deleteProduit.jsp?id=<%= p.getIdProduit() %>" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Êtes-vous sûr?');">🗑️ Supprimer</a>
                                <% } else { %>
                                <span class="badge bg-secondary">🔒 Consultation</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <div class="footer">
        <p>&copy; Zaynab AITADDI -TP4- JEE MVC1</p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleView(view) {
            const gridView = document.getElementById('grid-view');
            const listView = document.getElementById('list-view');
            document.querySelectorAll('.view-toggle .btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            if (view === 'grid') { gridView.style.display = 'grid'; listView.style.display = 'none'; }
            else { gridView.style.display = 'none'; listView.style.display = 'block'; }
        }
    </script>
</body>
</html>
