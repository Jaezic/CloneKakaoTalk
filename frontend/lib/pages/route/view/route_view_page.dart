import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/widget/common_button.dart';
import 'package:kakaotalk/pages/main/view/main_view_page.dart';
import 'package:kakaotalk/pages/route/controller/route_view_controller.dart';
import 'package:kakaotalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:kakaotalk/pages/userRegister/page/userRegister_view_page.dart';

class RouteViewPage extends StatelessWidget {
  const RouteViewPage({super.key});

  static const String url = '/route';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RouteViewController());
    return Scaffold(
        body: Center(
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
    ));
  }
}
