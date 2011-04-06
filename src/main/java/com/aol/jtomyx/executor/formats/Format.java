package com.aol.jtomyx.executor.formats;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import java.text.SimpleDateFormat;

/**
 * Created by IntelliJ IDEA.
 * User: ianholsman
 * Date: Aug 8, 2008
 * Time: 2:06:31 PM
 * <p/>
 * COPYRIGHT  (c)  2008 AOL LLC, Inc.
 * All Rights Reserved.
 * <p/>
 * PROPRIETARY - INTERNAL AOL USE ONLY
 * This document contains proprietary information that shall be
 * distributed, routed, or made available only within AOL,
 * except with written permission of AOL.
 */
public abstract class Format {
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat DATE_TIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    /**
     * @param sqe      SQLException that occured
     * @param os       the output stream
     * @param query    the query sent
     * @param xsl      the XSL format
     * @param response the thing to write into
     * @throws IOException on error
     */

    abstract public void writeExceptionResults(SQLException sqe, OutputStream os,
                                               String query, String xsl, HttpServletResponse response) throws IOException;

    /**
     * This function is used for sending response for statements
     * other than select
     *
     * @param os            the output stream
     * @param query         the query sent
     * @param queryExecTime how long it took
     * @param recordCount   how many records we have
     * @param xsl           the XSL format
     * @param response      the thing to write into
     * @throws IOException  on error
     * @throws SQLException on SQL exception
     */
    abstract public void writeRawResults(OutputStream os,
                                         String query, double queryExecTime, int recordCount,
                                         String xsl, HttpServletResponse response)
            throws SQLException, IOException;

    /**
     * @param rs            result one
     * @param rs_numfound   result two
     * @param os            output stream
     * @param query         the query sent
     * @param queryExecTime how long it took
     * @param xsl           the style sheet to use
     * @param start         the start record
     * @param rows          the number of rows returned
     * @param response      the Response object
     * @throws SQLException SQL Error
     * @throws IOException  IO Error
     */
    abstract public void writeSelectResults(ResultSet rs, ResultSet rs_numfound, OutputStream os,
                                            String query, double queryExecTime, String xsl, String start, String rows,
                                            HttpServletResponse response)
            throws SQLException, IOException;

    protected String getNumResults(ResultSet rs, ResultSet rs_numfound) throws SQLException {

        if (rs_numfound == null) {
            rs.last();
            long count = rs.getRow();
            rs.first();
            rs.previous();
            return count + "";
        } else {
            if (rs_numfound.next()) {
                return (String.valueOf(rs_numfound.getObject("FOUND_ROWS()")));
            }
        }
        return 0 + "";
    }

    protected byte[] getXMLReadyValue(ResultSet rs, int columnIndex) throws SQLException {
        ResultSetMetaData md = rs.getMetaData();
        int type = md.getColumnType(columnIndex);
        Timestamp time;

        switch (type) {
            case Types.NULL:
                return "".getBytes();
            case Types.BLOB:
            case Types.CLOB:
                return rs.getBytes(columnIndex);
            case Types.DATE:
                time = rs.getTimestamp(columnIndex);
                if (time == null) return "0000-00-00 00:00:00".getBytes();
                else
                    return DATE_FORMAT.format(rs.getDate(columnIndex)).getBytes();
            case Types.TIMESTAMP:
            case Types.TIME:
                time = rs.getTimestamp(columnIndex);
                if (time == null) return "0000-00-00 00:00:00".getBytes();
                else return (DATE_TIME_FORMAT.format(time)).getBytes();
            default:
                String str = rs.getString(columnIndex);
                if (str == null) return "".getBytes();
                str = encodeInvalidXMLChars(str);
                return str.getBytes();

        }

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
                return "string";
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


    /**
     * make the string a valid XML string
     *
     * @param string the input string
     * @return XML-escaped string
     */
    public static String encodeInvalidXMLChars(String string) {
        int len = string.length();
        int ci;
        char c;
        int chescape;

        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            chescape = c = string.charAt(i);
            ci = 0xffff & c;

            switch (chescape) {
                case '<':
                    sb.append("&lt;");
                    continue;
                case '>':
                    sb.append("&gt;");
                    continue;
                case '&':
                    sb.append("&amp;");
                    continue;
                case '"':
                    sb.append("&quot;");
                    continue;
                case '\'':
                    sb.append("&apos;");
                    continue;

                default:
                    break;
            }

            if (ci >= 32 || c == '\n' || c == '\t') {
                // for ASCII control characters (less than 32), do nothing
                if (ci < 160)
                    // nothing special only 7 Bit
                    sb.append(c);
                else {
                    // Not 7 Bit use the unicode system
                    sb.append("&#x");
                    sb.append(Integer.toHexString(ci));
                    sb.append(';');
                }
            }


        }

        return sb.toString();
    }
}
