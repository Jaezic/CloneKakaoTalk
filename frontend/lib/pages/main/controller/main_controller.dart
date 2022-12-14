import 'dart:convert';

import 'package:KakaoTalk/common/response.dart';
import 'package:KakaoTalk/common/tcp.dart';
import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:KakaoTalk/pages/chatList/controller/chatlist_view_controller.dart';
import 'package:KakaoTalk/pages/chatList/view/chatlist_view_page.dart';
import 'package:KakaoTalk/pages/friend/controller/friend_view_controller.dart';
import 'package:KakaoTalk/pages/friend/view/friend_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

class MainController extends GetxController {
  MainController(this.context);
  BuildContext context;
  static MainController get instance => Get.find<MainController>();
  RxInt pageIndex = 0.obs;
  Tcp? tcp;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    tcp = await Tcp.connect(
      "userConnect",
      data: jsonEncode({"userID": AuthService.instance.user.value!.id}),
    );
    tcp?.listen((data) async {
      Response response = Tcp.receive(data, tcp!.connectSocket!.address, tcp!.connectSocket!.port);
      if (!response.isSuccessful) {
        tcp!.socketClose();
        return;
      }
      if (response.statusMessage == "updateFriend") {
        await FriendViewController.instance.fetchFriendList();
      }
      if (response.statusMessage == "receivePostChat") {
        if (Get.currentRoute == "/chat_view") {
          final controller = Get.find<ChatViewController>(tag: response.data['tag']);
          controller.receiveAllChats(AuthService.instance.currentChatRoomid);
        }
        ChatListViewController.instance.updateChatList();
      }
      if (response.statusMessage == "fetchRooms") {
        ChatListViewController.instance.updateChatList();
      }
      if (response.statusMessage == "fetchRoom") {
        if (Get.currentRoute == "/chat_view") {
          final controller = Get.find<ChatViewController>(tag: response.data['tag']);
          controller.updateRoom(AuthService.instance.currentChatRoomid);
        }
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    tcp?.socketClose();
    super.onClose();
  }

  void selectTab(int index) {
    pageIndex.value = index;
    if (index == 1) {
      ChatListViewController.instance.updateChatList();
    }
    update();
  }

  final List<Widget> bodyContent = [const FriendViewPage(), const ChatListViewPage()];

  final List<CommonAppBar?> appBarContent = [
    FriendViewPage.appBar,
    ChatListViewPage.appBar,
  ];
}
