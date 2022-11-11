import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/widget/common_button.dart';
import 'package:kakaotalk/pages/userLogin/controller/userlogin_view_controller.dart';
import 'package:kakaotalk/pages/userRegister/page/userRegister_view_page.dart';

class UserLoginViewPage extends StatelessWidget {
  const UserLoginViewPage({super.key});

  static const String url = '/user_login';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserLoginViewController());
    return Scaffold(
        body: Center(
      child: SizedBox(
        width: GetPlatform.isMobile ? null : 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Kakao',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 40,
              ),
              UserLoginViewController.textField(
                textEditController: controller.idFieldController,
                hintText: '아이디',
              ),
              const SizedBox(
                height: 20,
              ),
              UserLoginViewController.textField(
                textEditController: controller.passFieldController,
                hintText: '비밀번호',
              ),
              const SizedBox(
                height: 45,
              ),
              CommonButton(
                  padding: EdgeInsets.zero,
                  onTap: () {},
                  child: Container(
                      width: GetPlatform.isMobile ? null : 460,
                      height: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5), color: const Color.fromARGB(255, 254, 229, 0)),
                      child: const Center(
                          child: Text(
                        '로그인',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )))),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(UserRegisterViewPage.url),
                    child: const Text(
                      '회원가입',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
