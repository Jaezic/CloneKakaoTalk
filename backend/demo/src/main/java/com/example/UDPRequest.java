package com.example;

import java.net.InetAddress;
import org.json.JSONObject;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

public class UDPRequest {
    String method;
    JSONObject data;
    InetAddress ip;
    int port;

    UDPRequest(JSONObject message, InetAddress ip, int port)
            throws JsonMappingException, JsonProcessingException {
        this.method = message.get("method").toString();
        this.data = new JSONObject(message.get("data").toString());
        this.ip = ip;
        this.port = port;
    }
}
