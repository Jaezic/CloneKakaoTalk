package com.example;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Map;

import org.json.JSONObject;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class UDP {

    static UDPRequest receive(DatagramSocket ds) throws IOException {
        byte[] bf = new byte[300];
        DatagramPacket dp = new DatagramPacket(bf, bf.length);
        ObjectMapper mapper = new ObjectMapper();
        ds.receive(dp);

        System.out.println("A new message has been received:");
        JSONObject jsonObject = new JSONObject(
                new String(bf));
        System.out.println(jsonObject);
        Map<String, String> message = mapper.readValue(new String(bf), new TypeReference<Map<String, String>>() {
        });
        UDPRequest request = new UDPRequest(message, dp.getAddress(), dp.getPort());
        // System.out.println("IP:" + dp.getAddress() + " Port#:" + dp.getPort());
        // System.out.println("Method : " + request.method);
        // System.out.println(request.data);
        return request;

    }

    static void response(DatagramSocket ds, InetAddress ip, int port) {

    }
}
