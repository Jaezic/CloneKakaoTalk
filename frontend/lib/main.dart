import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() async {
  await Get.putAsync(() => Common().init());
  await initServices();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        fontFamily: 'NotoSansKR',
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(primary: Colors.white),
        appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.black))),
    getPages: CustomRouter.routes,
    themeMode: ThemeMode.light,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ko', ''),
    ],
  ));
}

Future<void> initServices() async {
  await Get.putAsync(() => ApiService().init());
}
