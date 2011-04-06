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
            <td colspan='5'>
                <xsl:value-of select="."></xsl:value-of>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="numRecords">
        <tr>
            <td name="responseHeader">
                <strong>Tables in Database:&#xa0;</strong>
            </td>
            <td colspan="5">
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
                <td name="responseHeader">

                    [
                    <a
                            href="../raw/?q=SELECT+column_name+as+field,data_type+as+type,character_maximum_length+as+field_length,is_nullable+as+null,column_default+as+default+FROM+information_schema.columns+WHERE+table_name+=+'{string(field/value)}'&amp;version=1">
                        <xsl:value-of select="field/value"></xsl:value-of>
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+column_name+as+field,data_type+as+type,character_maximum_length+as+field_length,is_nullable+as+null,column_default+as+default+FROM+information_schema.columns+WHERE+table_name+=+'{string(field/value)}'&amp;version=1">
                        Field Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+n.nspname+as+Schema,+c2.relname+as+Table,+c.relname+as+Key_name,+CASE+c.relkind+WHEN+'r'+THEN+'table'+WHEN+'v'+THEN+'view'+WHEN+'i'+THEN+'index'+WHEN+'S'+THEN+'sequence'+WHEN+'s'+THEN+'special'+END+as+Type,+r.rolname+as+Owner+FROM+pg_catalog.pg_class+c+JOIN+pg_catalog.pg_roles+r+ON+r.oid+=+c.relowner+LEFT+JOIN+pg_catalog.pg_namespace+n+ON+n.oid+=+c.relnamespace+LEFT+JOIN+pg_catalog.pg_index+i+ON+i.indexrelid+=+c.oid+LEFT+JOIN+pg_catalog.pg_class+c2+ON+i.indrelid+=+c2.oid+WHERE+c.relkind+IN+('i','')+AND+n.nspname+NOT+IN+('pg_catalog',+'pg_toast')+AND+pg_catalog.pg_table_is_visible(c.oid)+AND+c2.relname+=+'{string(field/value)}'+ORDER BY 1,2&amp;version=1">
                        Index Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+t.relname+AS+table,+c.conname+AS+key_name,+CASE+c.contype+WHEN+'c'+THEN+'CHECK'+WHEN+'f'+THEN+'FOREIGN+KEY'+WHEN+'p'+THEN+'PRIMARY+KEY'+WHEN+'u'+THEN+'UNIQUE'+END+AS+constraint_type,+CASE+WHEN+c.condeferrable+=+'f'+THEN+0+ELSE+1+END+AS+is_deferrable,+CASE+WHEN+c.condeferred+=+'f'+THEN+0+ELSE+1+END+AS+is_deferred,+array_to_string(c.conkey,+'+')+AS+constraint_key,+CASE+confupdtype+WHEN+'a'+THEN+'NO+ACTION'+WHEN+'r'+THEN+'RESTRICT'+WHEN+'c'+THEN+'CASCADE'+WHEN+'n'+THEN+'SET+NULL'+WHEN+'d'+THEN+'SET+DEFAULT'+END+AS+on_update,+CASE+confdeltype+WHEN+'a'+THEN+'NO+ACTION'+WHEN+'r'+THEN+'RESTRICT'+WHEN+'c'+THEN+'CASCADE'+WHEN+'n'+THEN+'SET+NULL'+WHEN+'d'+THEN+'SET+DEFAULT'+END+AS+on_delete,+CASE+confmatchtype+WHEN+'u'+THEN+'UNSPECIFIED'+WHEN+'f'+THEN+'FULL'+WHEN+'p'+THEN+'PARTIAL'+END+AS+match_type,+t2.relname+AS+references_table,+array_to_string(c.confkey,+'+')+AS+fk_constraint_key+FROM+pg_constraint+c+LEFT+JOIN+pg_class+t++ON+c.conrelid++=+t.oid+LEFT+JOIN+pg_class+t2+ON+c.confrelid+=+t2.oid+WHERE+t.relname+=+'{string(field/value)}'&amp;version=1">
                        Constraints Info
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [
                    <a name="smallLink"
                       href="../raw/?q=SELECT+count%28*%29+AS+row_count+FROM+{string(field/value)}&amp;version=1">
                        Row Count
                    </a>
                    ]
                </td>
                <td name="responseHeader">
                    [Comment]
                </td>
            </tr>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
