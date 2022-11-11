import 'package:KakaoTalk/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
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
