import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/widget/common_appbar.dart';
import 'package:kakaotalk/pages/chatList/view/chatlist_view_page.dart';
import 'package:kakaotalk/pages/friend/view/friend_view_page.dart';

class MainController extends GetxController {
  MainController(this.context);
  BuildContext context;
  static MainController get instance => Get.find<MainController>();
  RxInt pageIndex = 0.obs;

  void selectTab(int index) {
    pageIndex.value = index;
    update();
  }

  final List<Widget> bodyContent = [const FriendViewPage(), const ChatListViewPage()];

  final List<CommonAppBar?> appBarContent = [
    FriendViewPage.appBar,
    ChatListViewPage.appBar,
  ];
}
