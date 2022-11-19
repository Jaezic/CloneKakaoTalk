package com.example;

import java.sql.ResultSet;
import org.json.JSONObject;

public class User {
    JSONObject response_json;

    User(ResultSet user_result, ResultSet userStatus_result) throws Exception {
        this.response_json = new JSONObject();
        response_json.put("id", user_result.getString("ID"));
        response_json.put("name", user_result.getString("Name"));
        response_json.put("email", user_result.getString("EMail"));
        response_json.put("birthday", user_result.getString("Birthday"));
        response_json.put("nickname", userStatus_result.getString("NickName"));
        response_json.put("bio", userStatus_result.getString("StatusMessage"));
    }

    JSONObject getJson() {
        return response_json;
    }
}
