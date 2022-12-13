import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:KakaoTalk/pages/chat/view/chat_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ChatViewPage extends StatelessWidget {
  const ChatViewPage({super.key});

  static const url = "/chat_view";
  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    final controller = Get.put(ChatViewController());
    controller.updateRoom(arg['roomid']);
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 175, 193, 207),
      endDrawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Obx(
                    () => controller.room.value == null
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.room.value!.title ?? '',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${controller.room.value!.users!.length}명 참여중',
                                style: const TextStyle(fontSize: 10),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Common.divider(color: Colors.black, size: 0.08),
                              ),
                              const Text('대화상대', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                            ],
                          ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 250, 250),
                border: Border(
                  top: BorderSide(width: 0.1, color: Colors.black),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    LineIcons.arrowLeft,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 174, 191, 208),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () {
            Get.back();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Obx(
            () => controller.room.value == null
                ? const CupertinoActivityIndicator()
                : Text(
                    controller.room.value!.title!,
                    style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(LineIcons.bars))
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: controller.scrollController,
            child: Obx(() => Column(children: controller.chatWidgets.value)),
          )),
          ChatWidgets.bottomTextField(controller)
        ],
      ),
    );
  }
}
