import 'package:KakaoTalk/pages/chatList/controller/chatlist_view_controller.dart';
import 'package:KakaoTalk/pages/main/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainViewPage extends StatelessWidget {
  const MainViewPage({super.key});

  static const String url = "/main";

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController(context));
    final chatListController = Get.put(ChatListViewController());
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        appBar: controller.appBarContent[controller.pageIndex.value],
        backgroundColor: Colors.white,
        body: controller.bodyContent[controller.pageIndex.value],
        bottomNavigationBar: MainViewPage.homeNavigationBar(),
      );
    });
  }

  static Widget homeNavigationBar() {
    final controller = MainController.instance;
    return Material(
      child: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.2))),
        child: SafeArea(
          top: false,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  Expanded(child: _bottomNavigationButton(index: 0, icon: [Icons.account_circle_outlined, Icons.account_circle_rounded])),
                  Expanded(child: _bottomNavigationButton(index: 1, icon: [Icons.chat_outlined, Icons.chat])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _bottomNavigationButton({required int index, required List<IconData> icon}) {
    final controller = MainController.instance;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        controller.selectTab(index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Obx(() => Icon(icon[index == controller.pageIndex.value ? 1 : 0])),
      ),
    );
  }
}
