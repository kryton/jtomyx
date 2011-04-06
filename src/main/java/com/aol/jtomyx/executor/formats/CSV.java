/* Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


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