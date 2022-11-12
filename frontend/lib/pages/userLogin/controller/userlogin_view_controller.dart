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

  @override
  void onClose() {
    idFieldController.dispose();
    passFieldController.dispose();
    super.onClose();
  }
}
