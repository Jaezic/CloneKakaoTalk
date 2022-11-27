import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/pages/friend/controller/friend_view_controller.dart';
import 'package:KakaoTalk/pages/friend/view/friend_widgets.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:KakaoTalk/pages/search/view/search_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class FriendViewPage extends StatelessWidget {
  const FriendViewPage({super.key});

  static const url = '/friend';
  static CommonAppBar appBar = CommonAppBar(
    titleString: '친구',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    centerTitle: false,
    elevation: 0.0,
    actions: [
      GestureDetector(
          onTap: () {
            Get.toNamed(SearchViewPage.url);
          },
          child: const Icon(Icons.search)),
      const SizedBox(
        width: 20,
      ),
      Builder(
        builder: (BuildContext context) {
          return GestureDetector(
              onTap: () {
                FriendViewController.instance.showSettingDialog(context);
              },
              child: const Icon(LineIcons.cog));
        },
      ),
      const SizedBox(
        width: 10,
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendViewController());
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: GetPlatform.isMobile ? null : 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FriendWidgets.friendBanner(controller),
                CommonButton(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    Get.toNamed(ProfileViewPage.url, arguments: {"user": AuthService.instance.user.value});
                  },
                  child: Obx(
                    () => Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(23),
                            child: Obx(() => AuthService.instance.user.value!.profileimagepath == null
                                ? Container(
                                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("./assets/images/profile.jpg"))),
                                    height: 55,
                                    width: 55)
                                : SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: ImageLoader(
                                      url: AuthService.instance.user.value!.profileimagepath!,
                                      boxfit: BoxFit.cover,
                                      width: 55,
                                      height: 55,
                                    ),
                                  ))),
                        const SizedBox(
                          width: 11,
                        ),
                        Text(
                          AuthService.instance.user.value!.nickname!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        const Spacer(),
                        Text(AuthService.instance.user.value!.bio!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                ),
                Common.divider(margin: const EdgeInsets.symmetric(vertical: 15)),
                Obx(() => Text(
                      '친구 ${controller.friendCnt}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    )),
                Obx(
                  () => Column(
                    children: controller.friendWidgetList.value,
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
