import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/friend/controller/friend_view_controller.dart';
import 'package:KakaoTalk/pages/profile/controller/profile_view_controller.dart';
import 'package:flutter/material.dart';

class FriendSettingDialog extends StatelessWidget {
  const FriendSettingDialog({super.key});

  static Widget button({required String title, void Function()? onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              onTap: onTap,
              color: Colors.white,
              title: title,
              textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: SizedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  button(
                    title: '친구 삭제',
                    onTap: () {
                      showDeleteDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Text(
              "친구 삭제",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text("이 친구를 목록에서 삭제하시겠습니까?"),
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
                  Navigator.pop(context);
                  await ApiService.instance.deleteFriend(id: ProfileViewController.instance.user.value!.id!);
                  var response = await ApiService.instance.getUserInfo(userId: ProfileViewController.instance.user.value!.id!);
                  ProfileViewController.instance.user.value = response.value!.user!;
                  await FriendViewController.instance.fetchFriendList();
                },
                child: const Text('네', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }
}
