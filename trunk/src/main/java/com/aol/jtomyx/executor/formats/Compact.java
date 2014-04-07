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


public class Compact extends Format {

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
        bos.write("<query>".getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</query>".getBytes());


        bos.write("</responseHeader>".getBytes());
        bos.write("<sqlException>".getBytes());
        sqe.printStackTrace(new PrintStream(bos));
        bos.write("</sqlException>".getBytes());
        bos.write("</response>".getBytes());
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
        String xmlStr = "<?xml-stylesheet type=\"text/xsl\" href=\"../admin/" + xsl + ".xsl\"?>";

        bos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>".getBytes());
        bos.write(xmlStr.getBytes());
        bos.write("<response xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://atomics.aol.com/cnet-search/response.xsd\">".getBytes());
        bos.write("<responseHeader>".getBytes());
        bos.write("<status>".getBytes());
        bos.write("0\n".getBytes());
        bos.write("</status>".getBytes());
        bos.write("<affectedRows>".getBytes());
        bos.write(("" + recordCount + "").getBytes());
        bos.write("</affectedRows>".getBytes());

        bos.write("<query>".getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</query>".getBytes());
        bos.write("<QTime>".getBytes());
        bos.write(("" + queryExecTime + " sec").getBytes());
        bos.write("</QTime>".getBytes());

        bos.write("</responseHeader>".getBytes());
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
        String xmlStr = "<?xml-stylesheet type=\"text/xsl\" href=\"../admin/" + xsl + ".xsl\"?>\n";

        bos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        bos.write(xmlStr.getBytes());
        bos.write("<response xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://atomics.aol.com/cnet-search/responseCompact.xsd\">\n".getBytes());
        bos.write("<header>\n".getBytes());
        bos.write("<status>".getBytes());
        bos.write("0\n".getBytes());
        bos.write("</status>\n".getBytes());
        bos.write("<numFields>".getBytes());
        bos.write((colMetadata.length + "").getBytes());
        bos.write("</numFields>\n".getBytes());
        bos.write("<numRecords>".getBytes());
        bos.write(getNumResults(rs, rs_numfound).getBytes());
        bos.write("</numRecords>\n".getBytes());

        bos.write("<query>".getBytes());
        bos.write(Format.encodeInvalidXMLChars(query).getBytes());
        bos.write("</query>".getBytes());
        bos.write("<QTime>".getBytes());
        bos.write(("" + queryExecTime + " sec").getBytes());
        bos.write("</QTime>\n".getBytes());

        bos.write("</header>\n".getBytes());
        bos.flush();
        bos.write("<data>\n".getBytes());
        bos.write("<fields>\n".getBytes());
        for (int i = 0; i < colMetadata.length; i++) {
            String name = colMetadata[i].getColumnName();
            String type;
            name = encodeInvalidXMLChars(name);
            type = setType(rs, i + 1);
            // colMetadata[i].getColumnType()       ;

            String field = "<field type=\"" + type + "\" name=\"" + name + "\" />\n";
            bos.write(field.getBytes());
        }
        bos.write("</fields>\n".getBytes());
        bos.write("<rows>\n".getBytes());
        while (rs.next()) {
            bos.write("<r>\n".getBytes());
            for (int i = 0; i < colMetadata.length; i++) {
                /*
                String name = colMetadata[i].getColumnName();
                String type;
                */


                byte[] value = getXMLReadyValue(rs, i + 1);
                /*
                name = encodeInvalidXMLChars(name);
                type = setType(rs, i + 1);

                bos.write("<field type=\"".getBytes());
                bos.write(type.getBytes());
                bos.write("\">".getBytes());


                bos.write("<name>".getBytes());
                bos.write(name.getBytes());
                bos.write("</name>".getBytes());

                */
                bos.write("<v>".getBytes());
                bos.write(value);
                bos.write("</v>\n".getBytes());


            }
            bos.write("</r>\n".getBytes());
        }
        bos.write("</rows>\n".getBytes());

        bos.write("</data>\n".getBytes());
        bos.write("</response>\n".getBytes());
        bos.flush();
    }

}