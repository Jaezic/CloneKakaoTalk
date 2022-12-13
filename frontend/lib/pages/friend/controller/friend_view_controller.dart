import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/get_friend_list_respone.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/friend/view/friend_widgets.dart';
import 'package:KakaoTalk/pages/friend/view/setting_dialog.dart';
import 'package:KakaoTalk/pages/friend/view/weather.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendViewController extends GetxController {
  RxInt friendCnt = 0.obs;

  static FriendViewController get instance => Get.find<FriendViewController>();
  RxList<Widget> friendWidgetList = RxList();
  Rxn<Weather> weather = Rxn();

  @override
  void onInit() async {
    super.onInit();
    friendWidgetList.value = [];
    AuthService.instance.FriendIdList.value = [];
    var weather = Weather(latitude: 37.449768910451795, longitude: 127.1293218455751);
    await weather.weatherInfoGet();
    this.weather.value = weather;
    await fetchFriendList();
  }

  Future<void> fetchFriendList() async {
    ApiResponse<GetFriendListResponse> fetchResponse = await ApiService.instance.fetchFriends();
    if (!fetchResponse.result) {
      //Common.showSnackBar(messageText: fetchResponse.errorMsg);
      return;
    }
    friendWidgetList.clear();
    AuthService.instance.FriendIdList.clear();
    for (var element in fetchResponse.value!.datas!) {
      friendWidgetList.add(FriendWidgets.FriendTuple(
          user: User.fromJson(element),
          onTap: () {
            Get.toNamed(ProfileViewPage.url, arguments: {"user": User.fromJson(element)});
          }));
      AuthService.instance.FriendIdList.add(element['id']);
    }
    friendCnt.value = friendWidgetList.value.length;
    update();
  }

  Future<void> showSettingDialog(BuildContext context) {
    return showCupertinoModalPopup(
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return const SettingDialog();
        });
  }

  Future<void> showUnRegisterDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Text(
              "계정 탈퇴",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "정말 당신의 계정을 탈퇴하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {},
                child: const Text('네', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '아니요',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  Future<void> unregister() async {
    ApiResponse<String> response = await ApiService.instance.unregister();
    if (response.result) {
      Common.showSnackBar(messageText: "계정이 탈퇴되었습니다.");
      AuthService.instance.logout();
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
    }
  }
}
