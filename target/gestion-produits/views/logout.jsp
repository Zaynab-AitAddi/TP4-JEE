<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%
    HttpSession existingSession = request.getSession(false);
    if (existingSession != null) {
        existingSession.invalidate();
    }
    response.sendRedirect(request.getContextPath() + "/views/login.jsp");
%>
