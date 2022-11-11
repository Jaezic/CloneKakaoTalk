import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/widget/common_appbar.dart';
import 'package:kakaotalk/pages/friend/controller/friend_view_controller.dart';

class ChatListViewPage extends StatelessWidget {
  const ChatListViewPage({super.key});

  static const url = '/chat_list';
  static CommonAppBar appBar = CommonAppBar(
    titleString: '채팅',
    fontSize: 25,
    fontWeight: FontWeight.bold,
    centerTitle: false,
    // elevation: 1.0,
    actions: const [],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendViewController());
    return Column(
      children: const [],
    );
  }
}
