package com.example;

import java.util.Map;

import org.json.JSONObject;

public class UDPResponse {
    int statusCode;
    String statusMessage;
    Map<String, String> data;

    UDPResponse(int statusCode, String statusMessage, Map<String, String> data) {
        this.statusCode = statusCode;
        this.statusMessage = statusMessage;
        this.data = data;
        JSONObject asd;

    }
}
