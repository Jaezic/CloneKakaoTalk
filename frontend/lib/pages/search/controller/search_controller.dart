import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/friend/view/friend_view_page.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rxn<DateTime> birthday = Rxn();
  RxString birthdayString = RxString('');
  RxnBool isGenderMale = RxnBool();
  Rx<bool> check = false.obs;
  RxList<Widget> searchUserList = RxList();

  @override
  void onInit() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        check.value = false;
      } else {
        check.value = true;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void searchUser(String targetName) async {
    if (targetName.isEmpty) return;
    ApiResponse<PostUserLoginResponse> response = await ApiService.instance.getUserInfo(userId: targetName);
    searchUserList.clear();
    if (response.result) {
      searchUserList.add(FriendViewPage.FriendTuple(
          user: response.value!.user!,
          onTap: () {
            Get.toNamed(ProfileViewPage.url, arguments: {"user": response.value!.user!});
          }));
    } else {
      searchUserList.add(const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Text(
          '검색 결과가 없습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ));
    }
    update();
  }
}
