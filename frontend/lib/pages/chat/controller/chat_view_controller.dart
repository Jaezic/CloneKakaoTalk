import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/Chat.dart';
import 'package:KakaoTalk/models/get_chat_response.dart';
import 'package:KakaoTalk/models/get_chats_response.dart';
import 'package:KakaoTalk/models/get_room_response.dart';
import 'package:KakaoTalk/pages/chat/view/chat_widgets.dart';
import 'package:KakaoTalk/pages/chatList/controller/chatlist_view_controller.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController {
  TextEditingController textEditController = TextEditingController();
  static ChatViewController get instance => Get.find<ChatViewController>();
  ScrollController scrollController = ScrollController();
  RxBool submitis = false.obs;
  Rxn<Room> room = Rxn();
  RxList<Widget> chatWidgets = RxList<Widget>();
  FocusNode textFieldFocusNode = FocusNode();
  void updateRoom(String roomid) async {
    ApiResponse<GetRoomResponse> response = (await ApiService.instance.fetchRoom(roomId: roomid));
    if (!response.result) {
      Common.showSnackBar(messageText: response.errorMsg);
      Get.back();
      return;
    }
    room.value = response.value!.room;
    AuthService.instance.currentChatRoomid = room.value!.roomId!;
    receiveAllChats(roomid);
  }

  void receiveAllChats(String roomid) async {
    ApiResponse<GetChatsResponse> response2 = await ApiService.instance.receivePostChat(roomId: roomid);
    if (!response2.result) {
      // Get.back();
      // Common.showSnackBar(messageText: response2.errorMsg);
      return;
    }
    chatWidgets.clear();
    response2.value?.chats?.sort(((a, b) {
      return DateTime.parse(a.createAt!).difference(DateTime.parse(b.createAt!)).inSeconds;
    }));
    for (var element in response2.value!.chats!) {
      if (element.userID == AuthService.instance.user.value!.id) {
        chatWidgets.add(ChatWidgets.myChat(Chat(message: element.message, createAt: element.createAt, userID: element.userID, username: element.username)));
      } else {
        chatWidgets.add(ChatWidgets.otherChats(Chat(message: element.message, createAt: element.createAt, userID: element.userID, username: element.username)));
      }
    }
    update();
    await Future.delayed(const Duration(milliseconds: 20));
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void submit({String? text}) async {
    if (room.value == null) return;
    String message = textEditController.text;
    textFieldFocusNode.requestFocus();
    if (text != null) message = text.substring(0, text.length - 1);
    textEditController.clear();
    ApiResponse<GetChatResponse> response = await ApiService.instance.sendChat(roomId: room.value!.roomId!, message: message);
    if (!response.result) {
      Common.showSnackBar(messageText: response.errorMsg);
      return;
    }
    receiveAllChats(room.value!.roomId!);
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
    textFieldFocusNode.dispose();
    ChatListViewController.instance.updateChatList();
    AuthService.instance.currentChatRoomid = "";
    super.onClose();
  }
}
