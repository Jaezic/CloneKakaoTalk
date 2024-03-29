import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/get_room_response.dart';
import 'package:KakaoTalk/pages/chat/view/chat_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListWidgets {
  static Widget chatListTuple({required Room room}) {
    return CommonButton(
      onTap: () {
        Get.toNamed(ChatViewPage.url, arguments: {"roomid": room.roomId});
      },
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 11, top: 11, left: 15, right: 15),
        child: Row(
          children: [
            room.users![0].profileimagepath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: ImageLoader(
                        url: room.users![0].profileimagepath!,
                        boxfit: BoxFit.cover,
                        width: 45,
                        height: 45,
                      ),
                    ))
                : ClipRRect(
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
              children: [
                Row(
                  children: [
                    Text(
                      room.title!.length > 15 ? '${room.title!.substring(0, 16)}···' : room.title!,
                    ),
                    if (room.onetoone == 0)
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${room.users!.length + 1}',
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          )
                        ],
                      )
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  (room.latest_message ?? "") == ""
                      ? "[최근 대화 기록이 없습니다.]"
                      : (room.latest_message!.length >= 4)
                          ? (room.latest_message!.substring(0, 4) == "@a(d" && room.latest_message!.split('|').length == 4)
                              ? "[파일이 전송되었습니다.]"
                              : room.latest_message!
                          : room.latest_message!,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                )
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  Common.timeDiffFromNow(DateTime.tryParse(room.updateAt ?? '')),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(
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
