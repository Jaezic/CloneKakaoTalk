import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/main/view/main_view_page.dart';
import 'package:KakaoTalk/pages/route/controller/route_view_controller.dart';
import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:KakaoTalk/pages/userRegister/page/userRegister_view_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteViewPage extends StatelessWidget {
  const RouteViewPage({super.key});

  static const String url = '/route';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RouteViewController());
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CommonButton(
                title: UserLoginViewPage.url,
                onTap: () => Get.toNamed(UserLoginViewPage.url),
                color: Colors.black12,
              ),
              CommonButton(
                title: UserRegisterViewPage.url,
                onTap: () => Get.toNamed(UserRegisterViewPage.url),
                color: Colors.black12,
              ),
              CommonButton(
                title: MainViewPage.url,
                onTap: () => Get.offAllNamed(MainViewPage.url),
                color: Colors.black12,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
