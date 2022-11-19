import 'package:KakaoTalk/pages/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashViewPage extends StatelessWidget {
  const SplashViewPage({super.key});

  static const String url = '/';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 224, 0),
      body: Center(
          child: Image.asset(
        'assets/images/icon.png',
        width: 100,
      )),
    );
  }
}
