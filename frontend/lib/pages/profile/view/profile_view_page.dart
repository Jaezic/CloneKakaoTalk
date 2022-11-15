import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/pages/profile/controller/profile_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class ProfileViewPage extends StatelessWidget {
  const ProfileViewPage({super.key});

  static const url = '/profile';
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileViewController());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 135, 145, 152)
                // image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: AssetImage('assets/images/profile.jpg'), // 배경 이미지
                // ),
                ),
            width: GetPlatform.isMobile ? null : 500,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      child: Icon(
                        LineIcons.times,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("./assets/images/profile.jpg"))),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '정민규',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Common.divider(color: Colors.white54, size: 0.4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: const [
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
                      ])
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
