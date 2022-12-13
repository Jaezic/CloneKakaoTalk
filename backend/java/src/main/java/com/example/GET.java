package com.example;

import java.sql.*;

import org.json.JSONArray;
import org.json.JSONObject;

import com.mysql.cj.xdevapi.JsonArray;

public class GET {
    static void updateMyData(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        // 갱신 요청시에 userid를 얻어서 User,UserStatus 넣어서 전송.

        JSONObject UpdateMyData_json = new JSONObject();

        UpdateMyData_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.

        String UpdateMyData_sql = String.format(
                "SELECT User.ID,Name,EMail,Birthday,NickName,StatusMessage,UF.path as profile_image_path,UF2.path as profile_background_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id LEFT JOIN User_file UF2 ON UserStatus.profile_background_id = UF2.id WHERE User.ID like '%%%s%%'",
                request.data.get("id"));
        querystmt = con.createStatement();
        ResultSet user_result = querystmt.executeQuery(UpdateMyData_sql);
        if (!user_result.next()) {
            socket.response(new Response(2, "Not Founded User Data", null),
                    request.ip, request.port);
        } else {
            String key = request.data.getString("id");
            boolean isonline = App.connected_sockets.containsKey(key);
            socket.response(
                    new Response(200, "OK", new User(user_result, isonline).getJson()),
                    request.ip,
                    request.port);
        }
    }

    static void friendList(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt; // 친구 데이터 userid를 기준으로 friend_list에 담겨 있는거 받아서 friend_id 전송

        JSONObject myfriend_json = new JSONObject();

        myfriend_json.put("id", request.data.get("id"));
        String UpdateMyData_sql = String.format("select Friend_ID from Friend_List where ID = \"%s\"",
                myfriend_json.get("id"));
        querystmt = con.createStatement();

        ResultSet friend_result = querystmt.executeQuery(UpdateMyData_sql);

        if (!friend_result.next()) {
            socket.response(new Response(300, "Not Founded User Friend Data", null),
                    request.ip, request.port);
            return;
        }

        JSONObject data = new JSONObject();
        JSONArray array = new JSONArray();
        do {
            String sql = String.format(
                    "SELECT User.ID,Name,EMail,Birthday,NickName,StatusMessage,UF.path as profile_image_path,UF2.path as profile_background_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id LEFT JOIN User_file UF2 ON UserStatus.profile_background_id = UF2.id WHERE User.ID = \"%s\"", // 친구
                    // id를
                    // 기반으로
                    // UserStatus에
                    // 저장된
                    // statusMessage 가져옴.
                    friend_result.getString("Friend_ID"));
            querystmt = con.createStatement();
            ResultSet FriendStatus_result = querystmt.executeQuery(sql);
            FriendStatus_result.next();
            String key = FriendStatus_result.getString("ID");
            boolean isonline = App.connected_sockets.containsKey(key);
            array.put(new User(FriendStatus_result, isonline).getJson());
        } while (friend_result.next());

        data.put("datas", array);
        socket.response(
                new Response(200, "OK", data),
                request.ip,
                request.port);
    }

    static void fetchRoom(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        JSONObject request_json = new JSONObject();
        request_json.put("roomId", request.data.get("roomId"));
        request_json.put("myId", request.data.get("myId"));

        String fetch_Room = String.format("select * from Room where id = \"%s\"",
                request_json.get("roomId"));
        querystmt = con.createStatement();
        ResultSet fetch_Room_result = querystmt.executeQuery(fetch_Room);
        if (!fetch_Room_result.next()) {
            socket.response(new Response(7, "Not Founded Chat Room", null), request.ip, request.port);
            return;
        }
        JSONObject data = new JSONObject();
        data.put("roomId", fetch_Room_result.getString("id"));
        data.put("createUserId", fetch_Room_result.getString("CreateUserId"));
        JSONArray array = new JSONArray();

        String room_User = String.format("select * from Room_User where id = \"%s\"",
                fetch_Room_result.getString("id"));
        querystmt = con.createStatement();

        ResultSet room_User_result = querystmt.executeQuery(room_User);

        String title = "";
        if (!room_User_result.next()) {
            socket.response(new Response(10, "Not Founded a User in the Room", null),
                    request.ip, request.port);
            return;
        }
        do {
            String sql = String.format(
                    "SELECT User.ID,Name,EMail,Birthday,NickName,StatusMessage,UF.path as profile_image_path,UF2.path as profile_background_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id LEFT JOIN User_file UF2 ON UserStatus.profile_background_id = UF2.id WHERE User.ID = \"%s\"", // 친구
                    // id를
                    // 기반으로
                    // UserStatus에
                    // 저장된
                    // statusMessage 가져옴.
                    room_User_result.getString("UserId"));
            querystmt = con.createStatement();
            ResultSet roomUserResult = querystmt.executeQuery(sql);
            roomUserResult.next();
            String key = roomUserResult.getString("ID");
            boolean isonline = App.connected_sockets.containsKey(key);
            if (!key.equals(request_json.get("myId"))) {
                if (title.equals(""))
                    title += roomUserResult.getString("NickName");
                else
                    title += "," + roomUserResult.getString("NickName");
            }

            array.put(new User(roomUserResult, isonline).getJson());
        } while (room_User_result.next());
        data.put("title", title);
        data.put("users", array);
        socket.response(new Response(200, "OK", data), request.ip, request.port);
    }

    static void findOneToOne(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        // 나와 상대방이 들어있는 방 중에 1 : 1 방 검색
        String find_one_to_one = String.format(
                "select id from Room where id in (select a.id from Room_User as a, Room_User as b where a.id = b.id and a.userid = '%s' and b.userid = '%s') and onetoone = true;",
                request.data.get("myId"), request.data.get("friendId"));
        querystmt = con.createStatement();
        ResultSet result = querystmt.executeQuery(find_one_to_one);
        while (result.next()) {
            // 1 : 1 채팅방이라면
            JSONObject reponse_json = new JSONObject();
            reponse_json.put("roomId", result.getString("id"));
            socket.response(new Response(200, "OK", reponse_json), request.ip, request.port);
            return;
        }
        // result.next()가 false인 경우도 있기 때문에 따로 빼놓음.
        socket.response(new Response(300, "There is no 1:1 chat room.", null), request.ip, request.port);

    }

    static void fetchRooms(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        JSONObject request_json = new JSONObject();
        request_json.put("myId", request.data.get("myId"));
        String find_rooms = String.format(
                "Select id, update_at from Room where id in (select id from Room_User where UserID = \"%s\");",
                request_json.get("myId"));
        querystmt = con.createStatement();
        ResultSet rooms_result = querystmt.executeQuery(find_rooms);

        if (!rooms_result.next()) {
            socket.response(new Response(300, "Not Founded Rooms", null),
                    request.ip, request.port);
            return;
        }
        JSONObject data = new JSONObject();
        JSONArray array = new JSONArray();
        do {
            String title = "";
            JSONObject room_info = new JSONObject();
            JSONArray users_info = new JSONArray();

            String sql = String.format(
                    "select message, created_at from Chat where Room_id = \"%s\" order by created_at desc Limit 1;",
                    rooms_result.getString("id"));
            querystmt = con.createStatement();
            ResultSet latestChatResult = querystmt.executeQuery(sql);
            if (latestChatResult.next()) {
                room_info.put("update_at", latestChatResult.getTimestamp("created_at"));
                room_info.put("latest_message", latestChatResult.getString("message"));
            } else
                room_info.put("update_at", rooms_result.getTimestamp("update_at"));
            sql = String.format(
                    "SELECT User.ID,NickName,UF.path as profile_image_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id WHERE User.ID in (select UserId from Room_User where id = \"%s\");",
                    rooms_result.getString("id"));
            querystmt = con.createStatement();
            ResultSet roomUserResult = querystmt.executeQuery(sql);

            room_info.put("roomId", rooms_result.getString("id"));
            while (roomUserResult.next()) {
                String key = roomUserResult.getString("ID");
                if (!key.equals(request_json.get("myId"))) {
                    if (title.equals(""))
                        title += roomUserResult.getString("NickName");
                    else
                        title += "," + roomUserResult.getString("NickName");
                    JSONObject user_info = new JSONObject();
                    user_info.put("nickname", roomUserResult.getString("NickName"));
                    user_info.put("profile_image_path", roomUserResult.getString("profile_image_path"));
                    users_info.put(user_info);
                }
            }
            room_info.put("title", title);
            room_info.put("users", users_info);

            array.put(room_info);
        } while (rooms_result.next());
        data.put("datas", array);
        socket.response(
                new Response(200, "OK", data),
                request.ip,
                request.port);
    }

    static void receivePostChat(Network socket, Request request, Connection con, Statement updatestmt)
            throws Exception {
        Statement querystmt;
        JSONObject request_json = new JSONObject();
        request_json.put("roomId", request.data.get("roomId"));
        request_json.put("myId", request.data.get("myId"));

        String sql = String.format("Select * from Chat where Room_id = \"%s\" order by created_at desc Limit 60;",
                request_json.get("roomId"));
        querystmt = con.createStatement();
        ResultSet chatResult = querystmt.executeQuery(sql);
        if (!chatResult.next()) {
            socket.response(new Response(300, "Not Founded Chats", null),
                    request.ip, request.port);
            return;
        }
        JSONObject data = new JSONObject();
        JSONObject users = new JSONObject();
        JSONArray chats = new JSONArray();
        do {
            JSONObject chat = new JSONObject();
            chat.put("userid", chatResult.getString("UserId"));
            chat.put("message", chatResult.getString("message"));
            chat.put("created_at", chatResult.getString("created_at"));

            String user_status_sql = String.format(
                    "SELECT User.ID,NickName,UF.path as profile_image_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id WHERE User.ID = \"%s\";",
                    chatResult.getString("UserId"));
            querystmt = con.createStatement();
            ResultSet userResult = querystmt.executeQuery(user_status_sql);
            userResult.next();
            JSONObject chat_user_info = new JSONObject();
            chat_user_info.put("nickname", userResult.getString("NickName"));
            chat_user_info.put("profile_image_path", userResult.getString("profile_image_path"));
            users.put(chatResult.getString("UserId"), chat_user_info);

            chats.put(chat);
        } while (chatResult.next());
        data.put("datas", chats);
        data.put("users", users);
        socket.response(
                new Response(200, "OK", data),
                request.ip,
                request.port);
    }
}
