package com.example;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;

import org.json.JSONObject;

public class TCP {
    static Request receive(Socket socket) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        String inputMessage = in.readLine();

        System.out.println("-------------------------------------------------");
        System.out.println("[TCP Receive]");
        JSONObject jsonObject = new JSONObject(
                inputMessage);

        Request request = new Request(jsonObject, socket.getInetAddress(), socket.getPort());
        System.out.println("IP:" + socket.getInetAddress() + " Port#:" + socket.getPort());
        System.out.println("method: " + request.method);
        System.out.println("route: " + request.route);
        System.out.println(request.data);
        System.out.println("-------------------------------------------------");
        return request;

    }

    static void response(Response message, Socket socket, InetAddress ip, int port) throws IOException {
        String msg = message.toJson().toString();
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        out.write(msg);
        out.flush();
        System.out.println("-------------------------------------------------");
        System.out.println("[TCP Send]");
        System.out.println("IP:" + ip + " Port#:" + port);
        System.out.println(
                "statusCode: " + Integer.toString(message.statusCode) + " statusMessage: " + message.statusMessage);
        System.out.println("data:\n" + message.data);
        System.out.println("-------------------------------------------------");
    }
}
