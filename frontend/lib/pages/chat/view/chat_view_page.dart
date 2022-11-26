import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:KakaoTalk/pages/chat/view/chat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ChatViewPage extends StatelessWidget {
  const ChatViewPage({super.key});

  static const url = "/chat_view";
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatViewController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 175, 193, 207),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 174, 191, 208),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            '정민규',
            style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(LineIcons.bars))],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            controller: controller.scrollController,
            child: Obx(() => Column(children: controller.chatWidgets.value)),
          )),
          ChatWidgets.bottomTextField(controller),
        ],
      ),
    );
  }
}
