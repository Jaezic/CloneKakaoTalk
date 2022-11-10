import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/pages/userLogin/controller/userlogin_view_controller.dart';

class UserLoginViewPage extends StatelessWidget {
  const UserLoginViewPage({super.key});

  static const String url = '/user_login';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserLoginViewController());
    return const Scaffold(body: Text('login'));
  }
}
