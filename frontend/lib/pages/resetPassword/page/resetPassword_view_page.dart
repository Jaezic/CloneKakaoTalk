import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/resetPassword/controller/resetPassword_view_controller.dart';
import 'package:KakaoTalk/pages/userRegister/controller/userRegister_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordViewPage extends StatelessWidget {
  const ResetPasswordViewPage({super.key});

  static const url = '/reset_password';
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordViewController());
    const namefieldstyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: GetPlatform.isMobile ? null : 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '찾고자 하는 계정의 정보를 입력해주세요',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      '카카오계정 아이디',
                      style: namefieldstyle,
                    ),
                    UserRegisterViewController.textField(textEditController: controller.idFieldController, hintText: '아이디'),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      '이름',
                      style: namefieldstyle,
                    ),
                    UserRegisterViewController.textField(textEditController: controller.nameFieldController, hintText: '이름'),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      '생일',
                      style: namefieldstyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.black.withOpacity(0.02),
                          border: Border.all(width: 0.6, color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Obx(() => CommonButton(
                                    onTap: () {
                                      controller.openBirthDayPickerPopup(context: context);
                                    },
                                    title: controller.birthday.value == null ? "생일 정보를 입력해주세요." : controller.birthdayString.value,
                                    textStyle: controller.birthday.value == null ? namefieldstyle : namefieldstyle,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CommonButton(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          controller.findPassword();
                        },
                        child: Container(
                            width: GetPlatform.isMobile ? null : 460,
                            height: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5), color: const Color.fromARGB(255, 254, 229, 0)),
                            child: const Center(
                                child: Text(
                              '확인',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )))),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonButton(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            width: GetPlatform.isMobile ? null : 460,
                            height: 50,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.5), color: const Color.fromARGB(255, 241, 241, 241)),
                            child: const Center(
                                child: Text(
                              '취소',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
