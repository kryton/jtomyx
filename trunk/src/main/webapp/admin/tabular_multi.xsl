<?xml version="1.0" encoding="utf-8"?>
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
                <title>jtomyx Search Results</title>
            </head>
            <body>
                <a href="../admin/">
                    <img border="0" align="right" height="37"
                         width="123" src="../admin/jtomyx-logo.gif" alt="ATOMICS">
                    </img>
                </a>
                <h1>jtomyx Search Results</h1>
                <br clear="all"></br>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="result">
        <br/>
        <xsl:apply-templates/>

    </xsl:template>


    <xsl:template match="responseHeader">
        <table name="responseHeader">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="resultnumber">
        <tr>
            <td name="responseHeader">
                <strong>Result #:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="resultcount">
        <hr/>
        <strong># Results:&#xa0;</strong>
        <xsl:value-of select="."></xsl:value-of>
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

    <xsl:template match="affectedRows">
        <tr>
            <td name="responseHeader">
                <strong>Rows Affected:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
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

    <xsl:template match="SPROCTIME">
        <tr>
            <td name="responseHeader">
                <strong>Proc time:&#xa0;</strong>
            </td>
            <td>
                <xsl:value-of select="."></xsl:value-of>
                (ms)
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="responseBody">
        <br></br>
        <br></br>
        <table border="2">

            <!-- table headers -->
            <tr>
                <xsl:for-each select="record[1]/field">
                    <th name="responseBody">
                        <xsl:value-of select="name"></xsl:value-of>
                    </th>
                </xsl:for-each>
            </tr>

            <!-- table rows -->
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

        </table>


    </xsl:template>


</xsl:stylesheet>
