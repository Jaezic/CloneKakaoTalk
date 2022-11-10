import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/widget/common_appbar.dart';

class MainController extends GetxController {
  MainController(this.context);
  BuildContext context;
  static MainController get instance => Get.find<MainController>();
  RxInt pageIndex = 0.obs;

  void selectTab(int index) {
    pageIndex.value = index;
    update();
  }

  // Future<void> showSettingDialog() {
  //   return showCupertinoModalPopup(
  //       barrierColor: Colors.black54,
  //       context: context,
  //       builder: (context) {
  //         return const SettingDialog();
  //       });
  // }

  final List<Widget> bodyContent = [];

  final List<CommonAppBar?> appBarContent = [
    null,
    // SearchViewPage.appBar,
    null,
    // UserLoginViewPage.appBar,
    null,
  ];
}
