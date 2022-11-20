package com.example;

import java.sql.*;

import org.json.JSONObject;

public class POST {
    static void register(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        String sql = String.format("select * from User where ID = \"%s\"", request.data.get("id"));
        querystmt = con.createStatement();
        ResultSet result = updatestmt.executeQuery(sql);
        if (!result.next()) {
            sql = String.format(
                    "insert into User(ID, PassWord, Name, EMail, HomeAddress, Birthday) Values(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\");",
                    request.data.get("id"), request.data.get("pass"), request.data.get("name"),
                    request.data.get("email"), request.data.get("homeaddress"),
                    request.data.get("birthday"));
            updatestmt.executeUpdate(sql);
            sql = String.format(
                    "insert into UserStatus(ID, NickName, StatusMessage) Values(\"%s\", \"%s\", \"\");",
                    request.data.get("id"), request.data.get("nickname"));
            updatestmt.executeUpdate(sql);
            socket.response(new Response(200, "OK", null), request.ip, request.port); // 데이터
            // 다시
            // 보내기
        } else
            socket.response(new Response(1, "Duplicated ID", null), request.ip, request.port); // 데이터
        // 다시
        // 보내기
    }

    static void login(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        // 로그인 요청시 id,password insert
        Statement querystmt;
        JSONObject login_json = new JSONObject();

        login_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.
        login_json.put("password", request.data.get("password")); // json file에서 load하여 login_json에 저장.
        String login_sql = String.format(
                "SELECT User.ID,PassWord,Name,EMail,Birthday,NickName,StatusMessage,UF.path as profile_image_path,UF2.path as profile_background_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id LEFT JOIN User_file UF2 ON UserStatus.profile_background_id = UF2.id WHERE User.ID = \"%s\"",
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
            if (request.data.get("password").equals(result.getString("PassWord"))) {
                socket.response(
                        new Response(200, "OK", new User(result).getJson()),
                        request.ip,
                        request.port);
            } else {
                socket.response(new Response(3, "The password is different.", null), request.ip,
                        request.port);
            }
        }
    }

    static void addFriend(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        JSONObject addFriend_json = new JSONObject();
        addFriend_json.put("myId", request.data.get("myId"));
        addFriend_json.put("friendId", request.data.get("friendId"));
        // 친구 id가 이 메신저에 등록되어있는지 우선 확인.
        String exist_friend = String.format("select * from User where ID = \"%s\"",
        addFriend_json.get("friendId"));
        querystmt = con.createStatement();
        ResultSet exist_result = querystmt.executeQuery(exist_friend);
        if (!exist_result.next()) { // 메신저에 등록되어있지 않다면
            socket.response(new Response(4, "User is not registered.", null), request.ip, request.port);
        } else {
            // 메신저에 등록되어있다면.
            // 내가 검색한 친구의 id가 내 table에 있나 확인.
            String find_friend = String.format(
                    "select * from Friend_List where ID = \"%s\" and Friend_ID = \"%s\"",
                    addFriend_json.get("myId"), addFriend_json.get("friendId"));
            querystmt = con.createStatement();
            ResultSet friend_result = querystmt.executeQuery(find_friend);

            // 친구목록에 존재하면 추가 안함.
            if (friend_result.next()) {
                socket.response(new Response(5, "Already on the Friends list!", null), request.ip,
                        request.port);
            } else {
                // 존재하면 추가.
                String add_sql = String.format("insert into Friend_List values(\"%s\", \"%s\")",
                addFriend_json.get("myId"), addFriend_json.get("friendId"));
                updatestmt.executeUpdate(add_sql);
                socket.response(new Response(200, "OK", null), request.ip, request.port);
            }
        }
    }

    static void deleteFriend(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        JSONObject deleteFriend_json = new JSONObject();
        deleteFriend_json.put("myId", request.data.get("myId"));
        deleteFriend_json.put("friendId", request.data.get("friendId"));

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

            // 친구목록에 존재 안하면 추가 안함.
            if (!friend_result.next()) {
                socket.response(new Response(5, "This friend is not in the list!", null), request.ip,
                        request.port);
            } else {
                // 존재하면 삭제.
                String delete_sql = String.format(
                        "delete from Friend_List where ID = \"%s\" and Friend_ID = \"%s\"",
                        request.data.get("myId"), request.data.get("friendId"));
                updatestmt.executeUpdate(delete_sql);
                socket.response(new Response(200, "OK", null), request.ip, request.port);
            }
        }
    }

    static void myProfile(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
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
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }

    static void changeProfileImage(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        Statement querystmt;
        JSONObject request_json = new JSONObject();
        request_json.put("myId", request.data.get("myId"));
        request_json.put("imageId", request.data.get("imageId"));
        String update_profile_sql = String.format(
                "update UserStatus set profile_image_id = \"%s\" where id = \"%s\"",
                request.data.get("imageId"), request.data.get("myId"));

        updatestmt.executeUpdate(update_profile_sql);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }

    static void changeProfileBackground(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        Statement querystmt;
        JSONObject request_json = new JSONObject();
        request_json.put("myId", request.data.get("myId"));
        request_json.put("imageId", request.data.get("imageId"));
        String update_profile_sql = String.format(
                "update UserStatus set profile_background_id = \"%s\" where id = \"%s\"",
                request.data.get("imageId"), request.data.get("myId"));

        updatestmt.executeUpdate(update_profile_sql);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }
}
