<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page session="true" %>
<%
    String kundennummer = request.getParameter("kundennummer");
    if (kundennummer != null) {
        session.setAttribute("kundennummer", kundennummer);
    } else {
        kundennummer = (String) session.getAttribute("kundennummer");
    }
%>
<html>
<head><title>Terminal auswaehlen</title></head>
<body>
<h2>Terminal auswaehlen fuer Buchung</h2>
<form method="post" action="buchung_formular.jsp">
    <select name="terminalnummer">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/raumhafen",
                        "root",
                        "365Pass");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT Terminalnummer FROM Terminal");
                while (rs.next()) {
                    out.println("<option value='" + rs.getString(1) + "'>" + rs.getString(1) + "</option>");
                }
                conn.close();
            } catch (Exception e) {
                System.out.println("Fehler beim Laden der Terminals: " + e.getMessage());
            }
        %>
    </select>
    <br><input type="submit" value="Weiter zur Buchung">
</form>
</body>
</html>