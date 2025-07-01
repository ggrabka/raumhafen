<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String kundennummer = (String) session.getAttribute("kundennummer");
    String terminalnummer = (String) session.getAttribute("terminalnummer");

    String datum = request.getParameter("buchungsdatum");
    String beginn = request.getParameter("beginn");
    String ende = request.getParameter("ende");
    String typennummer = request.getParameter("typennummer");

    boolean erfolg = false;
    String fehler = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/raumhafen",
                "root",
                "365Pass");

        // Eindeutige Buchungsnummer generieren (z. B. durch MAX + 1)
        Statement maxStmt = conn.createStatement();
        ResultSet rs = maxStmt.executeQuery("SELECT COALESCE(MAX(Buchungsnummer), 1000) + 1 FROM Buchung_Terminal");
        rs.next();
        int neueNummer = rs.getInt(1);

        PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO Buchung_Terminal (Buchungsnummer, Buchungsdatum, Buchungszeit, Endzeit, Kundennummer, Terminalnummer, Typennummer) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );
        stmt.setInt(1, neueNummer);
        stmt.setDate(2, Date.valueOf(datum));
        stmt.setTimestamp(3, Timestamp.valueOf(beginn.replace("T", " ") + ":00"));
        stmt.setTimestamp(4, Timestamp.valueOf(ende.replace("T", " ") + ":00"));
        stmt.setInt(5, Integer.parseInt(kundennummer));
        stmt.setString(6, terminalnummer);
        stmt.setInt(7, Integer.parseInt(typennummer));

        stmt.executeUpdate();
        erfolg = true;

        conn.close();
    } catch (Exception e) {
        fehler = e.getMessage();
    }
%>
<html>
<head><title>Buchung Bestaetigung</title></head>
<body>
<h2>Buchungsstatus</h2>
<% if (erfolg) { %>
<p style="color:green;">Buchung erfolgreich gespeichert!</p>
<% } else { %>
<p style="color:red;">Fehler bei der Buchung: <%= fehler %></p>
<% } %>
<a href="index.jsp">Neue Buchung starten</a>
</body>
</html>
