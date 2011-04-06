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
