<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="metier.UserMetier, dao.model.User, util.PasswordUtil, util.ValidationUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    String error = null;
    boolean inscriptionOk = false;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email           = request.getParameter("email");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String nom             = request.getParameter("nom");
        String prenom          = request.getParameter("prenom");

        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password) ||
                ValidationUtil.isEmpty(confirmPassword) || ValidationUtil.isEmpty(nom) ||
                ValidationUtil.isEmpty(prenom)) {
            error = "Veuillez remplir tous les champs";
        } else if (!password.equals(confirmPassword)) {
            error = "Les mots de passe ne correspondent pas";
        } else if (!PasswordUtil.isStrongPassword(password)) {
            error = "Le mot de passe doit contenir au moins 8 caractères, 1 majuscule, 1 minuscule et 1 chiffre";
        } else if (!ValidationUtil.isValidEmail(email)) {
            error = "Veuillez entrer une adresse email valide";
        } else {
            UserMetier userMetier = UserMetier.getInstance();
            if (userMetier.signUp(email, password, nom, prenom)) {
                inscriptionOk = true;
            } else if (userMetier.getUserByEmail(email) != null) {
                error = "Cet email est deja utilise";
            } else {
                error = "Erreur lors de l'inscription. Veuillez reessayer.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription - Gestion des Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; align-items: center; justify-content: center;
            min-height: 100vh; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 2rem 1rem;
        }
        .signup-container { width: 100%; max-width: 560px; }
        .signup-card { border: none; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        .signup-header {
            text-align: center; padding: 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px 12px 0 0; color: white;
        }
        .signup-header h1 { font-weight: 700; font-size: 2rem; margin-bottom: 0.5rem; }
        .form-control { border-radius: 8px; border: 1px solid #e0e0e0; padding: 0.75rem 1rem; transition: all 0.3s ease; }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.2rem rgba(102,126,234,0.25); }
        .btn-signup {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; border-radius: 8px; padding: 0.75rem;
            font-weight: 600; font-size: 1rem; transition: all 0.3s ease; color: white;
        }
        .btn-signup:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.3); color: white; }
        .login-link { text-align: center; margin-top: 1.5rem; color: #666; }
        .login-link a { color: #667eea; font-weight: 600; text-decoration: none; }
        .password-requirements {
            background-color: #f8f9fa; border-left: 4px solid #667eea;
            padding: 0.75rem; border-radius: 8px; margin-top: 0.5rem;
        }
        .password-requirements ul { margin: 0; padding-left: 1.5rem; font-size: 0.85rem; }
        .password-requirements li { margin-bottom: 0.25rem; color: #666; }
        .success-message { text-align: center; }
        .success-message .display-4 { color: #667eea; margin-bottom: 1rem; }
    </style>
</head>
<body>
<div class="signup-container">
    <div class="card signup-card">
        <div class="signup-header">
            <h1>📝 Inscription</h1>
            <p>Créez votre compte</p>
        </div>
        <div class="card-body p-4">
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>❌ Erreur!</strong> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <% if (inscriptionOk) { %>
            <div class="success-message">
                <div class="display-4">✅</div>
                <h3>Inscription Réussie!</h3>
                <p>Votre compte a été créé avec succès. Vous pouvez maintenant vous connecter.</p>
                <a href="<%= request.getContextPath() %>/views/login.jsp" class="btn btn-primary btn-lg mt-3">
                    Aller à la Connexion
                </a>
            </div>
            <% } else { %>
            <form method="POST" action="<%= request.getContextPath() %>/views/signup.jsp">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <label for="prenom" class="form-label">Prénom *</label>
                        <input type="text" id="prenom" name="prenom" required placeholder="Ex: Jean" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label for="nom" class="form-label">Nom *</label>
                        <input type="text" id="nom" name="nom" required placeholder="Ex: Dupont" class="form-control">
                    </div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">📧 Adresse Email *</label>
                    <input type="email" id="email" name="email" required placeholder="exemple@domaine.com" class="form-control">
                </div>
                <div class="mb-1">
                    <label for="password" class="form-label">🔑 Mot de passe *</label>
                    <input type="password" id="password" name="password" required placeholder="Minimum 8 caractères" class="form-control">
                    <div class="password-requirements">
                        <small><strong>Requis:</strong></small>
                        <ul>
                            <li>Minimum 8 caractères</li>
                            <li>Au moins 1 majuscule (A-Z)</li>
                            <li>Au moins 1 minuscule (a-z)</li>
                            <li>Au moins 1 chiffre (0-9)</li>
                        </ul>
                    </div>
                </div>
                <div class="mb-3 mt-3">
                    <label for="confirmPassword" class="form-label">🔒 Confirmer le mot de passe *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required
                           placeholder="Confirmez votre mot de passe" class="form-control">
                </div>
                <div class="form-check mb-3">
                    <input type="checkbox" id="terms" name="terms" required class="form-check-input">
                    <label class="form-check-label" for="terms">
                        J'accepte les <a href="#" target="_blank">conditions d'utilisation</a>
                    </label>
                </div>
                <button type="submit" class="btn btn-signup btn-lg w-100">S'Inscrire</button>
            </form>
            <% } %>
        </div>
        <div class="login-link p-3">
            <p>Déjà inscrit? <a href="<%= request.getContextPath() %>/views/login.jsp">Se connecter ici</a></p>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
