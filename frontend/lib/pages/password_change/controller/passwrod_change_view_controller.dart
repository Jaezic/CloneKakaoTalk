import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordChangeViewController extends GetxController {
  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 15);
  static TextStyle get _hintStyle3 => const TextStyle(color: Colors.black54, fontSize: 12);
  static TextStyle get _hintStyle2 => const TextStyle(color: Colors.transparent, fontSize: 15);
  static TextStyle get _hintStyle4 => const TextStyle(color: Colors.redAccent, fontSize: 12);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 15);

  RxBool check = false.obs;

  RxList<bool> foucsList = [false, false, false].obs;
  RxList<String> headText = ["", "", ""].obs;
  List<String> storeHintText = ["", "", ""];
  List<TextEditingController> controllerList = [TextEditingController(), TextEditingController(), TextEditingController()];
  @override
  void onInit() {
    super.onInit();
    controllerList[2].addListener(_passVerify);
    controllerList[1].addListener(_passVerify);

    for (var element in controllerList) {
      element.addListener(() {
        if (controllerList[0].text.isEmpty ||
            controllerList[1].text.isEmpty ||
            controllerList[2].text.isEmpty ||
            controllerList[1].text != controllerList[2].text) {
          check.value = false;
        } else {
          check.value = true;
        }
      });
    }
  }

  void _passVerify() {
    if (controllerList[2].text != controllerList[1].text) {
      headText.value[2] = "비밀번호가 일치하지 않습니다.";
    }
    // if (controllerList[1].text.length < 6) {
    //   headText.value[1] = "비밀번호는 6자 이상이어야 합니다.";
    // }
    else {
      headText.value[1] = storeHintText[1];
    }
    if (controllerList[2].text.isEmpty || controllerList[2].text == controllerList[1].text) {
      headText.value[2] = storeHintText[2];
    }
    headText.refresh();
  }

  Widget textField({required int index, required String hintText, bool pass = true}) {
    headText.value[index] = hintText;
    storeHintText[index] = hintText;
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.6, color: Colors.black.withOpacity(0.3))),
      ),
      child: Focus(
          onFocusChange: (hasFocus) {
            if (controllerList[index].text.isEmpty) {
              foucsList.value[index] = hasFocus;
            }
            foucsList.refresh();
          },
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                foucsList.value[index] == true
                    ? SizedBox(
                        height: 25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              headText.value[index],
                              style: headText.value[index] == storeHintText[index] ? _hintStyle3 : _hintStyle4,
                            ),
                          ],
                        ))
                    : const SizedBox(
                        height: 25,
                      ),
                TextField(
                  controller: controllerList[index],
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hintText,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 0, bottom: 15, left: 5, right: 5),
                    hintStyle: foucsList.value[index] == true ? _hintStyle2 : _hintStyle,
                    suffix: GestureDetector(
                      onTap: controllerList[index].clear,
                      child: const Icon(
                        Icons.clear_outlined,
                        size: 17,
                      ),
                    ),
                  ),
                  obscureText: pass,
                  cursorColor: Colors.black38,
                  style: _textStyle,
                ),
              ],
            ),
          )),
    );
  }

  Future<void> passwordChange() async {
    if (!check.value) return;
    ApiResponse<String> checkpasswordRP = await ApiService.instance.checkPassword(password: controllerList[0].text);
    if (!checkpasswordRP.result) {
      Common.showSnackBar(messageText: checkpasswordRP.errorMsg);
      return;
    }
    ApiResponse<String> response = await ApiService.instance.updatePassword(
      newpassword: controllerList[2].text,
    );
    if (response.result) {
      Common.showSnackBar(messageText: "성공적으로 비밀번호가 변경되었습니다.\n다시 로그인해주세요.");
      AuthService.instance.logout();
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }

  @override
  void onClose() {
    for (var element in controllerList) {
      element.dispose();
    }
    super.onClose();
  }
}
