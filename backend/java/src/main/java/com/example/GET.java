package com.example;

import java.sql.*;

import org.json.JSONArray;
import org.json.JSONObject;

public class GET {
    static void updateMyData(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        // 갱신 요청시에 userid를 얻어서 User,UserStatus 넣어서 전송.

        JSONObject UpdateMyData_json = new JSONObject();

        UpdateMyData_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.

        String UpdateMyData_sql = String.format(
                "SELECT User.ID,Name,EMail,Birthday,NickName,StatusMessage,UF.path as profile_image_path,UF2.path as profile_background_path FROM User LEFT JOIN UserStatus ON User.ID = UserStatus.ID LEFT JOIN User_file UF ON UserStatus.profile_image_id = UF.id LEFT JOIN User_file UF2 ON UserStatus.profile_background_id = UF2.id WHERE User.ID = \"%s\"",
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
            socket.response(new Response(10, "Not Founded User Friend Data", null),
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
}
