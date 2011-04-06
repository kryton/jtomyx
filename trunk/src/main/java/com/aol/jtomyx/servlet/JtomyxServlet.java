package com.aol.jtomyx.servlet;

import com.aol.jtomyx.common.QueryConstants;
import com.aol.jtomyx.common.Timer;
import com.aol.jtomyx.executor.QueryExecutor;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NameNotFoundException;
import javax.naming.NamingException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;


public class JtomyxServlet extends HttpServlet {

    public static final Logger logger = Logger.getLogger(JtomyxServlet.class
            .getName());

    public static DataSource ds = null;
    public static String type = null;
    public static boolean isMySQL = false;
    public static boolean isOracle = false;
    public static boolean isPostgres = false;


    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            try {
                type = (String) envCtx.lookup("jdbc/Type");
            } catch (NamingException nme) {
                type = "MySQL";
                JtomyxServlet.isMySQL = true;
            }
            if (type.toLowerCase().equals("oracle")) {
                JtomyxServlet.isOracle = true;
            }
            if (type.toLowerCase().equals("postgresql")) {
                JtomyxServlet.isPostgres = true;
            }
            JtomyxServlet.ds = (DataSource) envCtx.lookup("jdbc/" + type);
            logger.info("Trying to connect to the DB ...");
            Connection con = ds.getConnection();

            envCtx.close();
            con.close();
            logger.info("...connection successful! (" + type + ")");
        } catch (NameNotFoundException e) {
            logger.severe("couldn't find our data source Context.. ?? context.xml??");
        } catch (SQLException e) {
            logger.info("Could not create connection in Servlet init(): " + e);
            e.printStackTrace();

        } catch (NamingException nme) {
            logger
                    .severe("Could not get the JNDI context and initialize data source\n"
                            + nme);
            nme.printStackTrace();
        }
    }

    public static boolean isEmptyOrNull(String str) {
        return (str == null || "".equals(str));
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            logger.info("POST " + request.getContextPath());
            if (ds == null) {
                logger.severe("Data Source not initialized properly, exiting");
                return;
            }

            QueryExecutor qexec = new QueryExecutor(ds);


            String qQuery = request.getParameter(QueryConstants.QUERY);
            String sqlQuery = request.getParameter(QueryConstants.SQL);
            String format = request.getParameter(QueryConstants.FORMAT);
            int getNumFound = 0;
            String xsl = null;


            String query = (isEmptyOrNull(qQuery)) ? sqlQuery : qQuery;
            logger.info("The Query is " + query);

            if (isEmptyOrNull(query)) {
                logger.severe("No query found in request.");
                qexec.sendError("No Query found in request", 400, response);
                return;

            } else {
                /**
                 * Make sure that sql or q parameters supplied but not both
                 */
                if ((qQuery != null && sqlQuery != null)
                        || (qQuery == null && sqlQuery == null)) {
                    qexec.sendError("BAD REQUEST", 400, response);
                    return;
                }

                String version = request.getParameter(QueryConstants.VERSION);
                if (version == null) {
                    qexec.sendError("missing version parameter", 400, response);
                    return;
                }
                if (Float.parseFloat(version) > 1.0) {
                    qexec.sendError("client version too high", 400, response);
                    return;
                }
                boolean selectMode = false;

                String reqType = request.getRequestURI();

                if (reqType.equals((request.getContextPath() + QueryConstants.SELECT))) {
                    selectMode = true;
                }

                if (request.getParameter(QueryConstants.LIMIT) != null
                        && !selectMode) {
                    qexec.sendError("limit parameter only allowed in select mode", 400, response);
                    return;
                }

                String start = request.getParameter(QueryConstants.START);
                String rows = request.getParameter(QueryConstants.ROWS);

                if (!selectMode
                        && (start != null || rows != null)) {
                    qexec.sendError("start and rows allowed only in select mode", 400, response);
                    return;
                }


                if (selectMode) {
                    start = (isEmptyOrNull(start)) ? QueryConstants.DEFAULT_OFFSET
                            : start;
                    rows = (isEmptyOrNull(rows)) ? QueryConstants.DEFAULT_MAX_ROWS
                            : rows;

                    if (isOracle) {
                        if (query.toLowerCase().contains("order by")) {
                            query = String.format("select * \n" +
                                    "     from ( select a.*, rownum rnum\n" +
                                    "          from ( %s ) a\n" +
                                    "         where rownum <= %d )\n" +
                                    "    where rnum >= %d ", query, (new Long(start) + new Long(rows)), new Long(start));
                        } else {
                            if (query.toLowerCase().contains("where")) {
                                query = query + " AND ROWNUM between " + new Long(start) + " AND " + (new Long(start) + new Long(rows));
                            } else {
                                query = query + " where   ROWNUM between " + new Long(start) + " AND " + (new Long(start) + new Long(rows));
                            }
                        }
                        //query =  "select * from ( select a.*, rownum rnum from ( select * from ALL_TABLES order by table_name) a where rownum <= 15 ) where rnum >= 5";
                    }
                    if (isPostgres) {

                        query = (query.toLowerCase().contains("limit")) ? query : query
                                + " Limit " + rows + " OFFSET " + start;

                    }
                    if (isMySQL) {

                        query = (query.toLowerCase().contains("limit")) ? query : query
                                + " Limit " + start + "," + rows;

                    }
                }

                String getfound = request.getParameter(QueryConstants.NUMBER_OF_DOCS_FOUND);
                if (!isOracle && !isPostgres && ((getfound != null && getfound.equals("1")) && selectMode)) {
                    getNumFound = 1;
                }

                if (!isOracle && !isPostgres && (selectMode || getNumFound == 1)) {
                    /*
                      * If there is SQL_CALC_FOUND_ROWS already replace with " "
                      */
                    query = query.replaceFirst(" SQL_CALC_FOUND_ROWS ", " ");
                    query = query.replaceFirst("select ", "SELECT ");
                    query = query.replaceFirst("SELECT ", "SELECT SQL_CALC_FOUND_ROWS ");
                    logger.info("Query after SQL_CALC_FOUND_ROWS: " + query);
                }

                xsl = request.getParameter(QueryConstants.XSL);
                if (xsl == null) {
                    xsl = "tabular";
                }

                try {

                    OutputStream os = response.getOutputStream();
                    Timer timer = new Timer();
                    timer.start();
                    qexec.executeAndWrite(query, os, xsl, getNumFound, format, start, rows, response);
                    os.flush();
                    os.close();
                    timer.end();

                    logger.info("Time taken to serve the response: "
                            + timer.getTimeInMillis() + " ms");

                } catch (SQLException sqe) {
                    logger.severe("Exception while executing query: " + query
                            + "\n" + sqe);
                    sqe.printStackTrace();
                }

            }
        } catch (Exception e) {
            logger.severe("Exception:" + e);
            e.printStackTrace();
            response.sendError(response.SC_INTERNAL_SERVER_ERROR);

        }

    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }


}
