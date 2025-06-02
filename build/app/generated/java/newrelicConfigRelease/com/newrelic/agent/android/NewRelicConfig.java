
package com.newrelic.agent.android;

final class NewRelicConfig {
    static final String VERSION = "7.5.1";
    static final String BUILD_ID = "55a3b962-9d68-4341-b6b6-99564b0e7923";
    static final Boolean OBFUSCATED = true;
    static final String MAP_PROVIDER = "r8";
    static final String METRICS = "[agent:7.5.1, agp:8.5.2, gradle:8.9, java:21.0.5, kotlin:1.9.23, configCacheEnabled:false, variants:[debug:[minSdk:24, targetSdk:35], release:[minSdk:24, targetSdk:35], profile:[minSdk:24, targetSdk:35]]]";
    public static String getBuildId() {
        return BUILD_ID;
    }
}
