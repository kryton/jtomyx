<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="treeview.xsl"?>

<!-- $HeadURL$ -->
<!-- $LastChangedBy$ -->
<!-- $LastChangedDate$ -->
<!-- $LastChangedRevision$ -->
<!-- $Id$ -->

<!-- Creates a collapsible node tree in the manner of Internet Explorer -->
<!-- Author: Dave Lindquist (http://www.gazingus.org) -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
    <xsl:output method="html" indent="yes"
                doctype-public="-//W3C//DTD HTML 4.01//EN"
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

    <xsl:template match="/">
        <html>
            <head>
                <title></title>
                <style type="text/css">
                    body { color: #00f; font: 10pt Verdana; margin: 0px;
                    padding: 15px 75px 15px 10px; } ul { list-style:
                    none outside; } li { list-style: none outside;
                    margin-left: -28px; line-height: 1.25em; } .switch {
                    color: #f00; font-family: monospace; padding-right:
                    5px; } .element { color: #900; } .comment { color:
                    #999; font-family: monospace; } .text { color: #000;
                    font-weight: bold; } .processing-instruction {}
                    .attribute-key { color: #900; } .attribute-value {
                    color: #000; font-weight: bold; } .namespace-key {
                    color: #f00; } .namespace-value { color: #f00;
                    font-weight: bold; } a.parent-element { color: #00f;
                    text-decoration: none; width: 100%; margin-left:
                    -13px; }
                </style>
                <script type="text/javascript">
                    function switchNode(nodeRef) { var div =
                    nodeRef.parentNode.getElementsByTagName("div").item(0);
                    var span =
                    nodeRef.getElementsByTagName("span").item(0); var
                    display = div.style.display; var symbol = (display
                    == "none") ? "-" : "+"; div.style.display = (display
                    == "none") ? "block" : "none";
                    span.replaceChild(document.createTextNode(symbol),span.childNodes.item(0));
                    }
                </script>
            </head>
            <body>
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*">
        <li>
            <xsl:choose>
                <xsl:when
                        test="count(text()) = 1 and count(*) = 0 and count(comment()) = 0 and count(processing-instruction()) = 0">
                    <xsl:text>&lt;</xsl:text>
                    <span class="element">
                        <xsl:value-of select="name()"/>
                    </span>
                    <xsl:apply-templates select="@*"/>
                    <xsl:if test=". = /">
                        <xsl:for-each select="namespace::*">
                            <xsl:call-template name="namespace-node"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:call-template name="text-only"/>
                </xsl:when>
                <xsl:when test="*|comment()|processing-instruction()">
                    <a href="javascript:void(0)"
                       onclick="switchNode(this);return false" class="parent-element">
                        <span class="switch">-</span>
                        <xsl:text>&lt;</xsl:text>
                        <span class="element">
                            <xsl:value-of select="name()"/>
                        </span>
                        <xsl:apply-templates select="@*"/>
                        <xsl:if test=". = /">
                            <xsl:for-each select="namespace::*">
                                <xsl:call-template
                                        name="namespace-node"/>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:text>&gt;</xsl:text>
                    </a>
                    <div>
                        <ul>
                            <xsl:apply-templates/>
                        </ul>
                        <xsl:text>&lt;/</xsl:text>
                        <span class="element">
                            <xsl:value-of select="name()"/>
                        </span>
                        <xsl:text>&gt;</xsl:text>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&lt;</xsl:text>
                    <span class="element">
                        <xsl:value-of select="name()"/>
                    </span>
                    <xsl:apply-templates select="@*"/>
                    <xsl:if test=". = /">
                        <xsl:for-each select="namespace::*">
                            <xsl:call-template name="namespace-node"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:text> /&gt;</xsl:text>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:text> </xsl:text>
        <span class="attribute-key">
            <xsl:value-of select="name()"/>
        </span>
        <xsl:text>=&quot;</xsl:text>
        <span class="attribute-value">
            <xsl:value-of select="."/>
        </span>
        <xsl:text>&quot;</xsl:text>
    </xsl:template>

    <xsl:template match="comment()">
        <li>
            <xsl:text>&lt;!-- </xsl:text>
            <span class="comment">
                <xsl:value-of select="."/>
            </span>
            <xsl:text> --&gt;</xsl:text>
        </li>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <li>
            <xsl:text>&lt;?</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>?&gt;</xsl:text>
        </li>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:if test="string-length(normalize-space(.))">
            <li class="text">
                <xsl:value-of select="normalize-space(.)"/>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template name="text-only">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space(.))">
                <xsl:text>&gt;</xsl:text>
                <span class="text">
                    <xsl:value-of select="normalize-space(.)"/>
                </span>
                <xsl:text>&lt;/</xsl:text>
                <span class="element">
                    <xsl:value-of select="name()"/>
                </span>
                <xsl:text>&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&gt;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="namespace-node">
        <xsl:if test="name() != 'xml'">
            <span class="namespace-key">
                <xsl:text> xmlns:</xsl:text>
                <xsl:value-of select="name()"/>
            </span>
            <xsl:text>=&quot;</xsl:text>
            <span class="namespace-value">
                <xsl:value-of select="."/>
            </span>
            <xsl:text>&quot;</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
