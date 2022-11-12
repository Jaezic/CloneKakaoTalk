package com.example;

import java.io.IOException;
import java.net.DatagramSocket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

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
                if(request.method.equalsIgnoreCase("POST")){
                    if(request.route.equalsIgnoreCase("register")){
                        System.out.println(request.data.get("name")); // 들어온 데이터 읽기

                        JSONObject json = new JSONObject();
                        json.put("value", "test");

                        UDP.response(new UDPResponse(200, "OK", json), ds, request.ip, request.port); // 데이터 다시 보내기
                    }else
                    UDP.response(new UDPResponse(0, "Bad Route", null), ds, request.ip, request.port);
                }
                else if(request.method.equalsIgnoreCase("GET")){

                }else
                UDP.response(new UDPResponse(0, "Bad Request", null), ds, request.ip, request.port);
            } catch (IOException e) {
            }
        }
    }
}
