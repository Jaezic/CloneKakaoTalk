package com.example;

import java.net.InetAddress;
import org.json.JSONObject;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

public class UDPRequest {
    String method;
    String route;
    JSONObject data;
    InetAddress ip;
    int port;

    UDPRequest(JSONObject message, InetAddress ip, int port)
            throws JsonMappingException, JsonProcessingException {
        fromJson(message);
        this.ip = ip;
        this.port = port;
    }

    void fromJson(JSONObject message) {
        this.method = message.get("method").toString();
        this.route = message.get("route").toString();
        this.data = new JSONObject(message.get("data").toString());
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json.put("method", method);
        json.put("data", data);
        json.put("route", route);
        return json;
    }
}
