package com.example;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;

public class Network {
    String method;
    DatagramSocket udpSocket;
    Socket tcpSocket;

    Network(DatagramSocket udpSocket, String method) {
        this.udpSocket = udpSocket;
        this.tcpSocket = null;
        this.method = method;
    }

    Network(Socket tcpSocket, String method) {
        this.udpSocket = null;
        this.tcpSocket = tcpSocket;
        this.method = method;
    }

    void close() {
        try {
            // if (this.tcpSocket == null)
            // this.udpSocket.close();
            // else
            if (this.tcpSocket != null)
                this.tcpSocket.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    void response(Response message, InetAddress ip, int port) throws Exception {
        if (this.tcpSocket == null)
            UDP.response(message, this.udpSocket, ip, port);
        else
            TCP.response(message, this.tcpSocket, ip, port);
    }
}
