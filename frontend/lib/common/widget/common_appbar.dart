import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/common.dart';
import 'package:kakaotalk/common/widget/common_button.dart';

class CommonAppBar extends AppBar {
  CommonAppBar(
      {super.key,
      String? titleString,
      Widget? title,
      super.actions,
      String? fontFamily,
      FontWeight? fontWeight = FontWeight.bold,
      double? fontSize = 16,
      super.centerTitle = true,
      super.automaticallyImplyLeading = true,
      PreferredSizeWidget? bottom,
      Widget? leading,
      super.elevation = 0.0})
      : super(
          title: titleString != null
              ? Text(
                  titleString,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontFamily: fontFamily,
                    color: Colors.black,
                  ),
                )
              : title,
          leading: leading ??
              (Get.currentRoute != '/main'
                  ? CommonButton(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                    )
                  : null),
          bottom: bottom ??
              PreferredSize(
                preferredSize: Size(Get.width, 0.6),
                child: Common.divider(),
              ),
        );
}
