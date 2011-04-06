<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="treeview.xsl"?>

<!-- $HeadURL$ -->
<!-- $LastChangedBy$ -->
<!-- $LastChangedDate$ -->
<!-- $LastChangedRevision$ -->
<!-- $Id$ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">


    <xsl:output method="html" indent="yes"
                doctype-public="-//W3C//DTD HTML 4.01//EN"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>


    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" type="text/css"
                      href="../admin/jtomyx-admin.css">
                </link>
                <link rel="icon" href="../favicon.ico" type="image/ico"></link>
                <link rel="shortcut icon" href="../favicon.ico"
                      type="image/ico">
                </link>
                <title>jtomyx Table Explorer</title>
            </head>
            <body>
                <a href="../admin/">
                    <img border="0" align="right" height="37"
                         width="123" src="../admin/jtomyx-logo.gif" alt="ATOMICS">
                    </img>
                </a>
                <h1>jtomyx Table Exporer</h1>
                <br clear="all"></br>
                <table name="responseHeader">
                    <!-- This isn't technically the responseHeader, but it's brief -->
                    <xsl:apply-templates/>
                </table>
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
            <td colspan='6'>
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

                    [
                    <a
                            href="../raw/?q=SELECT+*+FROM+USER_TAB_COLS+WHERE+TABLE_NAME='{string(field/value)}'&amp;version=1">
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
