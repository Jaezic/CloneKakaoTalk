import 'package:KakaoTalk/pages/friend/view/setting_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendViewController extends GetxController {
  RxInt friendCnt = 0.obs;
  FriendViewController(this.context);
  BuildContext context;
  static FriendViewController get instance => Get.find<FriendViewController>();

  Future<void> showSettingDialog() {
    return showCupertinoModalPopup(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return const SettingDialog();
        });
  }
}
