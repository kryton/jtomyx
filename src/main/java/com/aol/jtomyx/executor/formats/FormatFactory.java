package com.aol.jtomyx.executor.formats;

/**
 * Created by IntelliJ IDEA.
 * User: ianholsman
 * Date: Aug 8, 2008
 * Time: 2:11:18 PM
 * <p/>
 * COPYRIGHT  (c)  2008 AOL LLC, Inc.
 * All Rights Reserved.
 * <p/>
 * PROPRIETARY - INTERNAL AOL USE ONLY
 * This document contains proprietary information that shall be
 * distributed, routed, or made available only within AOL,
 * except with written permission of AOL.
 */
public class FormatFactory {
    public static Format getFormatter(String formatName) {
        if (null == formatName) {
            return new XML();
        }
        String fmt = formatName.toLowerCase();
        if (fmt.equals("xml")) {
            return new XML();
        }
        if (fmt.equals("solr")) {
            return new Solr();
        }
        if (fmt.equals("json")) {
            return new JSON();
        }
        if (fmt.equals("compact")) {
            return new Compact();
        }
        if (fmt.equals("csv")) {
            return new CSV();
        }
        return new XML();
    }
}
