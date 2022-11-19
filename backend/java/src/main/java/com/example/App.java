package com.example;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.DatagramSocket;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {

    static Statement stmt;
    static ExecutorService pool;

    public static void main(String[] args) throws Exception {

        // String jdbc_url = "jdbc:mysql://43.200.206.18:3306/networkDB";
        String jdbc_url = "jdbc:mysql://localhost:3306/networkDB";
        Connection con = DriverManager.getConnection(jdbc_url, "root", "gachon");
        stmt = con.createStatement();

        pool = Executors.newFixedThreadPool(20);
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
                    pool.execute(new Thread(request, new Network(ds)));
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
            try {
                ServerSocket listener = new ServerSocket(9997);
                System.out.println("TCP Waiting for a packet reception..");
                while (true) {
                    Socket socket = listener.accept();
                    Request request = TCP.receive(socket);
                    pool.execute(new Thread(request, new Network(socket)));
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private static class Thread implements Runnable {
        private Request request;
        private Network socket;

        Thread(Request request, Network socket) {
            this.request = request;
            this.socket = socket;
        }

        @Override
        public void run() {
            try {
                if (request.method.equalsIgnoreCase("POST")) {
                    if (request.route.equalsIgnoreCase("register")) {
                        // System.out.println(request.data.get("name")); // 들어온 데이터 읽기
                        // request.data.get("id");
                        // JSONObject json = new JSONObject();
                        // System.out.println("Connect");
                        // json.put("value", "test");

                        String sql = String.format("select * from User where ID = \"%s\"", request.data.get("id"));
                        ResultSet result = stmt.executeQuery(sql);
                        if (!result.next()) {
                            sql = String.format(
                                    "insert into User(ID, PassWord, Name, EMail, Birthday) Values(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\");",
                                    request.data.get("id"), request.data.get("pass"), request.data.get("name"),
                                    request.data.get("email"), request.data.get("birthday"));
                            stmt.executeUpdate(sql);
                            sql = String.format("insert into UserStatus(ID, NickName) Values(\"%s\", \"%s\");",
                                    request.data.get("id"), request.data.get("nickname"));
                            stmt.executeUpdate(sql);
                            socket.response(new Response(200, "OK", request.data), request.ip, request.port); // 데이터
                            // 다시
                            // 보내기
                        } else
                            socket.response(new Response(0, "Duplicated ID", null), request.ip, request.port); // 데이터
                        // 다시
                        // 보내기
                    } else if (request.route.equalsIgnoreCase("login")) {
                        // 로그인 요청시 id,password insert

                        JSONObject login_json = new JSONObject();

                        login_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.
                        login_json.put("password", request.data.get("password")); // json file에서 load하여 login_json에 저장.
                        String login_sql = String.format("select * from User where ID = \"%s\"",
                                request.data.get("id"));
                        ResultSet result = stmt.executeQuery(login_sql);

                        // user id가 table에 없다면
                        if (!result.next()) {
                            // 회원가입 해달라 메세지 출력
                            socket.response(new Response(0, "Please sign up for membership first", null),
                                    request.ip, request.port);
                        } else {
                            // user가 입력한 id의 password를 password_sql에 저장.
                            String password_sql = String.format("select password from User where ID = \"%s\"",
                                    request.data.get("id"));
                            ResultSet password_result = stmt.executeQuery(password_sql);
                            // next()로 커서를 넘겨주고 읽어야 오류 안남.
                            password_result.next();

                            // password_sql과 user가 입력한 password가 같다면
                            // == 안됨!! 명심..
                            if (request.data.get("password").equals(password_result.getString("password"))) {
                                socket.response(new Response(200, "OK", request.data), request.ip, request.port);
                            } else {
                                socket.response(new Response(0, "The password is different.", null), request.ip,
                                        request.port);
                            }

                        }
                        // mysql load

                        // UDP.response(new UDPResponse(200, "OK", request.data), ds, request.ip,
                        // request.port); // 데이터 다시 보내기
                    } else
                        socket.response(new Response(0, "Invalid Route requested.", null), request.ip,
                                request.port);
                } else if (request.method.equalsIgnoreCase("GET")) {

                } else
                    socket.response(new Response(0, "Invalid method requested.", null), request.ip, request.port);
            } catch (Exception e) {
                try {
                    socket.response(new Response(0, e.getMessage(), null), request.ip, request.port);
                } catch (Exception e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                }
                e.printStackTrace();
            } finally {
                socket.close();
            }
        }
    }
}
