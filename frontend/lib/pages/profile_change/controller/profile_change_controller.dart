import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/post_upload_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileChangeController extends GetxController {
  TextEditingController? nameFieldController;
  TextEditingController? bioFieldController;

  Future<void> updateProfile() async {
    if (nameFieldController!.text == "") {
      Common.showSnackBar(messageText: "이름을 입력하세요.");
      return;
    }

    ApiResponse<String> response = await ApiService.instance.updateProfile(
      name: nameFieldController!.text,
      bio: bioFieldController!.text,
    );
    if (response.result) {
      if (response.value == null) {
        Common.showSnackBar(messageText: "오류가 발생했습니다");
        return;
      }
      ApiResponse<PostUserLoginResponse> response2 = await ApiService.instance.userMe();
      if (!response2.result) {
        Common.showSnackBar(messageText: "오류가 발생했습니다");
        return;
      }
      Get.back();
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  Future<void> changeProfileImage() async {
    XFile? userFile = await Common.getImageFromUser();
    if (userFile == null) {
      return;
    }
    ApiResponse<PostUploadResponse> response = await ApiService.instance.upload(userFile: userFile);
    if (response.result) {
      if (response.value?.id == null) {
        Common.showSnackBar(messageText: "오류가 발생했습니다");
        return;
      }
      ApiResponse<String> uploadResponse = await ApiService.instance.changeProfileImage(imageId: response.value!.id!);
      if (uploadResponse.result) {
        await ApiService.instance.userMe();
        Common.showSnackBar(messageText: uploadResponse.value ?? "");
      } else {
        Common.showSnackBar(messageText: response.errorMsg);
      }
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  Future<void> changeProfileBackground() async {
    XFile? userFile = await Common.getImageFromUser();
    if (userFile == null) {
      return;
    }
    ApiResponse<PostUploadResponse> response = await ApiService.instance.upload(userFile: userFile);
    if (response.result) {
      if (response.value?.id == null) {
        Common.showSnackBar(messageText: "오류가 발생했습니다");
        return;
      }
      ApiResponse<String> uploadResponse = await ApiService.instance.changeProfileBackground(imageId: response.value!.id!);
      if (uploadResponse.result) {
        await ApiService.instance.userMe();
        Common.showSnackBar(messageText: uploadResponse.value ?? "");
      } else {
        Common.showSnackBar(messageText: response.errorMsg);
      }
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  @override
  void onInit() {
    nameFieldController = TextEditingController(text: AuthService.instance.user.value!.nickname);

    bioFieldController = TextEditingController(text: AuthService.instance.user.value!.bio);
    super.onInit();
  }

  @override
  void onClose() {
    nameFieldController!.dispose();
    bioFieldController!.dispose();
    super.onClose();
  }
}
