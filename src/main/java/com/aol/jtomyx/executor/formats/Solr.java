package com.aol.jtomyx.executor.formats;

import com.aol.jtomyx.executor.ColumnMetaData;
import com.aol.jtomyx.executor.QueryExecutor;

import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

/**
 * Created by IntelliJ IDEA.
 * User: ianholsman
 * Date: Aug 8, 2008
 * Time: 2:06:06 PM
 * <p/>
 * COPYRIGHT  (c)  2008 AOL LLC, Inc.
 * All Rights Reserved.
 * <p/>
 * PROPRIETARY - INTERNAL AOL USE ONLY
 * This document contains proprietary information that shall be
 * distributed, routed, or made available only within AOL,
 * except with written permission of AOL.
 */
public class Solr extends Format {

    public void writeExceptionResults(SQLException sqe, OutputStream os,
                                      String query, String xsl, HttpServletResponse response) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(os);
        String xmlStr = "<?xml-stylesheet type=\"text/xsl\" href=\"../admin/" + xsl + ".xsl?>";
        response.setContentType("text/xml");
        response.setCharacterEncoding("UTF-8");
        bos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>".getBytes());
        bos.write(xmlStr.getBytes());
        bos.write("<response xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://atomics.aol.com/cnet-search/response.xsd\">".getBytes());
        bos.write("<responseHeader>".getBytes());
        bos.write("<status>".getBytes());
        bos.write((sqe.getErrorCode() + "").getBytes());
        bos.write("</status>".getBytes());

        bos.write("<q>".getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</q>".getBytes());
        bos.write("</responseHeader>".getBytes());
        bos.write("<sqlException>".getBytes());
        sqe.printStackTrace(new PrintStream(bos));
        bos.write("</sqlException>".getBytes());
        bos.write("</response>".getBytes());
        bos.flush();
    }

    /**
     * This function is used for sending response on success for statements
     * using select
     */
    public void writeSelectResults(ResultSet rs, ResultSet rs_numfound, OutputStream os,
                                   String query, double queryExecTime, String xsl, String start, String rows,
                                   HttpServletResponse response)
            throws SQLException, IOException {
        ColumnMetaData[] colMetadata = QueryExecutor.getMetaData(rs);
        BufferedOutputStream bos = new BufferedOutputStream(os);
        response.setContentType("text/xml");
        response.setCharacterEncoding("UTF-8");

        bos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        bos.write("<response>\n".getBytes());
        bos.write("<lst name=\"responseHeader\">\n".getBytes());
        bos.write("<int name=\"status\">".getBytes());
        bos.write("0".getBytes());
        bos.write("</int>\n".getBytes());
        bos.write("<int name=\"numFields\">".getBytes());
        bos.write((colMetadata.length + "").getBytes());
        bos.write("</int>\n".getBytes());
        bos.write("<int name=\"numRecords\">".getBytes());
        bos.write(getNumResults(rs, rs_numfound).getBytes());
        bos.write("</int>\n".getBytes());
        bos.write("<int name=\"QTime\">".getBytes());
        bos.write(("" + queryExecTime + " sec").getBytes());
        bos.write("</int>\n".getBytes());

        bos.write(("<lst name=\"params\">\n").getBytes());
        bos.write(("<str name=\"indent\">on</str>\n").getBytes());
        bos.write(("<str name=\"start\">").getBytes());
        if (start != null) bos.write(start.getBytes());
        bos.write("</str>\n".getBytes());
        bos.write(("<str name=\"q\">").getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</str>\n".getBytes());
        bos.write(("<str name=\"rows\">").getBytes());
        if (rows != null) bos.write(rows.getBytes());
        bos.write("</str>\n".getBytes());
        bos.write(("<str name=\"version\">1.0</str>\n").getBytes());
        bos.write("</lst>\n".getBytes());

        bos.write("</lst>".getBytes());
        bos.flush();
        bos.write(("<result name=\"response\" numFound = \""
                + colMetadata.length + "\" "
                + " start=\"" + start + "\">\n").getBytes());

        while (rs.next()) {
            bos.write("<doc>\n".getBytes());
            for (int i = 0; i < colMetadata.length; i++) {
                String name = colMetadata[i].getColumnName();
                String type; //= colMetadata[i].getColumnType();
                byte[] value = getXMLReadyValue(rs, i + 1);
                name = encodeInvalidXMLChars(name);
                type = setType(rs, i + 1);

                bos.write(("<" + type + " name=\"" + name + "\">").getBytes());
                bos.write(value);
                bos.write(("</" + type + ">\n").getBytes());

            }
            bos.write("</doc>\n".getBytes());
        }

        bos.write("</result>\n".getBytes());
        bos.write("</response>\n".getBytes());
        bos.flush();
    }

    /**
     * This function is used for sending response for statements
     * other than select
     */
    public void writeRawResults(OutputStream os,
                                String query, double queryExecTime, int recordCount,
                                String xsl, HttpServletResponse response)
            throws SQLException, IOException {
        BufferedOutputStream bos = new BufferedOutputStream(os);
        response.setContentType("text/xml");
        response.setCharacterEncoding("UTF-8");

        bos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());

        bos.write("<response>\n".getBytes());
        bos.write("<lst name=\"responseHeader\">\n".getBytes());
        bos.write("<int name=\"status\">\n".getBytes());
        bos.write("0".getBytes());
        bos.write("</int>\n".getBytes());
        bos.write("<int name=\"affectedRows\">".getBytes());
        bos.write(("" + recordCount + "").getBytes());
        bos.write("</int>\n".getBytes());
        bos.write(("<str name=\"q\">").getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</str>\n".getBytes());
        bos.write("<int name=\"QTime\">".getBytes());
        bos.write(("" + queryExecTime + " sec").getBytes());
        bos.write("</int>\n".getBytes());

        bos.write("</lst>\n".getBytes());
        bos.write("</response>\n".getBytes());
        bos.flush();

    }

    protected static String setType(ResultSet rs, int columnIndex) throws SQLException {
        ResultSetMetaData md = rs.getMetaData();
        int type = md.getColumnType(columnIndex);

        switch (type) {

            case Types.BLOB:
            case Types.CLOB:
            case Types.CHAR:
            case Types.LONGVARCHAR:
            case Types.VARCHAR:
                return "str";
            case Types.DATE:
            case Types.TIME:
            case Types.TIMESTAMP:
                return "date";
            case Types.DECIMAL:
            case Types.DOUBLE:
            case Types.FLOAT:
                return "float";
            case Types.BIGINT:
            case Types.INTEGER:
            case Types.NUMERIC:
            case Types.REAL:
            case Types.SMALLINT:
            case Types.TINYINT:
            default:
                return "integer";

        }
    }

}