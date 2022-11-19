package com.example;

import java.net.DatagramSocket;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {

    static Connection con;
    static Statement updatestmt;
    static ExecutorService pool;

    public static void main(String[] args) throws Exception {

        // String jdbc_url = "jdbc:mysql://43.200.206.18:3306/networkDB";
        String jdbc_url = "jdbc:mysql://127.0.0.1:3306/networkDB";
        con = DriverManager.getConnection(jdbc_url, "root", "gachon");
        updatestmt = con.createStatement();
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
            Statement querystmt;
            try {
                if (request.method.equalsIgnoreCase("POST")) {
                    if (request.route.equalsIgnoreCase("register")) {
                        String sql = String.format("select * from User where ID = \"%s\"", request.data.get("id"));
                        querystmt = con.createStatement();
                        ResultSet result = updatestmt.executeQuery(sql);
                        if (!result.next()) {
                            sql = String.format(
                                    "insert into User(ID, PassWord, Name, EMail, Birthday) Values(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\");",
                                    request.data.get("id"), request.data.get("pass"), request.data.get("name"),
                                    request.data.get("email"), request.data.get("birthday"));
                            updatestmt.executeUpdate(sql);
                            sql = String.format(
                                    "insert into UserStatus(ID, NickName, StatusMessage) Values(\"%s\", \"%s\", \"\");",
                                    request.data.get("id"), request.data.get("nickname"));
                            updatestmt.executeUpdate(sql);
                            socket.response(new Response(200, "OK", request.data), request.ip, request.port); // 데이터
                            // 다시
                            // 보내기
                        } else
                            socket.response(new Response(1, "Duplicated ID", null), request.ip, request.port); // 데이터
                        // 다시
                        // 보내기
                    } else if (request.route.equalsIgnoreCase("login")) { // login api
                        // 로그인 요청시 id,password insert

                        JSONObject login_json = new JSONObject();

                        login_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.
                        login_json.put("password", request.data.get("password")); // json file에서 load하여 login_json에 저장.
                        String login_sql = String.format("select * from User where ID = \"%s\"",
                                request.data.get("id"));
                        querystmt = con.createStatement();
                        ResultSet result = querystmt.executeQuery(login_sql);

                        // user id가 table에 없다면
                        if (!result.next()) {
                            // 회원가입 해달라 메세지 출력
                            socket.response(new Response(2, "Please sign up for membership first", null),
                                    request.ip, request.port);
                        } else {
                            // password_sql과 user가 입력한 password가 같다면
                            // == 안됨!! 명심..
                            if (request.data.get("password").equals(result.getString("password"))) {
                                String sql = String.format(
                                        "select NickName, StatusMessage from UserStatus where ID = \"%s\"",
                                        request.data.get("id"));
                                querystmt = con.createStatement();
                                ResultSet userStatus_result = querystmt.executeQuery(sql);
                                userStatus_result.next();

                                socket.response(
                                        new Response(200, "OK", new User(result, userStatus_result).getJson()),
                                        request.ip,
                                        request.port);
                            } else {
                                socket.response(new Response(3, "The password is different.", null), request.ip,
                                        request.port);
                            }

                        }
                    } else if (request.route.equalsIgnoreCase("addFriend")) { // 친구 추가 api
                        JSONObject addFriend_json = new JSONObject();
                        addFriend_json.put("myId", request.data.get("myId"));
                        addFriend_json.put("friendId", request.data.get("friendId"));

                        // 친구 id가 이 메신저에 등록되어있는지 우선 확인.
                        String exist_friend = String.format("select * from User where ID = \"%s\"",
                                request.data.get("friendId"));
                        querystmt = con.createStatement();
                        ResultSet exist_result = querystmt.executeQuery(exist_friend);
                        if (!exist_result.next()) { // 메신저에 등록되어있지 않다면
                            socket.response(new Response(4, "User is not registered.", null), request.ip, request.port);
                        } else {
                            // 메신저에 등록되어있다면.
                            // 내가 검색한 친구의 id가 내 table에 있나 확인.
                            String find_friend = String.format(
                                    "select * from Friend_List where ID = \"%s\" and Friend_ID = \"%s\"",
                                    request.data.get("myId"), request.data.get("friendId"));
                            querystmt = con.createStatement();
                            ResultSet friend_result = querystmt.executeQuery(find_friend);

                            // 친구목록에 존재하면 추가 안함.
                            if (friend_result.next()) {
                                socket.response(new Response(5, "Already on the Friends list!", null), request.ip,
                                        request.port);
                            } else {
                                // 존재하면 추가.
                                String add_sql = String.format("insert into Friend_List values(\"%s\", \"%s\")",
                                        request.data.get("myId"), request.data.get("friendId"));
                                updatestmt.executeUpdate(add_sql);
                                socket.response(new Response(200, "OK", request.data), request.ip, request.port);
                            }
                        }

                    } else if (request.route.equalsIgnoreCase("myProfile")) { // 프로필 편집 버튼
                        JSONObject myProfile_json = new JSONObject();
                        myProfile_json.put("id", request.data.get("id"));
                        myProfile_json.put("nickName", request.data.get("nickName"));
                        myProfile_json.put("statusMessage", request.data.get("statusMessage"));

                        // 상태메세지 update하는 구문.
                        String update_profile_sql = String.format(
                                "update UserStatus set statusMessage = \"%s\" where id = \"%s\"",
                                request.data.get("statusMessage"), request.data.get("id"));

                        updatestmt.executeUpdate(update_profile_sql);
                        update_profile_sql = String.format("update UserStatus set NickName = \"%s\" where id = \"%s\"",
                                request.data.get("nickName"), request.data.get("id"));
                        updatestmt.executeUpdate(update_profile_sql);
                        socket.response(new Response(200, "OK", request.data), request.ip, request.port);

                    }

                    else if (request.route.equalsIgnoreCase("UpdateMyData")) { // load my data api
                        // 갱신 요청시에 userid를 얻어서 User,UserStatus 넣어서 전송.

                        JSONObject UpdateMyData_json = new JSONObject();

                        UpdateMyData_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.

                        String UpdateMyData_sql = String.format("select * from User where ID = \"%s\"",
                                request.data.get("id"));
                        querystmt = con.createStatement();
                        ResultSet result = querystmt.executeQuery(UpdateMyData_sql);

                        String sql = String.format(
                                "select NickName, StatusMessage from UserStatus where ID = \"%s\"",
                                request.data.get("id"));
                        querystmt = con.createStatement();
                        ResultSet userStatus_result = querystmt.executeQuery(sql);
                        userStatus_result.next();

                        socket.response(
                                new Response(200, "OK", new User(result, userStatus_result).getJson()),
                                request.ip,
                                request.port);
                    } else
                        socket.response(new Response(100, "Invalid Route requested.", null), request.ip,
                                request.port);
                } else if (request.method.equalsIgnoreCase("GET")) {

                } else
                    socket.response(new Response(101, "Invalid method requested.", null), request.ip, request.port);
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
