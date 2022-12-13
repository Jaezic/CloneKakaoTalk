import 'package:KakaoTalk/common/api_service.dart';
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
}
