package com.example;

import java.net.InetAddress;
import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class UDPRequest {
    String method;
    Map<String, String> data;
    InetAddress ip;
    int port;

    UDPRequest(Map<String, String> message, InetAddress ip, int port)
            throws JsonMappingException, JsonProcessingException {
        this.method = message.get("method");
        ObjectMapper mapper = new ObjectMapper();
        this.data = mapper.readValue(message.get("data"), new TypeReference<Map<String, String>>() {
        });
        this.ip = ip;
        this.port = port;
    }
}
