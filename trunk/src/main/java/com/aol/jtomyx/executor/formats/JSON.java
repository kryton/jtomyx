package com.aol.jtomyx.executor.formats;

import com.aol.jtomyx.executor.ColumnMetaData;
import com.aol.jtomyx.executor.QueryExecutor;

import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
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
public class JSON extends Format {

    public void writeExceptionResults(SQLException sqe, OutputStream os,
                                      String query, String xsl, HttpServletResponse response) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(os);
        response.setContentType("application/jsonrequest");
        response.setCharacterEncoding("UTF-8");

        bos.write("{\n".getBytes());
        bos.write("	\"status\" : \"".getBytes());

        bos.write((sqe.getErrorCode() + "").getBytes());
        bos.write("\",\n".getBytes());
        bos.write("\"query\" : \"".getBytes());
        bos.write(query.getBytes());
        bos.write("\",\n".getBytes());

        bos.write("\"sqlException\" : \"".getBytes());
        sqe.printStackTrace(new PrintStream(bos));
        bos.write("\"\n".getBytes());

        bos.write("}\n".getBytes());
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
        int rownum = 0;
        ColumnMetaData[] colMetadata = QueryExecutor.getMetaData(rs);
        BufferedOutputStream bos = new BufferedOutputStream(os);
        response.setContentType("application/jsonrequest");
        response.setCharacterEncoding("UTF-8");

        bos.write("{\n".getBytes());
        bos.write("	\"status\" : 0,\n".getBytes());
        bos.write("	\"numFields\" :".getBytes());
        bos.write((colMetadata.length + ",\n").getBytes());
        bos.write(" \"numRecords\" :".getBytes());
        bos.write(getNumResults(rs, rs_numfound).getBytes());
        bos.write(",\n".getBytes());
        bos.write("	\"QTime\" :".getBytes());
        bos.write(("\"" + queryExecTime + " sec\",\n").getBytes());


        bos.flush();
        bos.write("\"fields\" :[\n".getBytes());
        for (int i = 0; i < colMetadata.length; i++) {
            String name = colMetadata[i].getColumnName();
            bos.write(("\t\"" + name + "\"").getBytes());
            if (colMetadata.length != i + 1) bos.write(",\n".getBytes());
        }
        bos.write("],\n".getBytes());
        bos.write("\"types\" :[\n".getBytes());
        for (int i = 0; i < colMetadata.length; i++) {
            String type = setType(rs, i + 1);
            bos.write(("\t\"" + type + "\"").getBytes());
            if (colMetadata.length != i + 1) bos.write(",\n".getBytes());
        }
        bos.write("],\n".getBytes());

        bos.write("\"records\" :[\n".getBytes());
        while (rs.next()) {
            rownum++;
            if (rownum % 10 == 0) {
                bos.flush();
            }
            bos.write("\t[".getBytes());
            for (int i = 0; i < colMetadata.length; i++) {
                String name = colMetadata[i].getColumnName();
                String type;
                byte[] value = getXMLReadyValue(rs, i + 1);
                type = setType(rs, i + 1);

//                name = encodeInvalidXMLChars(name);
//                bos.write("\"name\" : \"".getBytes());
                /* bos.write("\"".getBytes());
            bos.write(name.getBytes());
            bos.write("\":\"".getBytes());    */

//                bos.write(" 	\"value\" , \"".getBytes());

                if (type.equals("integer")) {
                    bos.write(value);
                } else {
                    bos.write("\"".getBytes());
                    bos.write(value);
                    bos.write("\"".getBytes());
                }

                // Don't include "," for last column
                if (colMetadata.length != i + 1) {
                    bos.write(",\n\t ".getBytes());
                }


            }
            if (!rs.isLast()) {
                bos.write("	],\n ".getBytes());
            } else {
                bos.write("	]\n".getBytes());
            }
        }
        bos.write("	]\n".getBytes());
        bos.write("}\n".getBytes());
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
        response.setContentType("application/jsonrequest");
        response.setCharacterEncoding("UTF-8");

        bos.write("{\n".getBytes());
        bos.write("		\"status\" : 0,\n".getBytes());
        bos.write("		\"affectedRows\" :".getBytes());
        bos.write(("\"" + recordCount + "\",\n").getBytes());
        bos.write("		\"QTime\" :".getBytes());
        bos.write(("\"" + queryExecTime + " sec\"\n").getBytes());
        bos.write("}\n".getBytes());
        bos.flush();
    }

}
