import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({super.key});

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
            width: GetPlatform.isMobile ? null : 500,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  button(
                    title: '로그아웃',
                    onTap: () {
                      AuthService.instance.logout();
                      Get.offAllNamed(UserLoginViewPage.url);
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
}
