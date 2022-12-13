import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/Chat.dart';
import 'package:KakaoTalk/models/post_upload_response.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatWidgets {
  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 14);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 14);

  static Container bottomTextField(ChatViewController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.2)), color: Colors.white),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                ApiResponse<PostUploadResponse> response;
                FilePickerResult? userFile = await FilePicker.platform.pickFiles(withData: true);
                if (userFile == null) {
                  return;
                }
                response = await ApiService.instance.upload(name: userFile.names.first, path: userFile.paths.first!, bytes: userFile.files.first.bytes);
                String byte = "";
                if (response.value!.size! >= 1000) {
                  byte = "${(response.value!.size! / 1000).floor()} KB";
                } else {
                  byte = "${response.value!.size!} B";
                }
                ApiResponse<String> response2 = await ApiService.instance
                    .sendChat(roomId: controller.room.value!.roomId!, message: "@a(d|${response.value!.filename}|$byte|${response.value!.path}");
                controller.receiveAllChats(controller.room.value!.roomId!);
              },
              child: const Icon(
                CupertinoIcons.add,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(child: ChatWidgets.textField(getxcontroller: controller, hintText: "메시지 보내기.."))
          ],
        ),
      ),
    );
  }

  static Widget textField({required ChatViewController getxcontroller, required String hintText}) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: const Color.fromARGB(200, 248, 248, 248),
        border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: getxcontroller.textFieldFocusNode,
              textInputAction: TextInputAction.go,
              autofocus: true,
              controller: getxcontroller.textEditController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSubmitted: (value) => getxcontroller.submit(text: value),
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                hintStyle: _hintStyle,
              ),
              cursorColor: Colors.black38,
              style: _textStyle,
            ),
          ),
          Obx(() => getxcontroller.submitis.value
              ? GestureDetector(
                  onTap: () {
                    getxcontroller.submit();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 249, 229, 78),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1.0, color: Colors.black.withOpacity(0.05)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_upward,
                        size: 20,
                      ),
                    ),
                  ),
                )
              : const SizedBox())
        ],
      ),
    );
  }

  static Widget fileChat(Chat chat) {
    List<String> files = chat.message!.split('|');
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(Common.baseUrl + files[3]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 50,
            ),
            Text(
              Common.timeDiffFromNow(DateTime.tryParse(chat.createAt ?? '')),
              style: const TextStyle(color: Colors.black54, fontSize: 10),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.file_download_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            files[1] ?? "",
                            softWrap: true,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "용량 ${files[2] ?? ""}",
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget otherfileChat(Chat chat) {
    List<String> files = chat.message!.split('|');
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(Common.baseUrl + files[3]));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                margin: const EdgeInsets.only(right: 5, top: 3),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        Icons.file_download_outlined,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            files[1] ?? "",
                            softWrap: true,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "용량 ${files[2] ?? ""}",
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              Common.timeDiffFromNow(DateTime.tryParse(chat.createAt ?? '')),
              style: const TextStyle(color: Colors.black54, fontSize: 10),
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }

  static Widget myChat(Chat chat) {
    if (chat.message!.length >= 4) {
      if (chat.message!.substring(0, 4) == "@a(d" && chat.message!.split('|').length == 4) {
        print(chat.message!.substring(0, 4));
        return fileChat(chat);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 50,
          ),
          Text(
            Common.timeDiffFromNow(DateTime.tryParse(chat.createAt ?? '')),
            style: const TextStyle(color: Colors.black54, fontSize: 10),
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              margin: const EdgeInsets.only(left: 5),
              padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 249, 229, 78),
              ),
              child: Text(
                chat.message ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget otherChats(Chat chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            var response = await ApiService.instance.getUserInfo(userId: chat.userID!);
            if (response.result) {
              Get.toNamed(ProfileViewPage.url, arguments: {"user": response.value!.user});
            }
          },
          child: chat.profileimagepath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: ImageLoader(
                      url: chat.profileimagepath ?? "",
                      boxfit: BoxFit.cover,
                      width: 45,
                      height: 45,
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
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.username ?? "",
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
              (chat.message!.length >= 4)
                  ? (chat.message!.substring(0, 4) == "@a(d" && chat.message!.split('|').length == 4)
                      ? otherfileChat(chat)
                      : otherChat(chat)
                  : otherChat(chat),
            ],
          ),
        )
      ]),
    );
  }

  static Widget otherChat(Chat chat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(right: 5, top: 3),
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Text(
              chat.message ?? "",
              softWrap: true,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ),
        Text(
          Common.timeDiffFromNow(DateTime.tryParse(chat.createAt ?? '')),
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
        const SizedBox(
          width: 50,
        ),
      ],
    );
  }
}
