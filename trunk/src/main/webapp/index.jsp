<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.OperationNotSupportedException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.logging.Logger" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
<head>
    <title>webDB-j</title>
    <%@include file="inc/head.jsp" %>
</head>
<body>
<%
    String type = "MySQL";
    String jdbcString = "undetermined";
    try {
        Context initCtx = new InitialContext();
        Context envCtx = (Context) initCtx.lookup("java:comp/env");

        type = (String) envCtx.lookup("jdbc/Type");
        DataSource ds = (DataSource) envCtx.lookup("jdbc/" + type);
        String url = ds.getConnection().getMetaData().getURL();
        jdbcString = url.replaceFirst("jdbc:.*?://", "");
        jdbcString = jdbcString.replaceFirst("\\?.*$", "");
        envCtx.close();

    } catch (OperationNotSupportedException ignore) {
    } catch (Exception nme) {
        Logger l = Logger.getAnonymousLogger();
        l.warning(nme.getMessage());
    }
%>
<jsp:include page="inc/header.jsp">
    <jsp:param name="type" value="<%= type %>"/>
    <jsp:param name="jdbcString" value="<%=jdbcString %>"/>
</jsp:include>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="inc/navbar.jsp">
            <jsp:param name="type" value="<%= type %>"/>
            <jsp:param name="jdbcString" value="<%=jdbcString %>"/>
        </jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h1 class="page-header">Select</h1>

            <form method="GET" action="./select/" role="form" class="form-horizontal">
                <input name="version" type="hidden" value="1">

                <div class="form-group">
                    <label for="q">SQL Statement (Select Only)</label>
                    <textarea id="q" class="form-control" rows="4" name="q" ></textarea>
                </div>
                <div class="checkbox">
                    <label for="getnumfound">
                        <input id="getnumfound" name="getnumfound" type="checkbox" value="checked">
                        Show # found
                    </label>
                </div>
                <div class="form-group">
                    <label for="start" class="col-sm-2 control-label">Start Row</label>

                    <div class="col-sm-10">
                        <input name="start" id="start" class='form-control' type="text" value="0" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="rows" class="col-sm-2 control-label"># of Rows</label>

                    <div class="col-sm-10">
                        <input name="rows" id="rows" class='form-control' type="text" value="10"/>
                    </div>
                </div>
                <div class="form-group">
                    <input type="submit" value="search" class="btn btn-default btn-primary"/>
                </div>
            </form>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <h1>Raw</h1>

            <form method="GET" action="./raw/" role="form" class="form-horizontal">


                <input name="version" type="hidden" value="1">

                <div class="form-group">
                    <label for="qr">SQL Statement</label>
                    <textarea id="qr" class="form-control" rows="4" name="q"></textarea>
                </div>
                <input type="submit" value="search" class="btn btn-default btn-primary"/>
            </form>


        </div>
    </div>
</div>
<!--
$LastChangedDate$<br>
$LastChangedRevision: 2
-->
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/1.11.0/jquery.min.js" type="text/javascript">
</script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js" type="text/javascript">
</script>
<script src="./js/docs.min.js" type="text/javascript"></script>
</body>
</html>
