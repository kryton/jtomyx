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


package com.aol.jtomyx.executor;

import com.aol.jtomyx.common.Timer;
import com.aol.jtomyx.executor.formats.Format;
import com.aol.jtomyx.executor.formats.FormatFactory;
import com.mysql.jdbc.CommunicationsException;

import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.EOFException;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;


public class QueryExecutor {

    private static final Logger logger = Logger.getLogger(QueryExecutor.class.getName());

    private DataSource ds;

    public QueryExecutor(DataSource ds) {
        this.ds = ds;
    }

    public static ColumnMetaData[] getMetaData(ResultSet rs) throws SQLException {
        List<ColumnMetaData> cmtd = new ArrayList<ColumnMetaData>();
        ResultSetMetaData rsMetadata = rs.getMetaData();
        int colCount = rsMetadata.getColumnCount();

        for (int i = 1; i <= colCount; i++) {
            String columnName = rsMetadata.getColumnLabel(i);
            String columnType = rsMetadata.getColumnTypeName(i);
            try {
                Class javaClass =
                        Class.forName(rsMetadata.getColumnClassName(i));
                columnType = javaClass.getSimpleName();
            } catch (ClassNotFoundException e) {
                logger.severe("No Java Class could be found for\n Column:" +
                        columnName + " SQL Type: " + columnType);
            }

            cmtd.add(new ColumnMetaData(columnName, columnType));
        }
        return cmtd.toArray(new ColumnMetaData[cmtd.size()]);
    }


    public void executeAndWrite(String query, OutputStream os, String xsl, int getnumfound,
                                String format, String start, String rows, HttpServletResponse response)
            throws SQLException, IOException {
        ResultSet rs = null;
        ResultSet rs_numfound = null;
        int recordCount = 0;
        Timer timer = new Timer();
        timer.start();
        Connection con = ds.getConnection();
        if (con == null) {
            sendError("Unable to get connection", 500, response);
            return;
        }

        timer.end();
        logger.fine("Time taken to acquire a connection from datasource: " + timer.getTimeInMillis() + " ms");
        timer.reset();
        timer.start();
        Statement stmt = null;
        Connection con_numfound = null;
        Statement stmt_numfound = null;
        Format jAtomicsOutput = FormatFactory.getFormatter(format);
        try {

            stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                    ResultSet.CONCUR_READ_ONLY);

            stmt.execute(query);
            rs = stmt.getResultSet();
            if (rs != null) {
                timer.end();
                double qtime = timer.getTimeInMillis();
                logger.fine("Time taken to create statement and execute a query: " + qtime + " ms");
                timer.reset();
                timer.start();
                if (getnumfound == 1) {
                    stmt_numfound = null;
                    stmt_numfound = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                            ResultSet.CONCUR_READ_ONLY);
                    stmt_numfound.executeQuery("SELECT FOUND_ROWS()");
                    rs_numfound = stmt_numfound.getResultSet();
                }
                jAtomicsOutput.writeSelectResults(rs, rs_numfound, os, query, qtime, xsl, start, rows, response);


                timer.end();
                logger.fine("Time taken to write XML results: " + timer.getTimeInMillis() + " ms");
                rs.close();
                if (rs_numfound != null) rs_numfound.close();
            } else {
                recordCount = stmt.getUpdateCount();
                double qtime = timer.getTimeInMillis();
                jAtomicsOutput.writeRawResults(os, query, qtime, recordCount, xsl, response);
            }

        }
        //    catch ( com.mysql.jdbc.CommunicationsException h )
        //    {
        /* xxx do something */
        //     }
        catch (SQLException sqe) {
            jAtomicsOutput.writeExceptionResults(sqe, os, query, xsl, response);
            //sendError(sqe.getMessage(), 500, response);
            //sqe.printStackTrace();

        } catch (Throwable T) {

            if (T instanceof EOFException) {
                System.out.println("\nEOF Exception:");
                T.printStackTrace();
            } else if (T instanceof CommunicationsException) {
                System.out.println("\nCommunication Exception:");
                T.printStackTrace();
            } else {
                T.printStackTrace();
            }
        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            con.close();

            if (rs_numfound != null)
                rs_numfound.close();
            if (stmt_numfound != null)
                stmt_numfound.close();
            if (con_numfound != null)
                con_numfound.close();

        }

    }


    public void sendError(String err, int errCode, HttpServletResponse response) {
        try {
            response.setContentType("text/plain");
            if (errCode == 400) response.sendError(HttpServletResponse.SC_BAD_REQUEST, err);
            if (errCode == 500) response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, err);
        } catch (IOException e) {
            logger.severe("IO Exception " + e);
        }
    }

}
