import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/get_rooms_response.dart';
import 'package:KakaoTalk/pages/chatList/view/chatlist_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListViewController extends GetxController {
  static ChatListViewController get instance => Get.find<ChatListViewController>();
  RxList<Widget> chatWidgetList = RxList();
  void updateChatList() async {
    ApiResponse<GetRoomsResponse> response = await ApiService.instance.fetchRooms();
    chatWidgetList.clear();
    if (response.result) {
      response.value?.datas?.sort(((a, b) {
        return DateTime.parse(b.updateAt!).difference(DateTime.parse(a.updateAt!)).inSeconds;
      }));
      for (var element in response.value!.datas!) {
        chatWidgetList.add(ChatListWidgets.chatListTuple(
          room: element,
        ));
      }
    }
    update();
  }
}
