package com.example;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Random;
import java.util.TimeZone;
import java.lang.StringBuilder;

import javax.swing.text.DefaultStyledDocument.ElementSpec;

import java.lang.StringBuilder;

public class POST {
    static void register(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        AES256 aes256 = new AES256();
        // String cipherText = aes256.encrypt(request.data.getString("pass"));

        Statement querystmt;
        String sql = String.format("select * from User where ID = \"%s\"", request.data.get("id"));
        querystmt = con.createStatement();
        ResultSet result = querystmt.executeQuery(sql);
        if (!result.next()) {
            sql = String.format(
                    "insert into User(ID, PassWord, Name, EMail, HomeAddress, Birthday) Values(\"%s\", \"%s\", \"%s\", \"%s\", \"%s\", \"%s\");",
                    request.data.get("id"), request.data.getString("pass"), request.data.get("name"),
                    // request.data.get("id"), cipherText, request.data.get("name"),
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

    static void unregister(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        String sql = String.format("select * from User where ID = '%s';", request.data.get("myId"));
        querystmt = con.createStatement();
        ResultSet result = querystmt.executeQuery(sql);

        if (!result.next()) {
            // 등록 되어있는 사람이 없다면
            socket.response(new Response(5, "not registered!", null), request.ip, request.port); // 데이터
        } else {
            sql = String.format("delete from User where ID = '%s';", request.data.get("myId"));
            updatestmt.executeUpdate(sql);
            socket.response(new Response(200, "OK", null), request.ip, request.port); // 데이터
            CONNECT.broadcastFetchFriend(result.getString("ID"));
        }
    }

    static void checkPassword(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        AES256 aes256 = new AES256();

        // 로그인 요청시 id,password insert
        Statement querystmt;
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
            String password = aes256.decrypt(result.getString("PassWord"));

            // password_sql과 user가 입력한 password가 같다면
            // == 안됨!! 명심..
            if (request.data.get("password").equals(password)) {
                JSONObject request_json = new JSONObject();
                request_json.put("id", request.data.get("id"));
                socket.response(
                        new Response(200, "OK", request_json),
                        request.ip,
                        request.port);
            } else {
                socket.response(new Response(3, "The password is different.", null), request.ip,
                        request.port);
            }
        }

    }

    static void login(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        AES256 aes256 = new AES256();

        // 로그인 요청시 id,password insert
        Statement querystmt;
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
            // String password = aes256.decrypt(result.getString("PassWord"));
            String password = result.getString("PassWord");

            // password_sql과 user가 입력한 password가 같다면
            // == 안됨!! 명심..
            if (request.data.get("password").equals(password)) {
                socket.response(
                        new Response(200, "OK", new User(result, true).getJson()),
                        request.ip,
                        request.port);
                CONNECT.broadcastFetchFriend(result.getString("ID"));
                // 로그인 성공시 해당 유저 아이디 UserStatus 갱신
                // querystmt

                // 로그인 시간 now, 횟수 더하기.
                String statusUpdate = String.format(
                        "update UserStatus set ResentlyConnectionTime = now(), NumberOfLogins = NumberOfLogins + 1, ConnectionStatus = 'online' where id = '%s';", request.data.get("id"));
                int ret = querystmt.executeUpdate(statusUpdate);
            } else {
                socket.response(new Response(3, "The password is different.", null), request.ip,
                        request.port);
            }
        }
    }

    static void logout(Network socket, Request request, Connection con, Statement updatestmt) throws Exception{
        Statement querystmt;
        String logout_sql = String.format("update UserStatus set ResentlyLogOutTime = now(), ConnectionStatus = 'offline' where id = '%s';",request.data.get("id"));
        querystmt = con.createStatement();
        querystmt.executeUpdate(logout_sql);
        socket.response(
            new Response(200, "You have been logged out.", null),
            request.ip,
            request.port);
        CONNECT.broadcastFetchFriend(request.data.getString("id"));
    }

    static void changePassword(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        AES256 aes256 = new AES256();
        String new_password = aes256.encrypt(request.data.getString("password"));

        // 로그인 요청시 id,password insert
        Statement querystmt;
        String change_pass_sql = String.format("update user set password = '%s' where id = '%s';", new_password,
                request.data.get("id"));
        querystmt = con.createStatement();
        querystmt.executeUpdate(change_pass_sql);
        socket.response(
                new Response(200, "Password change is complete!", null),
                request.ip,
                request.port);
    }

    static void FindPassword(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        AES256 aes256 = new AES256();

        Statement querystmt;
        String FindPassword = String.format(
                "select PassWord from User where ID = \"%s\" and Birthday = \"%s\" and Name = \"%s\"",
                request.data.get("Id"), request.data.get("birthday"), request.data.get("name"));
        querystmt = con.createStatement();

        ResultSet FindPassword_result = querystmt.executeQuery(FindPassword);

        if (!FindPassword_result.next()) { // 해당하는 내용과 일치하는 사람이 없다면?
            socket.response(new Response(4, "No data matching that information exists.", null), request.ip,
                    request.port);
        } else {
            String Finded_Password = aes256.decrypt(FindPassword_result.getString("PassWord"));

            // 만일 데이터가 존재한다면?
            socket.response(new Response(201, Finded_Password, null), request.ip, request.port);
        }
    }

    static void addFriend(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        // 친구 id가 이 메신저에 등록되어있는지 우선 확인.
        String exist_friend = String.format("select * from User where ID = \"%s\"", request.data.get("friendId"));
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
                // 존재안하면 추가.
                String add_sql = String.format("insert into Friend_List values(\"%s\", \"%s\")",
                        request.data.get("myId"), request.data.get("friendId"));
                updatestmt.executeUpdate(add_sql);
                socket.response(new Response(200, "OK", null), request.ip, request.port);
            }
        }
    }

    static void deleteFriend(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
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

            // 친구목록에 존재 안하면 삭제 안함.
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

        // 상태메세지 update하는 구문.
        String update_profile_sql = String.format(
                "update UserStatus set statusMessage = \"%s\" where id = \"%s\"",
                request.data.get("statusMessage"), request.data.get("id"));

        updatestmt.executeUpdate(update_profile_sql);
        update_profile_sql = String.format("update UserStatus set NickName = \"%s\" where id = \"%s\"",
                request.data.get("nickName"), request.data.get("id"));
        updatestmt.executeUpdate(update_profile_sql);

        socket.response(new Response(200, "OK", null), request.ip, request.port);
        CONNECT.broadcastFetchFriend(request.data.getString("id"));
    }

    static void changeProfileImage(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        Statement querystmt;

        String update_profile_sql = String.format(
                "update UserStatus set profile_image_id = \"%s\" where id = \"%s\"",
                request.data.get("imageId"), request.data.get("myId"));

        updatestmt.executeUpdate(update_profile_sql);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }

    static void changeProfileBackground(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        Statement querystmt;

        String update_profile_sql = String.format(
                "update UserStatus set profile_background_id = \"%s\" where id = \"%s\"",
                request.data.get("imageId"), request.data.get("myId"));

        updatestmt.executeUpdate(update_profile_sql);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }

    static void createRoom(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        JSONObject request_json = new JSONObject();
        request_json.put("myId", request.data.get("myId"));
        request_json.put("onetoone", request.data.get("onetoone"));
        request_json.put("ids", request.data.get("ids"));

        // 10자리 랜덤 문자열(영어+숫자) 생성
        char[] tmp = new char[10];
        for (int i = 0; i < tmp.length; i++) {
            int div = (int) Math.floor(Math.random() * 2);
            if (div == 0) { // 0이면 숫자로
                tmp[i] = (char) (Math.random() * 10 + '0');
            } else { // 1이면 알파벳
                tmp[i] = (char) (Math.random() * 26 + 'A');
            }
        }
        String roomId = new String(tmp);

        // 랜덤 문자열이 다른 roomid와 겹치는지 check
        String same_room_id = "select id from Room;";
        Statement querystmt;
        querystmt = con.createStatement();
        ResultSet result = querystmt.executeQuery(same_room_id);
        while (result.next()) {
            if (result.getString("id") == roomId) {
                createRoom(socket, request, con, updatestmt);
                return;
            }
        }

        // 자동 commit false
        // 둘 중 하나 오류나면 안 올라감.
        con.setAutoCommit(false);

        String create_room = String.format(
                "insert into Room(id,Title,CreateUserId,Onetoone) values('%s', 'null', '%s', '%s');", roomId,
                request_json.get("myId"),
                request_json.get("onetoone"));
        updatestmt.executeUpdate(create_room);
        for (int i = 0; i < request_json.getJSONArray("ids").length(); i++) {
            String create_room_user = String.format("insert into Room_User values('%s', '%s');", roomId,
                    request_json.getJSONArray("ids").getString(i));
            updatestmt.executeUpdate(create_room_user);
        }

        con.commit();
        con.setAutoCommit(true);
        JSONObject result_json = new JSONObject();
        result_json.put("roomId", roomId);

        socket.response(new Response(200, "OK", result_json), request.ip, request.port);
    }

    // 사람 초대
    static void InvitePeople(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {

        String checkAlreadyInvite = String.format("select * from Room_User where id = '%s' and UserId = '%s';",
                request.data.get("roomId"), request.data.get("Id"));

        Statement CheckInvite = null;
        ResultSet rs = null;

        CheckInvite = con.createStatement();
        rs = CheckInvite.executeQuery(checkAlreadyInvite);

        if (rs.next()) {
            socket.response(new Response(2, "Already invited People", null), request.ip, request.port);
        } else {

            String send_invite = String.format("insert into Room_User valuse('%s', '%s');", request.data.get("roomId"), // room
                                                                                                                        // table
                                                                                                                        // ID
                    request.data.get("Id")); // user table ID (초대한 친구)
            Statement querystmt;
            querystmt = con.createStatement();
            querystmt.executeQuery(send_invite);
            socket.response(new Response(200, "OK", null), request.ip, request.port);
        }
    }

    // room 퇴장
    static void ExitRoom(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {

        String send_ExitRoom = String.format("delete from Room_User where id = '%s' and UserId = '%s';",
                request.data.get("roomId"), // room table ID
                request.data.get("Id")); // user table ID

        updatestmt.executeUpdate(send_ExitRoom);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }

    static void sendChat(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        JSONObject request_json = new JSONObject();
        request_json.put("roomId", request.data.get("roomId"));
        request_json.put("myId", request.data.get("myId"));
        request_json.put("message", request.data.get("message"));
        String send_chat = String.format("insert into Chat(Room_id, UserId, message) values('%s', '%s', '%s');",
                request_json.get("roomId"),
                request_json.get("myId"), request_json.get("message"));
        updatestmt.executeUpdate(send_chat);

        // JSONObject response_json = new JSONObject();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR_OF_DAY, 9);
        java.util.Date date = new Date(calendar.getTimeInMillis());

        String dateResult = sdf.format(date);

        // response_json.put("userid", request_json.get("myId"));
        // response_json.put("created_at", dateResult);
        // response_json.put("message", request_json.get("message"));

        String find_nickname = String.format("select NickName from UserStatus where id = \"%s\";",
                request_json.get("myId"));
        Statement querystmt;
        querystmt = con.createStatement();
        ResultSet result = querystmt.executeQuery(find_nickname);
        result.next();

        // response_json.put("nickname", result.getString("NickName"));

        String find_chatMember = String.format("select UserId from Room_User where id = \"%s\";",
                request_json.get("roomId"));
        querystmt = con.createStatement();
        ResultSet member_result = querystmt.executeQuery(find_chatMember);
        List<String> members = new ArrayList<String>();
        while (member_result.next()) {
            members.add(member_result.getString("UserId"));
        }
        CONNECT.broadcastReceivePostChat(request_json.getString("myId"), members);

        // socket.response(new Response(200, "OK", response_json), request.ip,
        // request.port);
        socket.response(new Response(200, "OK", null), request.ip, request.port);
    }
}
