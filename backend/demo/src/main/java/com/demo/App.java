package com.demo;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {
    static String serverip = "43.200.206.18";

    // static String serverip = "localhost";
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
            tcpRequest(message);
        } catch (Exception e) {
        }
    }

    static void tcpRequest(JSONObject message) throws Exception {

        String msg = message.toString();
        Socket socket = new Socket(serverip, 9997);

        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        out.write(msg);
        out.flush();
        socket.close();
    }

    static void udpRequest(JSONObject message) throws Exception {

        String msg = message.toString();
        byte[] bf = msg.getBytes();

        DatagramSocket ds = new DatagramSocket();

        InetAddress ip = InetAddress.getByName(serverip);
        DatagramPacket dp = new DatagramPacket(bf, bf.length, ip, 9998);
        ds.send(dp);
    }
}
