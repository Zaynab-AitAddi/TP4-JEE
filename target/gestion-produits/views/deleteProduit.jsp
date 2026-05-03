<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="metier.ProduitMetier, dao.model.User, dao.model.Role" %>
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

    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=ID+produit+manquant");
        return;
    }

    try {
        Long id = Long.parseLong(idStr);
        if (ProduitMetier.getInstance().deleteProduit(id)) {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?success=Produit+supprime+avec+succes");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=Erreur+lors+de+la+suppression");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp?error=ID+produit+invalide");
    }
%>
