<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="tableExplorer.xsl"?>

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


    <xsl:output method="html" indent="yes"
                doctype-public="-//W3C//DTD HTML 4.01//EN"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>


    <xsl:template match="/">
        <html>
            <head>
                <title>webDB-j (table explorer)</title>
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
                            <table name="responseHeader">
                                <xsl:apply-templates/>
                            </table>
                        </div>

                    </div>
                </div>

            </body>
        </html>
    </xsl:template>


    <xsl:template match="responseHeader">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="query">
        <tr>
            <td name="responseHeader">
                <strong>Query:&#xa0;</strong>
            </td>
            <td colspan="6">
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="numRecords">
        <tr>
            <td name="responseHeader">
                <strong>Tables in Database:&#xa0;</strong>
            </td>
            <td colspan="6">
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>

    <!-- Ignore these matches -->
    <xsl:template match="status"></xsl:template>
    <xsl:template match="numFields"></xsl:template>
    <xsl:template match="numFound"></xsl:template>
    <xsl:template match="SQLTime"></xsl:template>
    <xsl:template match="QTime"></xsl:template>


    <xsl:template match="responseBody">
        <xsl:for-each select="record">
            <tr>
                <td name="responseHeader" colspan="2">
                    <!--	      [<a href="/raw/?q=DESCRIBE+{string(field/value)}&amp;version=1"><xsl:value-of select="field/value"></xsl:value-of></a>] -->
                    [
                    <a
                            href="../raw/?q=SHOW+FULL+COLUMNS+FROM+{string(field/value)}&amp;version=1">
                        <xsl:value-of select="field/value"></xsl:value-of>
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=DESCRIBE+{string(field/value)}&amp;version=1">
                        Field Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SHOW+INDEX+FROM+{string(field/value)}&amp;version=1">
                        Index Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SHOW+KEYS+FROM+{string(field/value)}&amp;version=1">
                        Key Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+count%28*%29+AS+'{string(field/value)} Row Count'+FROM+{string(field/value)}&amp;version=1">
                        Row Count
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+TABLE_COMMENT+FROM+information_schema.tables+WHERE+TABLE_NAME+%3D%22{string(field/value)}%22%0D%0A&amp;version=1">
                        Comment
                    </a>
                    ]
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
