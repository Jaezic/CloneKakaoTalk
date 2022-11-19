import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/friend/controller/friend_view_controller.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
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
    // elevation: 1.0,
    actions: [
      GestureDetector(onTap: () {}, child: const Icon(Icons.search)),
      const SizedBox(
        width: 20,
      ),
      GestureDetector(
          onTap: () {
            FriendViewController.instance.showSettingDialog();
          },
          child: const Icon(LineIcons.cog)),
      const SizedBox(
        width: 10,
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendViewController(context));
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: GetPlatform.isMobile ? null : 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonButton(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    Get.toNamed(ProfileViewPage.url);
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: SizedBox(
                          height: 55,
                          width: 55,
                          child: Image.asset(
                            "./assets/images/profile.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        AuthService.instance.user.value!.nickname!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      Text(AuthService.instance.user.value!.bio!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                Common.divider(margin: const EdgeInsets.symmetric(vertical: 15)),
                Obx(() => Text(
                      '친구 ${controller.friendCnt}',
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    )),
                FriendTuple(),
                FriendTuple(),
                FriendTuple(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CommonButton FriendTuple() {
    return CommonButton(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 40,
                width: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              '정민규',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
