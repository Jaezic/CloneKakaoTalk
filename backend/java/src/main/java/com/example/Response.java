package com.example;

import java.util.Map;

import org.json.JSONObject;

public class Response {
    int statusCode;
    String statusMessage;
    JSONObject data;

    Response(int statusCode, String statusMessage, JSONObject data) {
        this.statusCode = statusCode;
        this.statusMessage = statusMessage;
        this.data = data;

    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json.put("statusCode", statusCode);
        json.put("statusMessage", statusMessage);
        json.put("data", data);
        return json;
    }
}
