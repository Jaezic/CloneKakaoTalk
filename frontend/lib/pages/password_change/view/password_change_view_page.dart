import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/password_change/controller/passwrod_change_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordChangeViewPage extends StatelessWidget {
  const PasswordChangeViewPage({super.key});

  static const url = '/password_change';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordChangeViewController());
    return Scaffold(
      appBar: CommonAppBar(
        titleString: "비밀번호 변경",
        centerTitle: true,
        actions: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Obx(() => CommonButton(
                    splashColor: Colors.transparent,
                    onTap: () {
                      controller.passwordChange();
                    },
                    title: '저장',
                    textStyle: TextStyle(fontWeight: FontWeight.bold, color: controller.check.value == true ? Colors.lightBlue : Colors.grey),
                  )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                "비밀번호는 6자 이상이어야 하고 숫자, 영문, 특수기호(!\$@%%)의 조합을 포함해야 합니다.",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              controller.textField(index: 0, hintText: "현재 비밀번호"),
              controller.textField(index: 1, hintText: "새 비밀번호"),
              controller.textField(index: 2, hintText: "새 비밀번호 다시 입력")
            ],
          ),
        ),
      ),
    );
  }
}
