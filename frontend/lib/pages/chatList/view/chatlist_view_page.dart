import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/pages/chatList/controller/chatlist_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListViewPage extends StatelessWidget {
  const ChatListViewPage({super.key});

  static const url = '/chat_list';
  static CommonAppBar appBar = CommonAppBar(
    titleString: '채팅',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    centerTitle: false,
    // elevation: 1.0,
    actions: const [],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatListViewController());
    return Column(
      children: const [],
    );
  }
}
