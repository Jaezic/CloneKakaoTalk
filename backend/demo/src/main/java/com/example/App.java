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
            DatagramSocket ds = new DatagramSocket(9998);
            byte[] bf = new byte[300];
            DatagramPacket dp = new DatagramPacket(bf, bf.length);

            ObjectMapper mapper = new ObjectMapper();
            while (true) {
                System.out.println("Waiting for a packet reception..");
                ds.receive(dp);

                System.out.println("A new message has been received:");
                String rs1 = new String(bf);
                Map<String, String> map = mapper.readValue(rs1, new TypeReference<Map<String, String>>() {
                });
                String rs2 = rs1.trim();

                System.out.println("IP:" + dp.getAddress() + "  Port#:" + dp.getPort());
                System.out.println("message: " + rs1);
                System.out.println(map.get("method"));

            }
        } catch (IOException e) {
        }

    }
}
