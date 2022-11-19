import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/post_upload_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileChangeController extends GetxController {
  TextEditingController? nameFieldController;
  TextEditingController? bioFieldController;

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
      ApiResponse<String> uploadResponse = await ApiService.instance.changeProfileImage(userFileId: response.value!.id!);
      if (uploadResponse.result) {
        //await ApiService.instance.userMe();
        // Common.showSnackBar(messageText: uploadResponse.value ?? "");
      } else {
        Common.showSnackBar(messageText: response.errorMsg);
      }
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  @override
  void onInit() {
    nameFieldController = TextEditingController(text: "");

    bioFieldController = TextEditingController(text: "");
    super.onInit();
  }

  @override
  void onClose() {
    nameFieldController!.dispose();
    bioFieldController!.dispose();
    super.onClose();
  }
}
