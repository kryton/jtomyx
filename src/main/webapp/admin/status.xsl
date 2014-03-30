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
                <title>webDB Status</title>
            </head>
            <body>
                <a href="../admin/">
                    <img border="0" align="right" height="37"
                         width="230" src="../admin/jtomyx-logo.gif" alt="ATOMICS">
                    </img>
                </a>
                <h1>webDB Status</h1>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>


    <xsl:template match="atomicsStatus">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="atomics">
        <br clear="all"></br>
        <h2>mod_atomics</h2>
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>


    <xsl:template match="atomics/svnHeadURL">
        <tr>
            <td align="right">
                <strong>SVN Head URL:&#xa0;</strong>
            </td>
            <td>
                <tt>
                    <xsl:value-of select="."/>
                </tt>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="atomics/svnLastChangedBy">
        <tr>
            <td align="right">
                <strong>SVN Last Changed By:&#xa0;</strong>
            </td>
            <td>
                <tt>
                    <xsl:value-of select="."/>
                </tt>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="atomics/svnLastChangedDate">
        <tr>
            <td align="right">
                <strong>SVN Last Changed Date:&#xa0;</strong>
            </td>
            <td>
                <tt>
                    <xsl:value-of select="."/>
                </tt>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="atomics/svnLastChangedRevision">
        <tr>
            <td align="right">
                <strong>SVN Last Changed Revision:&#xa0;</strong>
            </td>
            <td>
                <tt>
                    <xsl:value-of select="."/>
                </tt>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="atomics/svnId">
        <tr>
            <td align="right">
                <strong>SVN ID:&#xa0;</strong>
            </td>
            <td>
                <tt>
                    <xsl:value-of select="."/>
                </tt>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="mysql">
        <br></br>
        <br></br>
        <br></br>
        <h2>MySQL</h2>
        <table>
            <xsl:for-each select="*">
                <tr>
                    <td align="right">
                        <strong>
                            <xsl:value-of select="name()"/>
                            :&#xa0;
                        </strong>
                    </td>
                    <td>
                        <tt>
                            <xsl:value-of select="."/>
                            &#xa0;
                        </tt>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>


</xsl:stylesheet>
