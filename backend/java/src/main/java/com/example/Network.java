package com.example;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;

public class Network {
    DatagramSocket udpSocket;
    Socket tcpSocket;

    Network(DatagramSocket udpSocket) {
        this.udpSocket = udpSocket;
        this.tcpSocket = null;
    }

    Network(Socket tcpSocket) {
        this.udpSocket = null;
        this.tcpSocket = tcpSocket;
    }

    void close() {
        try {
            // if (this.tcpSocket == null)
            // this.udpSocket.close();
            // else
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
