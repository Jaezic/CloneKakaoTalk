import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/pages/imageview/image_view_page.dart';
import 'package:KakaoTalk/pages/profile/controller/profile_view_controller.dart';
import 'package:KakaoTalk/pages/profile_change/view/profile_change_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      body: GestureDetector(
        onTap: () => Get.toNamed(ImageViewPage.url, arguments: [
          controller.user.value!.profilebackgroundpath == null,
          controller.user.value!.profilebackgroundpath ?? "./assets/images/background.jpg"
        ]),
        child: Container(
          decoration: controller.user.value!.profilebackgroundpath == null
              ? const BoxDecoration(
                  color: Color.fromARGB(255, 135, 145, 152),
                )
              : BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(controller.user.value!.profilebackgroundpath!), // 배경 이미지
                  ),
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
                      if (controller.user.value!.id == AuthService.instance.user.value!.id)
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
                          child: Obx(() => controller.user.value!.profileimagepath == null
                              ? Container(
                                  decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("./assets/images/profile.jpg"))),
                                  height: 100,
                                  width: 100)
                              : GestureDetector(
                                  onTap: () => Get.toNamed(ImageViewPage.url, arguments: [
                                    controller.user.value!.profileimagepath == null,
                                    controller.user.value!.profileimagepath ?? "./assets/images/profile.jpg"
                                  ]),
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: ImageLoader(
                                      url: controller.user.value!.profileimagepath!,
                                      boxfit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ))),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        controller.user.value!.nickname!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        controller.user.value!.bio!,
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
                      (controller.user.value!.id! == AuthService.instance.user.value!.id)
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
                      if (controller.user.value!.id! != AuthService.instance.user.value!.id &&
                          !AuthService.instance.FriendIdList.contains(controller.user.value!.id!))
                        GestureDetector(
                          onTap: () async {
                            ApiResponse response = await ApiService.instance.addFriend(frinedId: controller.user.value!.id!);
                            if (response.result) {
                              Common.showSnackBar(messageText: "${controller.user.value!.nickname}와 친구가 되었습니다!");
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
      ),
    );
  }
}
