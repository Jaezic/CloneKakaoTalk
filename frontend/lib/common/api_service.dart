import 'dart:convert';

import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/dio_extension.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/tcp.dart';
import 'package:KakaoTalk/models/get_chats_response.dart';
import 'package:KakaoTalk/models/get_friend_list_respone.dart';
import 'package:KakaoTalk/models/get_room_response.dart';
import 'package:KakaoTalk/models/get_rooms_response.dart';
import 'package:KakaoTalk/models/post_upload_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';

class ApiService extends GetxService {
  Dio dio = Dio(BaseOptions(baseUrl: Common.apiUrl));
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
        data = FormData.fromMap({'userfile': file, 'id': AuthService.instance.user.value!.id});
      } else {
        data = FormData.fromMap({'userfile': await MultipartFile.fromFile(userFile.path, filename: userFile.name), 'id': AuthService.instance.user.value!.id});
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

  Future<ApiResponse<String>> changeProfileImage({required int imageId}) async {
    try {
      var response = await Tcp.post(
        'changeProfileImage',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "imageId": imageId,
        }),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.statusMessage);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> changeProfileBackground({required int imageId}) async {
    try {
      var response = await Tcp.post(
        'changeProfileBackground',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "imageId": imageId,
        }),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.statusMessage);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
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

      var response = await Tcp.post(
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
      var response = await Tcp.post(
        'login',
        data: jsonEncode({
          "id": id,
          "password": password,
        }),
      );
      PostUserLoginResponse postUserLoginResponse = PostUserLoginResponse.fromJson(response.data);
      AuthService.instance.user.value = postUserLoginResponse.user;

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
      var response = await Tcp.post(
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
      var response = await Tcp.get(
        'UpdateMyData',
        data: jsonEncode({
          "id": AuthService.instance.user.value!.id,
        }),
      );
      PostUserLoginResponse getUserResponse = PostUserLoginResponse.fromJson(response.data);
      AuthService.instance.user.value = getUserResponse.user;

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
      var response = await Tcp.get(
        'UpdateMyData',
        data: jsonEncode({
          "id": userId,
        }),
      );
      PostUserLoginResponse getUserResponse = PostUserLoginResponse.fromJson(response.data);

      // if (!response.isSuccessful) {
      //   return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: "유저 정보를 가져올 수 없습니다.");
      // }
      return ApiResponse<PostUserLoginResponse>(result: true, value: getUserResponse);
    } catch (e) {
      Common.logger.d(e);

      return ApiResponse<PostUserLoginResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> updateProfile({required String name, required String bio}) async {
    try {
      var response = await Tcp.post(
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

  Future<ApiResponse<GetFriendListResponse>> fetchFriends() async {
    try {
      var response = await Tcp.get(
        'friendList',
        data: jsonEncode({
          "id": AuthService.instance.user.value!.id,
        }),
      );
      GetFriendListResponse getFriendListResponse = GetFriendListResponse();
      if (response.isSuccessful) {
        getFriendListResponse = GetFriendListResponse.fromJson(response.data);
      }
      return ApiResponse<GetFriendListResponse>(result: response.isSuccessful, value: getFriendListResponse);
    } catch (e) {
      e.printError();

      return ApiResponse<GetFriendListResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> fetchOneToOneRoom({required String targetid}) async {
    try {
      var response = await Tcp.get(
        'findOneToOne',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "friendId": targetid,
        }),
      );
      String roomid = "";
      if (!response.isSuccessful) {
        ApiResponse<String> response2 = await createRoom(onetoone: 1, ids: [AuthService.instance.user.value!.id, targetid]);
        roomid = response2.value!;
      } else {
        roomid = response.data['roomId'];
      }
      return ApiResponse<String>(result: true, value: roomid);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> createRoom({required int onetoone, required List ids}) async {
    try {
      var response = await Tcp.post(
        'createRoom',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "onetoone": onetoone,
          "ids": ids,
        }),
      );
      return ApiResponse<String>(result: response.isSuccessful, value: response.data['roomId']);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<GetRoomResponse>> fetchRoom({required String roomId}) async {
    try {
      var response = await Tcp.get(
        'fetchRoom',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
          "roomId": roomId,
        }),
      );
      GetRoomResponse getFriendListResponse = GetRoomResponse.fromJson(response.data);
      return ApiResponse<GetRoomResponse>(result: response.isSuccessful, value: getFriendListResponse);
    } catch (e) {
      e.printError();

      return ApiResponse<GetRoomResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<GetRoomsResponse>> fetchRooms() async {
    try {
      var response = await Tcp.get(
        'fetchRooms',
        data: jsonEncode({
          "myId": AuthService.instance.user.value!.id,
        }),
      );
      return ApiResponse<GetRoomsResponse>(result: response.isSuccessful, value: GetRoomsResponse.fromJson(response.data));
    } catch (e) {
      e.printError();

      return ApiResponse<GetRoomsResponse>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<String>> sendChat({required String roomId, required String message}) async {
    try {
      var response = await Tcp.post(
        'sendChat',
        data: jsonEncode({"myId": AuthService.instance.user.value!.id, "roomId": roomId, "message": message}),
      );
      //return ApiResponse<String>(result: response.isSuccessful, value: GetChatResponse.fromJson(response.data));
      return ApiResponse<String>(result: response.isSuccessful, value: null);
    } catch (e) {
      e.printError();

      return ApiResponse<String>(result: false, errorMsg: e.toString());
    }
  }

  Future<ApiResponse<GetChatsResponse>> receivePostChat({required String roomId}) async {
    try {
      var response = await Tcp.get(
        'receivePostChat',
        data: jsonEncode({"roomId": roomId, "myId": AuthService.instance.user.value!.id}),
      );

      return ApiResponse<GetChatsResponse>(result: response.isSuccessful, value: response.isSuccessful ? GetChatsResponse.fromJson(response.data) : null);
    } catch (e) {
      e.printError();

      return ApiResponse<GetChatsResponse>(result: false, errorMsg: e.toString());
    }
  }
}
