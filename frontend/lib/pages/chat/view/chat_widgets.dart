import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/models/Chat.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          children: [Expanded(child: ChatWidgets.textField(getxcontroller: controller, hintText: "메시지 보내기.."))],
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

  static Widget myChat(Chat chat) {
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
                chat.message!,
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
        ClipRRect(
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
          width: 6,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.username!,
                style: const TextStyle(color: Colors.black54, fontSize: 10),
              ),
              otherChat(chat),
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
              chat.message!,
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
