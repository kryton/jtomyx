<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="treeview.xsl"?>

<!-- $HeadURL$ -->
<!-- $LastChangedBy$ -->
<!-- $LastChangedDate$ -->
<!-- $LastChangedRevision$ -->
<!-- $Id$ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
     <xsl:strip-space elements="query" />

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
                         width="123" src="../admin/jtomyx-logo.gif" alt="jtomyx">
                    </img>
                </a>
                <h1>jtomyx Search Results</h1>
                <br clear="all"></br>
                <xsl:apply-templates/>
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
