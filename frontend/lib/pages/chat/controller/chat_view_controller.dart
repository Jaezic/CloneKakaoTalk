import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/models/get_room_response.dart';
import 'package:KakaoTalk/pages/chat/controller/Chat.dart';
import 'package:KakaoTalk/pages/chat/view/chat_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ChatViewController extends GetxController {
  TextEditingController textEditController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxBool submitis = false.obs;
  Rxn<Room> room = Rxn();
  RxList<Widget> chatWidgets = RxList<Widget>();

  void updateRoom(String roomid) async {
    room.value = (await ApiService.instance.fetchRoom(roomId: roomid)).value!.room;
  }

  void submit() async {
    if (textEditController.text[0] == "0") {
      chatWidgets.add(ChatWidgets.otherChats(Chat(message: textEditController.text.substring(1), timestamp: "", userID: "", username: "정민규")));
    } else {
      chatWidgets.add(ChatWidgets.myChat(Chat(message: textEditController.text, timestamp: "", userID: "")));
    }
    update();

    //scrollController.jumpTo(scrollController.position.maxScrollExtent + 40 + Common.countnewline(textEditController.text) * 15);
    textEditController.clear();
    await Future.delayed(const Duration(milliseconds: 20));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  void onInit() async {
    // TODO: implement onInit

    textEditController.addListener(() {
      if (textEditController.text == "") {
        submitis.value = false;
      } else {
        submitis.value = true;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    textEditController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
