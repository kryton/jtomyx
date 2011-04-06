package com.aol.jtomyx.executor;

/**
 * Created by IntelliJ IDEA.
 * User: ianholsman
 * Date: Aug 8, 2008
 * Time: 2:26:55 PM
 * <p/>
 * COPYRIGHT  (c)  2008 AOL LLC, Inc.
 * All Rights Reserved.
 * <p/>
 * PROPRIETARY - INTERNAL AOL USE ONLY
 * This document contains proprietary information that shall be
 * distributed, routed, or made available only within AOL,
 * except with written permission of AOL.
 */
public class ColumnMetaData {
    private String columnName;
    private String columnType;

    public ColumnMetaData(String columnName, String columnType) {
        this.columnName = columnName;
        this.columnType = columnType;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getColumnType() {
        return columnType;
    }

    public void setColumnType(String columnType) {
        this.columnType = columnType;
    }
}
