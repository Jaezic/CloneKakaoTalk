import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/profile/view/friend_setting_dialog.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileViewController extends GetxController {
  static ProfileViewController get instance => Get.find<ProfileViewController>();
  Rxn<User> user = Rxn();
  @override
  void onInit() async {
    var arg = Get.arguments;
    if ((arg['user'] as User).id! == AuthService.instance.user.value!.id) {
      user = AuthService.instance.user;
    } else {
      user.value = arg['user'];
      var response = await ApiService.instance.getUserInfo(userId: arg['user'].id);
      user.value = response.value!.user!;
    }
    super.onInit();
  }

  Future<void> showFriendSettingDialog(BuildContext context) {
    return showCupertinoModalPopup(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return const FriendSettingDialog();
        });
  }
}
