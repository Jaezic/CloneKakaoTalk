import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/profile/controller/profile_view_controller.dart';
import 'package:KakaoTalk/pages/profile_change/view/profile_change_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ProfileViewPage extends StatelessWidget {
  const ProfileViewPage({super.key});

  static const url = '/profile';
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewController());
    var arg = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 135, 145, 152)
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: AssetImage('assets/images/profile.jpg'), // 배경 이미지
            // ),
            ),
        width: GetPlatform.isMobile ? null : 500,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        LineIcons.times,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if ((arg['user'] as User).id! == AuthService.instance.user.value!.id)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(ProfileChangeViewPage.url);
                        },
                        child: const Icon(
                          Icons.settings,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("./assets/images/profile.jpg"))),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ((arg['user'] as User).id! == AuthService.instance.user.value!.id) ? AuthService.instance.user.value!.nickname! : arg['user'].nickname,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ((arg['user'] as User).id! == AuthService.instance.user.value!.id) ? AuthService.instance.user.value!.bio! : arg['user'].bio,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Common.divider(color: Colors.white54, size: 0.4),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ((arg['user'] as User).id! == AuthService.instance.user.value!.id)
                        ? Column(children: const [
                            Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "나와의 채팅",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ])
                        : Column(children: const [
                            Icon(
                              Icons.chat_bubble,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "1:1 채팅",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ]),
                    if ((arg['user'] as User).id! != AuthService.instance.user.value!.id)
                      GestureDetector(
                        onTap: () async {
                          ApiResponse response = await ApiService.instance.addFriend(frinedId: (arg['user'] as User).id!);
                          if (response.result) {
                            Common.showSnackBar(messageText: "${arg['user'].nickname}와 친구가 되었습니다!");
                          } else {
                            Common.showSnackBar(messageText: response.errorMsg);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Column(children: const [
                            Icon(
                              Icons.person_add_alt_1,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "친구 추가",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ]),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
