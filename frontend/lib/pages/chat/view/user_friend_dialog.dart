import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFriendDialog extends StatelessWidget {
  final void Function(User? user) onUserAdded;
  final ChatViewController controller;
  const UserFriendDialog({super.key, required this.onUserAdded, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Material(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                // margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: const [
                          Icon(CupertinoIcons.person),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '새로운 인원을 선택하세요',
                            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      for (var index = 0; index < controller.addPossibleList.value.length; index++)
                        CommonButton(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          onTap: () => onUserAdded(controller.addPossibleList.value[index]),
                          child: Row(
                            children: [
                              controller.addPossibleList.value[index].profileimagepath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: ImageLoader(
                                          url: controller.addPossibleList.value[index].profileimagepath!,
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
                                controller.addPossibleList.value[index].nickname ?? "",
                                style: const TextStyle(color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
