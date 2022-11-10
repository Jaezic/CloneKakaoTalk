import 'package:get/get.dart';
import 'package:kakaotalk/splash/view/splash_view_page.dart';

class CustomRouter {
  static final routes = [
    GetPage(
      name: SplashViewPage.url,
      page: () => const SplashViewPage(),
    ),
  ];
}
