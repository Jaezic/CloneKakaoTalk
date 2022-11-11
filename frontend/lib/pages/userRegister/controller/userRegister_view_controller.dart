import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRegisterViewController extends GetxController {
  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 14);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 14);

  Rxn<DateTime> birthday = Rxn();
  RxString birthdayString = RxString('');
  TextEditingController idFieldController = TextEditingController();
  TextEditingController passFieldController = TextEditingController();
  TextEditingController passVerifyFieldController = TextEditingController();
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController nicknameFieldController = TextEditingController();
  TextEditingController emailFieldController = TextEditingController();
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          hintStyle: _hintStyle,
        ),
        obscureText: pass,
        cursorColor: Colors.black38,
        style: _textStyle,
      ),
    );
  }

  void onBirthDayDateChanged(DateTime dateTime) {
    birthday.value = dateTime;
    birthdayString.value = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  Future<T?> openBirthDayPickerPopup<T>({required BuildContext context}) {
    return showCupertinoModalPopup(
      barrierColor: Colors.black54,
      context: context,
      builder: ((context) {
        return Container(
          color: Colors.white,
          height: 300,
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              onDateTimeChanged: onBirthDayDateChanged,
              mode: CupertinoDatePickerMode.date,
            ),
          ),
        );
      }),
    );
  }

  @override
  void onClose() {
    idFieldController.dispose();
    passFieldController.dispose();
    passVerifyFieldController.dispose();
    nameFieldController.dispose();
    nicknameFieldController.dispose();
    emailFieldController.dispose();
    super.onClose();
  }
}
