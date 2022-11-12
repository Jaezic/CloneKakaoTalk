package com.example;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class App {
    public static void main(String[] args) throws Exception {
        try {
            DatagramSocket ds = new DatagramSocket(9999);
            while (true) {
                System.out.println("Waiting for a packet reception..");
                UDPRequest request = UDP.receive(ds);
                UDP.response(ds, request.ip, request.port);
            }
        } catch (IOException e) {
        }

    }
}
