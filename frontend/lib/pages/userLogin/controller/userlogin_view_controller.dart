import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLoginViewController extends GetxController {
  static UserLoginViewController get instance => Get.find<UserLoginViewController>();
  TextEditingController idFieldController = TextEditingController();
  TextEditingController passFieldController = TextEditingController();

  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 14);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 14);
  static Widget textField({required textEditController, required String hintText, bool pass = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.6, color: Colors.black.withOpacity(0.3))),
      ),
      child: TextField(
        controller: textEditController,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          hintStyle: _hintStyle,
        ),
        cursorColor: Colors.black38,
        style: _textStyle,
      ),
    );
  }

  Future<void> userLogin() async {
    if (idFieldController.text.isEmpty || passFieldController.text.isEmpty) {
      Common.showSnackBar(messageText: "모든 항목을 작성해주세요.");
      return;
    }
    ApiResponse<PostUserLoginResponse> response = await ApiService.instance.userLogin(
      id: idFieldController.text,
      password: passFieldController.text,
    );
    if (response.result) {
      // Common.showSnackBar(messageText: "로그인에 성공하였습니다.");
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  @override
  void onClose() {
    idFieldController.dispose();
    passFieldController.dispose();
    super.onClose();
  }
}
