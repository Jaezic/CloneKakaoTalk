package com.example;

import java.sql.*;

import org.json.JSONObject;

public class GET {
    static void updateMyData(Network socket, Request request, Connection con, Statement updatestmt) throws Exception {
        Statement querystmt;
        // 갱신 요청시에 userid를 얻어서 User,UserStatus 넣어서 전송.

        JSONObject UpdateMyData_json = new JSONObject();

        UpdateMyData_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장.

        String UpdateMyData_sql = String.format("select * from User where ID = \"%s\"",
                request.data.get("id"));
        querystmt = con.createStatement();
        ResultSet user_result = querystmt.executeQuery(UpdateMyData_sql);
        if (!user_result.next()) {
            socket.response(new Response(2, "Not Founded User Data", null),
                    request.ip, request.port);
        } else {

            String sql = String.format(
                    "select NickName, StatusMessage from UserStatus where ID = \"%s\"",
                    request.data.get("id"));
            querystmt = con.createStatement();
            ResultSet userStatus_result = querystmt.executeQuery(sql);
            userStatus_result.next();

            socket.response(
                    new Response(200, "OK", new User(user_result, userStatus_result).getJson()),
                    request.ip,
                    request.port);
        }
    }
}
