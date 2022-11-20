import 'dart:convert';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/dio_extension.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/udp.dart';
import 'package:KakaoTalk/models/post_upload_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';

class ApiService extends GetxService {
  Dio dio = Dio(BaseOptions(baseUrl: Common.serverUrl));
  Options dioOptions = Options();

  static ApiService get instance => Get.find<ApiService>();

  Future<ApiService> init() async {
    Common.logger.d('$runtimeType init!');
    return this;
  }

  Future<ApiResponse<PostUploadResponse>> upload({required XFile userFile}) async {
    try {
      FormData data;
      if (GetPlatform.isWeb) {
        final bytes = await userFile.readAsBytes();
        final MultipartFile file = MultipartFile.fromBytes(bytes, filename: userFile.name);
        data = FormData.fromMap({'userfile': file});
      } else {
        data = FormData.fromMap({'userfile': await MultipartFile.fromFile(userFile.path, filename: userFile.name)});
      }
      var response = await dio.post('/upload', options: dioOptions, data: data);
      PostUploadResponse postUploadResponse = PostUploadResponse.fromJson(response.data);
      return ApiResponse<PostUploadResponse>(result: response.isSuccessful, value: postUploadResponse);
    } on DioError catch (e) {
      Common.logger.d(e);
      try {
        return ApiResponse<PostUploadResponse>(result: false, errorMsg: e.response?.data['message'] ?? "오류가 발생했습니다.");
      } catch (e) {
        return ApiResponse<PostUploadResponse>(result: false, errorMsg: "오류가 발생했습니다.");
      }
    } catch (e) {
      return ApiResponse<PostUploadResponse>(result: false, errorMsg: "오류가 발생했습니다.");
    }
  }

  Future<ApiResponse<String>> changeProfileImage({required int userFileId}) async {
    try {
      var response = await dio.post(
        '/v1/user/change_profile_image',
        options: dioOptions,
        data: jsonEncode(
          {
            "profile_image_id": userFileId,
          },
        ),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.data["message"]);
    } on DioError catch (e) {
      Common.logger.d(e);
      try {
        return ApiResponse<String>(result: false, errorMsg: e.response?.data['message'] ?? "오류가 발생했습니다.");
      } catch (e) {
        return ApiResponse<String>(result: false, errorMsg: "오류가 발생했습니다.");
      }
    } catch (e) {
      return ApiResponse<String>(result: false, errorMsg: "오류가 발생했습니다.");
    }
  }

  Future<ApiResponse<PostUserLoginResponse>> userRegister({
    required String id,
    required String pass,
    required String name,
    required String nickname,
    required String email,
    required DateTime birthday,
    required String homeaddress,
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
          "homeaddress": homeaddress,
          "birthday": birthdayString,
        }),
      );

      return userLogin(id: id, password: pass);
    } catch (e) {
      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<PostUserLoginResponse>> userLogin({
    required String id,
    required String password,
  }) async {
    try {
      var response = await Udp.post(
        'login',
        data: jsonEncode({
          "id": id,
          "password": password,
        }),
      );
      PostUserLoginResponse postUserLoginResponse = PostUserLoginResponse.fromJson(response.data);
      AuthService.instance.user.value = User.fromJson(postUserLoginResponse.toJson()['user']);

      print(AuthService.instance.user.value);
      if (AuthService.instance.user.value!.id == null) {
        return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: "유저 정보를 가져올 수 없습니다.");
      }
      return ApiResponse<PostUserLoginResponse>(result: true, value: postUserLoginResponse);
    } catch (e) {
      e.printError();

      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> addFriend({
    required String frinedId,
  }) async {
    try {
      var response = await Udp.post(
        'addFriend',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "friendId": frinedId,
        }),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.statusMessage);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<PostUserLoginResponse>> userMe() async {
    try {
      var response = await Udp.get(
        'UpdateMyData',
        data: jsonEncode({
          "id": AuthService.instance.user.value!.id,
        }),
      );
      PostUserLoginResponse getUserResponse = PostUserLoginResponse.fromJson(response.data);
      AuthService.instance.user.value = User.fromJson(getUserResponse.toJson()['user']);

      if (AuthService.instance.user.value!.id == null) {
        return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: "유저 정보를 가져올 수 없습니다.");
      }
      return ApiResponse<PostUserLoginResponse>(result: true, value: getUserResponse);
    } catch (e) {
      e.printError();

      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<PostUserLoginResponse>> getUserInfo({required String userId}) async {
    try {
      var response = await Udp.get(
        'UpdateMyData',
        data: jsonEncode({
          "id": userId,
        }),
      );
      PostUserLoginResponse getUserResponse = PostUserLoginResponse.fromJson(response.data);

      if (!response.isSuccessful) {
        return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: "유저 정보를 가져올 수 없습니다.");
      }
      return ApiResponse<PostUserLoginResponse>(result: true, value: getUserResponse);
    } catch (e) {
      e.printError();

      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> updateProfile({required String name, required String bio}) async {
    try {
      var response = await Udp.post(
        'myProfile',
        data: jsonEncode({
          "id": AuthService.instance.user.value!.id,
          "nickName": name,
          "statusMessage": bio,
        }),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.data.toString());
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }
}
