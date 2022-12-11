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
    return SingleChildScrollView(
        child: Obx(
      () => controller.chatWidgetList.value.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: const [
                    Text(
                      "채팅방이 존재하지 않습니다.",
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "새로운 채팅을 시작해보세요",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: controller.chatWidgetList.value,
            ),
    ));
  }
}
