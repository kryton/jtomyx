<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="tabular.xsl"?>

<!-- $HeadURL$ -->
<!-- $LastChangedBy$ -->
<!-- $LastChangedDate$ -->
<!-- $LastChangedRevision$ -->
<!-- $Id$ -->
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.OperationNotSupportedException" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.logging.Logger" %>
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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
     <xsl:strip-space elements="query" />

    <xsl:output method="html" indent="yes"
                doctype-public="-//W3C//DTD HTML 4.01//EN"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>


    <xsl:template match="/">
        <html>
            <head>
                <title>webDB-j</title>
                 <%@include file="../inc/head.jsp" %>
            </head>
            <body>
                <jsp:include page="../inc/header.jsp">
                    <jsp:param name="type" value="<%= type %>"/>
                    <jsp:param name="jdbcString" value="<%=jdbcString %>"/>
                </jsp:include>
                <div class="container-fluid">
                    <div class="row">
                        <jsp:include page="../inc/navbar.jsp">
                            <jsp:param name="type" value="<%= type %>"/>
                            <jsp:param name="jdbcString" value="<%=jdbcString %>"/>
                        </jsp:include>
                        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
               <h1 class="page-header">Results</h1>
                <xsl:apply-templates/>
                            </div>
                </div>
                </div>
            </body>
        </html>
    </xsl:template>


    <xsl:template match="responseHeader">
        <table name="responseHeader">
            <xsl:apply-templates/>
        </table>
        <hr/>
        <form method="GET" action="../select/">
            <textarea rows="4" cols="40" name="q"><xsl:value-of select="normalize-space(query)"></xsl:value-of></textarea>
            <input name="getnumfound" type="hidden" value="1"/>
            <input name="version" type="hidden" value="1"/>
            <input name="start" type="hidden" value="0"/>
            <input name="rows" type="hidden" value="5"/>
            <br/>
            <input type="submit" value="search"/>
        </form>

    </xsl:template>


    <xsl:template match="status">
        <tr>
            <td name="responseHeader">
                <strong>Status:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="query">
        <tr>
            <td name="responseHeader">
                <strong>Query:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="sqlException">
        <hr/>
        <strong>Exception:&#xa0;</strong>

        <pre>
            <xsl:value-of select="."></xsl:value-of>
        </pre>

    </xsl:template>


    <xsl:template match="numFields">
        <tr>
            <td name="responseHeader">
                <strong>Number of Fields:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="numRecords">
        <tr>
            <td name="responseHeader">
                <strong>Records Returned:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="numFound">
        <tr>
            <td name="responseHeader">
                <strong>Records Found:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="SQLTime">
        <tr>
            <td name="responseHeader">
                <strong>Query time:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
                (ms)
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="QTime">
        <tr>
            <td name="responseHeader">
                <strong>Query time:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
                (ms)
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="responseBody">
        <table border="2">
             <thead>
            <!-- table headers -->
            <tr>
                <xsl:for-each select="record[1]/field">
                    <th name="responseBody">
                        <xsl:value-of select="name"></xsl:value-of>
                    </th>
                </xsl:for-each>
            </tr>
            </thead>

            <!-- table rows -->
            <tbody>

            <xsl:for-each select="record">
                <tr>
                    <xsl:for-each select="field">
                        <td>
                            <xsl:value-of select="value"></xsl:value-of>
                            &#xa0;
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each>

            </tbody>
        </table>

    </xsl:template>
</xsl:stylesheet>
