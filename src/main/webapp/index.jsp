<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<html>
<head><title>Login – Terminalbuchung</title></head>
<body>
<h2>Login: Kontaktperson auswählen</h2>
<form method="post" action="terminal_auswahl.jsp">
    <select name="kundennummer">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                System.out.println("Klasse nicht gefunden");
                throw new RuntimeException(e);
            }
            Connection conn = null;
            try {
                conn = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/raumhafen",
                        "root",
                        "365Pass"
                );
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT Kundennummer, Sozialversicherungsnummer FROM Kontaktperson");
                while(rs.next()) {
                    out.println("<option value='"
                            + rs.getInt(1)
                            + "'>Kundennummer: "
                            + rs.getInt(1)
                            + " (Sozialversicherungsnummer: "
                            + rs.getString(2)
                            + ")</option>");
                }
                conn.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        %>
        <option value="">Test</option>
    </select>
    <br>
    <input type="submit" value="Weiter zur Terminals-Auswahl">
</form>

</body>
</html>