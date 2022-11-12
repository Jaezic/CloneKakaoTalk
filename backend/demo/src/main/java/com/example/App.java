package com.example;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

public class App {
    public static void main(String[] args) throws Exception {
        try {
            DatagramSocket ds = new DatagramSocket(9999);
            ExecutorService pool = Executors.newFixedThreadPool(20);
            while (true) {
                System.out.println("Waiting for a packet reception..");
                UDPRequest request = UDP.receive(ds);
                pool.execute(new Thread(request, ds));
            }
        } catch (IOException e) {
        }
    }

    private static class Thread implements Runnable {
        private UDPRequest request;
        private DatagramSocket ds;

        Thread(UDPRequest request, DatagramSocket ds) {
            this.request = request;
            this.ds = ds;
        }

        @Override
        public void run() {
            try {
                UDP.response(new UDPResponse(200, "OK", request.toJson()), ds, request.ip, request.port);
            } catch (IOException e) {
            }
        }
    }
}
