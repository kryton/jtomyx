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
public class CSV extends Format {

    public void writeExceptionResults(SQLException sqe, OutputStream os,
                                      String query, String xsl, HttpServletResponse response) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(os);
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");

        sqe.printStackTrace(new PrintStream(bos));
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
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");


        for (int i = 0; i < colMetadata.length; i++) {
            String name = colMetadata[i].getColumnName();
            bos.write(("\"" + name + "\"").getBytes());
            if (colMetadata.length != i + 1) bos.write(",".getBytes());
        }
        bos.write("\n".getBytes());


        while (rs.next()) {
            rownum++;
            if (rownum % 10 == 0) {
                bos.flush();
            }

            for (int i = 0; i < colMetadata.length; i++) {
                String name = colMetadata[i].getColumnName();
                String type;
                byte[] value = getXMLReadyValue(rs, i + 1);
                type = setType(rs, i + 1);

                if (type.equals("integer") || type.equals("float")) {
                    bos.write(value);
                } else {
                    bos.write("\"".getBytes());
                    bos.write(value);
                    bos.write("\"".getBytes());
                }

                // Don't include "," for last column
                if (colMetadata.length != i + 1) {
                    bos.write(", ".getBytes());
                }


            }
            bos.write("\n".getBytes());

        }

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
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");

        bos.write("\"affectedRows\"\n".getBytes());
        bos.write((recordCount + "\n").getBytes());

        bos.flush();
    }

}