<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>
<!-- $HeadURL$ -->
<!-- $LastChangedBy$ -->
<!-- $LastChangedDate$ -->
<!-- $LastChangedRevision$ -->
<!-- $Id$ -->
<html>
<head>
    <link rel="stylesheet" type="text/css"
          href="../admin/jtomyx-admin.css">
    <link rel="icon" href="../favicon.ico" type="image/ico">
    <link rel="shortcut icon" href="../favicon.ico" type="image/ico">
    <title>jtomyx admin page</title>
</head>

<body>
<%
    Context initCtx = new InitialContext();
    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    String type;
    try {
        type = (String) envCtx.lookup("jdbc/Type");
    } catch (NamingException nme) {
        type = "MySQL";
    }
%>
<a href="../admin/"><img border="0" align="right" height="37"
                         width="123" src="jtomyx-logo.gif" alt="jtomyx"></a>

<h1>jtomyx Admin</h1>
<br clear="all">

<table>

    <tr>
        <td><strong><%= type %> Server:</strong><br>
            <!--<em>#echo var="MySQLPoolHost" #echo var="MySQLPoolPort" -/em>--></td>
        <% if (type.toLowerCase().equals("mysql")) { %>
        <td>[<a href="../raw/?q=SHOW+PROCESSLIST&version=1">Proc Status</a>] [<a href="../raw/?q=SHOW+STATUS&version=1">Status</a>]
        </td>
        <% } else { %>
        <td>Status: TBD</td>
        <% } %>
    </tr>

</table>
<P>
<table>
    <tr>
        <td>
            <h3>Make a Query</h3>
        </td>
        <% if (type.toLowerCase().equals("mysql")) { %>
        <td>[<a href="../raw/?q=SHOW+TABLES&version=1&xsl=tableExplorer">Schema
            Explorer</a>] [<a href="../raw/?q=SHOW+TABLE+STATUS&version=1">Table
            Status</a>] [<a href="../raw/?q=SHOW+VARIABLES&version=1">Config</a>] [<a
                href="../raw/?q=SHOW+OPEN+TABLES&version=1">Open Tables</a>]
        </td>
        <% } %>
        <% if (type.toLowerCase().equals("oracle")) { %>
        <td>[<a href="../raw/?q=select+*+from+user_tables+ORDER+BY+TABLE_NAME&version=1&xsl=oraTableExplorer">Schema
            Explorer</a>]
        </td>
        <% } %>
        <% if (type.toLowerCase().equals("postgresql")) { %>
        <td>
            [<a href="../raw/?q=SELECT+table_name+FROM+information_schema.views+WHERE+table_schema+=+'public'&version=1&xsl=pgTableExplorer">Schema
            Explorer</a>]
        </td>
        <% } %>

        <td>[<a href="../admin/form.html">Full SQL Interface</a>]</td>
    </tr>
    <tr>
        <td></td>
        <td colspan=2>
            <form method="GET" action="../select/"><textarea rows="4"
                                                             cols="40" name="q"></textarea> <input name="getnumfound"
                                                                                                   type="hidden"
                                                                                                   value="1"> <input
                    name="version" type="hidden"
                    value="1"> <input name="start" type="hidden" value="0">
                <input name="rows" type="hidden" value="5"> <br>
                <input type="submit" value="search"></form>
        </td>
    </tr>
</table>
<p>
</body>
</html>
