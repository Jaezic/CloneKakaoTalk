package com.example;

import java.sql.ResultSet;
import org.json.JSONObject;

public class User {
    JSONObject response_json;

    User(ResultSet user_result) throws Exception {
        this.response_json = new JSONObject();
        response_json.put("id", user_result.getString("ID"));
        response_json.put("name", user_result.getString("Name"));
        response_json.put("email", user_result.getString("EMail"));
        response_json.put("birthday", user_result.getString("Birthday"));
        response_json.put("nickname", user_result.getString("NickName"));
        response_json.put("bio", user_result.getString("StatusMessage"));
        response_json.put("profile_image_path", user_result.getString("profile_image_path"));
        response_json.put("profile_background_path", user_result.getString("profile_background_path"));
    }

    JSONObject getJson() {
        return response_json;
    }
}
