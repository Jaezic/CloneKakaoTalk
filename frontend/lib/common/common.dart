import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class Common extends GetxService {
  static const int serverport = 9998;
  static const String serverIP = "43.200.206.18";
  static const bool isDev = true;
  static Common get instance => Get.find<Common>();

  static double get getWidth => GetPlatform.isMobile ? Get.width : 500;

  static Logger logger = Logger(filter: MyFilter());

  Future<Common> init() async {
    Common.logger.d('$runtimeType init!');
    return this;
  }

  static SnackbarController showSnackBar(
      {required String messageText, Color textColor = Colors.white, Color backgroundColor = Colors.black87, dynamic position = SnackPosition.TOP}) {
    return Get.rawSnackbar(
      borderRadius: 8,
      snackPosition: position,
      margin: position == SnackPosition.BOTTOM ? const EdgeInsets.only(top: 16, left: 16, right: 16) : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      messageText: Text(
        messageText,
        style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: backgroundColor,
    );
  }

  static String timeDiffFromNow(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    int time = (dateTime.difference(DateTime.now()).inMinutes * -1);
    String displayTime = "";
    if (time >= 1440) {
      displayTime = "${(time / 1440).round().toString()}일 전";
    } else if (time >= 60) {
      displayTime = "${(time / 60).round().toString()}시간 전";
    } else {
      displayTime = "${time.toString()}분 전";
    }

    return displayTime;
  }

  static Container divider({EdgeInsetsGeometry? margin = EdgeInsets.zero, Color? color, double size = 0.6}) {
    return Container(
        margin: margin,
        child: Divider(
          thickness: size,
          height: size,
          color: color,
        ));
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return Common.isDev ? true : false;
  }
}
