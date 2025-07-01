<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page session="true" %>
<%
    String terminalnummer = request.getParameter("terminalnummer");
    if (terminalnummer != null) {
        session.setAttribute("terminalnummer", terminalnummer);
    } else {
        terminalnummer = (String) session.getAttribute("terminalnummer");
    }
%>
<html>
<head><title>Buchungsdaten eingeben</title></head>
<body>
<h2>Buchung fuer Terminal: <%= terminalnummer %></h2>
<form method="post" action="buchung_bestaetigung.jsp">
    Buchungsdatum: <input type="date" name="buchungsdatum" required><br>
    Beginnzeit: <input type="datetime-local" name="beginn" required><br>
    Endzeit: <input type="datetime-local" name="ende" required><br>
    Raumschifftyp:
    <select name="typennummer">
        <%
            try {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
                Connection conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/raumhafen",
                        "root",
                        "365Pass");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT Typennummer, Typenbezeichnung FROM Raumschifftyp");
                while (rs.next()) {
                    out.println("<option value='" + rs.getInt("Typennummer") + "'>" +
                            rs.getString("Typenbezeichnung") + " (Typ " + rs.getInt("Typennummer") + ")</option>");
                }
                conn.close();
            } catch (SQLException e) {
                System.out.println("Fehler beim Laden der Typen: " + e.getMessage());
            }
        %>
    </select><br>
    <input type="submit" value="Buchung abschliessen">
</form>
</body>
</html>