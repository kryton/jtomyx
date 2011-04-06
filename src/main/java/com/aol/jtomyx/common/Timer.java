package com.aol.jtomyx.common;

import java.util.logging.Logger;


public class Timer {

    private static final Logger logger = Logger.getLogger(Timer.class.getName());

    private long start;
    private long end;

    public Timer() {
    }

    public void reset() {
        start = end = 0;
    }

    public void start() {
        start = System.currentTimeMillis();
    }

    public void end() {
        end = System.currentTimeMillis();
    }

    public double getTimeInMillis() {
        return end - start;
    }

    public double getTimeInSeconds() {
        return getTimeInMillis() / 1000.0000;
    }

    public double getTimeInMinutes() {
        return (double) getTimeInSeconds() / 60.0000;
    }
}
