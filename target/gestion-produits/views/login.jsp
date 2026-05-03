<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="metier.UserMetier, dao.model.User, util.ValidationUtil" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // Si déjà connecté, rediriger vers le dashboard
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser != null) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp");
        return;
    }

    String error = null;
    String successMsg = (String) request.getAttribute("success");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) {
            error = "Veuillez remplir tous les champs";
        } else {
            UserMetier userMetier = UserMetier.getInstance();
            User user = userMetier.authenticate(email, password);
            if (user != null) {
                session.setAttribute("currentUser", user);
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp");
                return;
            } else {
                error = "Email ou mot de passe incorrect";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Gestion des Produits</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 15px;
        }
        .login-container { width: 100%; max-width: 450px; margin: 0 auto; }
        .login-card {
            border: none; border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden; backdrop-filter: blur(10px);
            animation: slideIn 0.5s ease-out;
        }
        @keyframes slideIn { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        .login-header {
            text-align: center; padding: 2.5rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .login-header h1 { font-weight: 700; font-size: 2.2rem; margin-bottom: 0.5rem; }
        .login-header p  { font-size: 0.95rem; opacity: 0.9; margin: 0; }
        .card-body { padding: 2.5rem; background: white; }
        .form-control {
            border-radius: 10px; border: 1.5px solid #e0e0e0;
            padding: 0.9rem 1.2rem; font-size: 0.95rem;
            transition: all 0.3s ease; background-color: #f9f9f9;
        }
        .form-control:focus { border-color: #667eea; box-shadow: 0 0 0 0.3rem rgba(102,126,234,0.15); background-color: white; }
        .form-label { font-weight: 600; color: #333; margin-bottom: 0.7rem; font-size: 0.95rem; }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; border-radius: 10px; padding: 0.9rem;
            font-weight: 600; font-size: 1rem; transition: all 0.3s ease; width: 100%; color: white;
        }
        .btn-login:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(102,126,234,0.4); color: white; }
        .demo-credentials {
            background-color: #f0f4ff; border-left: 5px solid #667eea;
            padding: 1.2rem; border-radius: 10px; margin-top: 1.5rem;
        }
        .demo-credentials h6 { font-weight: 700; color: #333; margin-bottom: 0.75rem; }
        .demo-credentials code { background-color: #e9ecef; padding: 0.3rem 0.6rem; border-radius: 4px; color: #e83e8c; font-weight: 600; }
        .signup-link { text-align: center; margin-top: 1.5rem; color: #666; }
        .signup-link a { color: #667eea; font-weight: 600; text-decoration: none; }
        .signup-link a:hover { text-decoration: underline; color: #764ba2; }
    </style>
</head>
<body>
<div class="login-container">
    <div class="card login-card">
        <div class="login-header">
            <h1>🔐 Connexion</h1>
            <p>Gestion des Produits</p>
        </div>
        <div class="card-body p-4">
            <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>❌ Erreur!</strong> <%= error %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            <% if (successMsg != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>✓ Succès!</strong> <%= successMsg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/views/login.jsp">
                <div class="mb-3">
                    <label for="email" class="form-label">📧 Adresse Email</label>
                    <input type="email" id="email" name="email" required
                           placeholder="exemple@domaine.com" class="form-control form-control-lg">
                </div>
                <div class="mb-2">
                    <label for="password" class="form-label">🔑 Mot de passe</label>
                    <input type="password" id="password" name="password" required
                           placeholder="Entrez votre mot de passe" class="form-control form-control-lg">
                </div>
                <div class="form-check mb-3">
                    <input type="checkbox" id="remember" name="remember" class="form-check-input">
                    <label class="form-check-label" for="remember">Se souvenir de moi</label>
                </div>
                <button type="submit" class="btn btn-login btn-lg w-100">Se Connecter</button>
            </form>

            <div class="demo-credentials">
                <h6>📝 Identifiants de Test</h6>
                <p class="mb-1"><small><strong>Admin:</strong> <code>admin@example.com</code> / <code>admin123</code></small></p>
                <p class="mb-1"><small><strong>User:</strong> <code>john@example.com</code> / <code>password123</code></small></p>
                <p class="mb-0"><small><strong>Manager:</strong> <code>manager@example.com</code> / <code>manager123</code></small></p>
            </div>
        </div>
        <div class="signup-link p-3">
            <p>Pas encore de compte? <a href="<%= request.getContextPath() %>/views/signup.jsp">S'inscrire ici</a></p>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
