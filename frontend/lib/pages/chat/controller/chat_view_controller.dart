import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/get_chats_response.dart';
import 'package:KakaoTalk/models/get_room_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/chat/view/chat_view_page.dart';
import 'package:KakaoTalk/pages/chat/view/chat_widgets.dart';
import 'package:KakaoTalk/pages/chatList/controller/chatlist_view_controller.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController {
  TextEditingController textEditController = TextEditingController();
  // static ChatViewController get instance => Get.find<ChatViewController>();
  ScrollController scrollController = ScrollController();
  RxBool submitis = false.obs;
  Rxn<Room> room = Rxn();
  RxList<Widget> chatWidgets = RxList<Widget>();
  FocusNode textFieldFocusNode = FocusNode();
  RxList<Widget> userListWidgets = RxList<Widget>();
  RxList<User> userList = RxList<User>();
  RxList<User> addPossibleList = RxList<User>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void inviteMember(User newuser) async {
    ApiResponse<String> response = await ApiService.instance.invitePeople(roomId: room.value!.roomId!, id: newuser.id!);
    updateRoom(room.value!.roomId!);
    Get.back();
  }

  void createMultipleRoom(User newuser) async {
    List<String> userid = [];
    for (var user in room.value!.users!) {
      userid.add(user.id!);
    }
    userid.add(newuser.id!);
    ApiResponse<String> response = await ApiService.instance.createRoom(onetoone: 0, ids: userid);
    String roomid = response.value!;
    Get.back();
    Get.back();
    Get.back();
    Get.toNamed(ChatViewPage.url, arguments: {"roomid": roomid});
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  void updateRoom(String roomid) async {
    ApiResponse<GetRoomResponse> response = (await ApiService.instance.fetchRoom(roomId: roomid));
    if (!response.result) {
      Common.showSnackBar(messageText: response.errorMsg);
      Get.back();
      return;
    }
    room.value = response.value!.room;
    userListWidgets.value.clear();
    userList.value.clear();
    for (User user in room.value!.users!) {
      userList.add(user);
      userListWidgets.value.add(GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          var response = await ApiService.instance.getUserInfo(userId: user.id!);
          if (response.result) {
            Get.toNamed(ProfileViewPage.url, arguments: {"user": response.value!.user});
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              user.profileimagepath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: ImageLoader(
                          url: user.profileimagepath!,
                          boxfit: BoxFit.cover,
                          width: 35,
                          height: 35,
                        ),
                      ))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset(
                          "./assets/images/profile.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Text(
                user.nickname ?? "",
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ));
    }
    addPossibleList.value = [...AuthService.instance.FriendList.value];
    addPossibleList.removeWhere((user) {
      for (var element in userList.value) {
        if (element.id == user.id) return true;
      }
      return false;
    });
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
        chatWidgets.add(ChatWidgets.myChat(element));
      } else {
        chatWidgets.add(ChatWidgets.otherChats(element));
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
    if (message.isEmpty) return;
    textEditController.clear();
    ApiResponse<String> response = await ApiService.instance.sendChat(roomId: room.value!.roomId!, message: message);
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
    // for (var fuser in AuthService.instance.FriendList.value) {
    //   bool check = false;
    //   print(fuser.id);
    //   for (var user in ChatViewController.instance.userList.value) {
    //     if (user.id == fuser.id) check = true;
    //   }
    //   if (!check) {
    //     addpossibleList.value.add(fuser);
    //   }
    // }
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

  Future<void> showExitDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Text(
              "방 나가기",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  "이 채팅방에서 퇴장하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '아니요',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Get.back();
                  Get.back();
                  await ApiService.instance.ExitRoom(roomId: room.value!.roomId!);
                  ChatListViewController.instance.updateChatList();
                },
                child: const Text('네', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }
}
