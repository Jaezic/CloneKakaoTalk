import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/chat/view/chat_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListWidgets {
  static Widget chatListTuple() {
    return CommonButton(
      onTap: () {
        Get.toNamed(ChatViewPage.url);
      },
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 11, top: 11, left: 15, right: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 45,
                width: 45,
                child: Image.asset(
                  "./assets/images/profile.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '정민규',
                ),
                Text(
                  '채팅 내용입니다. 안녕하십니까?',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                )
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  '오후 3:15',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
