package com.demo;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {
    public static void main(String[] args) throws Exception {
        try {
            JSONObject message = new JSONObject();
            JSONObject data = new JSONObject();
            data.put("id", "asd");
            data.put("pass", "asd");
            data.put("name", "asd");
            data.put("nickname", "asd");
            data.put("email", "asd");
            data.put("birthday", "2022-9-15");


            message.put("method", "POST");
            message.put("route", "register");
            message.put("data", data);

            String msg = message.toString();
            byte[] bf = msg.getBytes();

            DatagramSocket ds = new DatagramSocket();
            InetAddress ip = InetAddress.getByName("localhost");
            DatagramPacket dp = new DatagramPacket(bf, bf.length, ip, 9999);
            ds.send(dp);
        } catch (IOException e) {
        }
    }
}
