package com.demo;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;

import org.json.JSONArray;
import org.json.JSONObject;

import com.mysql.cj.xdevapi.JsonArray;

public class App {
    static String serverip = "43.200.206.18";

    // static String serverip = "localhost";
    public static void main(String[] args) throws Exception {
        try {
            JSONObject message = new JSONObject();
            JSONObject data = new JSONObject();
            data.put("myId", "test");
            data.put("onetoone", "1");
            data.put("title", "Hello");

            JSONArray ids = new JSONArray();
            ids.put("test");
            ids.put("asd");
            data.put("ids", ids);

            // data.put("roomId", "I5Y000RRR8");
            // message.put("method", "GET");
            // message.put("route", "fetchRoom");

            message.put("method", "POST");
            message.put("route", "createRoom");
            message.put("data", data);
            udpRequest(message);
            // JSONObject message = new JSONObject();
            // JSONObject data = new JSONObject();
            // data.put("userID", "1234");

            // message.put("method", "CONNECT");
            // message.put("route", "userConnect");
            // message.put("data", data);
            // tcpRequest(message);
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
        // socket.close();
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
