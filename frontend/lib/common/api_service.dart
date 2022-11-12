import 'dart:convert';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/udp.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:get/get.dart';

class ApiService extends GetxService {
  static ApiService get instance => Get.find<ApiService>();

  Future<ApiService> init() async {
    Common.logger.d('$runtimeType init!');
    return this;
  }

  Future<ApiResponse<PostUserLoginResponse>> userRegister({
    required String id,
    required String pass,
    required String name,
    required String nickname,
    required String email,
    required DateTime birthday,
  }) async {
    try {
      String birthdayString = "${birthday.year}-${birthday.month}-${birthday.day}";

      var response = await Udp.post(
        'register',
        data: jsonEncode({
          "id": id,
          "pass": pass,
          "name": name,
          "nickname": nickname,
          "email": email,
          "birthday": birthdayString,
        }),
      );
      // User postUserRegisterResponse = User.fromJson(response.data);
      // DbService.instance.userBox.put(UserDbKey.userInfo.key, postUserRegisterResponse.toJson());
      // ApiResponse<PostUserLoginResponse> loginResponse = await userLogin(email: email, password: password);
      // return loginResponse;
      return ApiResponse(
        result: false,
      );
    } catch (e) {
      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }
}
