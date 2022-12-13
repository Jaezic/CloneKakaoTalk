package com.example;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramSocket;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {
    static HashMap<String, Network> connected_sockets = new HashMap<>();
    static Connection con;
    static Statement updatestmt;
    static ExecutorService pool;

    public static void main(String[] args) throws Exception {
        // String jdbc_url = "jdbc:mysql://43.200.206.18:3306/networkDB";
        String jdbc_url = "jdbc:mysql://127.0.0.1:3306/networkDB";
        con = DriverManager.getConnection(jdbc_url, "root", "gachon");
        updatestmt = con.createStatement();
        pool = Executors.newFixedThreadPool(40);
        pool.execute(new ReceiveUDPThread());
        pool.execute(new ReceiveTCPThread());
    }

    private static class ReceiveUDPThread implements Runnable {
        @Override
        public void run() {
            try {
                DatagramSocket ds = new DatagramSocket(9998);
                while (true) {
                    System.out.println("UDP Waiting for a packet reception..");
                    Request request = UDP.receive(ds);
                    pool.execute(new RequestThread(request, new Network(ds, request.method)));
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private static class ReceiveTCPThread implements Runnable {
        @Override
        public void run() {
            Socket socket = null;
            try {
                ServerSocket listener = new ServerSocket(9997);
                System.out.println("TCP Waiting for a packet reception..");
                while (true) {
                    socket = listener.accept();
                    Request request = TCP.receive(socket);
                    if (request.method.equalsIgnoreCase("CONNECT"))
                        pool.execute(new TcpThread(request, new Network(socket, request.method)));
                    else
                        pool.execute(new RequestThread(request, new Network(socket, request.method)));
                }
            } catch (Exception e) {
                if (socket != null)
                    try {
                        socket.close();
                    } catch (IOException e1) {
                        // TODO Auto-generated catch block
                        e1.printStackTrace();
                    }
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private static class TcpThread implements Runnable {
        private Request request;
        private Network socket;

        TcpThread(Request request, Network socket) {
            this.request = request;
            this.socket = socket;
        }

        @Override
        public void run() {
            try {
                if (request.route.equalsIgnoreCase("userConnect")) {
                    CONNECT.userConnect(socket, request);
                } else
                    socket.response(new Response(100, "Invalid method requested.", null), request.ip, request.port);
            } catch (Exception e) {
                socket.close();
            }
        }
    }

    private static class RequestThread implements Runnable {
        private Request request;
        private Network socket;

        RequestThread(Request request, Network socket) {
            this.request = request;
            this.socket = socket;
        }

        @Override
        public void run() {
            try {
                if (request.method.equalsIgnoreCase("POST")) {
                    if (request.route.equalsIgnoreCase("register"))
                        POST.register(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("login"))
                        POST.login(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("addFriend")) // 친구 추가 api
                        POST.addFriend(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("deleteFriend"))
                        POST.deleteFriend(socket, request, con, updatestmt);// 친구 삭제 api
                    else if (request.route.equalsIgnoreCase("myProfile"))
                        POST.myProfile(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("changeProfileImage")) // 프로필 편집 버튼
                        POST.changeProfileImage(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("changeProfileBackground")) // 프로필 편집 버튼
                        POST.changeProfileBackground(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("createRoom")) // 방 만들기
                        POST.createRoom(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("sendChat")) // 채팅 보내기
                        POST.sendChat(socket, request, con, updatestmt);
                    else
                        socket.response(new Response(100, "Invalid Route requested.", null), request.ip,
                                request.port);
                } else if (request.method.equalsIgnoreCase("GET")) {
                    if (request.route.equalsIgnoreCase("UpdateMyData")) // load my data api
                        GET.updateMyData(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("friendList"))
                        GET.friendList(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("fetchRoom")) // 방 가져오기
                        GET.fetchRoom(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("findOneToOne")) // 1 : 1방 찾기
                        GET.findOneToOne(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("fetchRooms")) // 방 찾기
                        GET.fetchRooms(socket, request, con, updatestmt);
                    else if (request.route.equalsIgnoreCase("receivePostChat")) // 채팅 불러오기
                        GET.receivePostChat(socket, request, con, updatestmt);
                    else
                        socket.response(new Response(100, "Invalid Route requested.", null), request.ip,
                                request.port);
                } else
                    socket.response(new Response(100, "Invalid method requested.", null), request.ip, request.port);
            } catch (Exception e) {
                try {
                    socket.response(new Response(0, e.getMessage(), null), request.ip, request.port);
                } catch (Exception e1) {
                    e1.printStackTrace();
                }
                e.printStackTrace();
            } finally {
                socket.close();
            }
        }
    }
}
