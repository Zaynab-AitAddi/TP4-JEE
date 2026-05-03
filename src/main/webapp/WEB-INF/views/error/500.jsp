<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur serveur - 500</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-container {
            text-align: center;
            color: white;
            max-width: 600px;
        }
        .error-code {
            font-size: 120px;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }
        .error-icon {
            font-size: 80px;
            margin-bottom: 1rem;
        }
        .error-message h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        .error-message p {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.95;
            line-height: 1.6;
        }
        .error-details {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
        }
        .error-details p {
            margin: 0;
            font-size: 0.95rem;
        }
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .error-actions a {
            display: inline-block;
            padding: 0.75rem 2rem;
            background-color: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        .error-actions a:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }
        .error-actions a.secondary {
            background-color: transparent;
            color: white;
            border: 2px solid white;
        }
        .error-actions a.secondary:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <div class="error-code">500</div>
        <div class="error-message">
            <h1>Erreur Serveur</h1>
            <p>Une erreur interne du serveur s'est produite.</p>
        </div>

        <div class="error-details">
            <p>
                <strong>Que faire?</strong><br>
                Une erreur inattendue s'est produite sur le serveur. Notre équipe technique a été notifiée. 
                Veuillez réessayer plus tard ou contacter le support.
            </p>
        </div>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/dashboard">🏠 Retour à l'Accueil</a>
            <a href="${pageContext.request.contextPath}/login" class="secondary">🔐 Page de Connexion</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-message">
            <h1>Erreur serveur</h1>
            <p>Une erreur inattendue s'est produite. Veuillez réessayer plus tard.</p>
        </div>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/dashboard">Retour au tableau de bord</a>
            <a href="${pageContext.request.contextPath}/login">Connexion</a>
        </div>
    </div>
</body>
</html>
