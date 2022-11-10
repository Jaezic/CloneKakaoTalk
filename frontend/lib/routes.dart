import 'package:get/get.dart';
import 'package:kakaotalk/pages/main/view/main_view_controller.dart';
import 'package:kakaotalk/pages/splash/view/splash_view_page.dart';
import 'package:kakaotalk/pages/userLogin/main/userlogin_view_page.dart';

class CustomRouter {
  static final routes = [
    GetPage(
      name: SplashViewPage.url,
      page: () => const SplashViewPage(),
    ),
    GetPage(
      name: UserLoginViewPage.url,
      page: () => const UserLoginViewPage(),
    ),
    GetPage(
      name: MainViewPage.url,
      page: () => const MainViewPage(),
    ),
  ];
}
