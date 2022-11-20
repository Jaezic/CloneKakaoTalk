import 'package:KakaoTalk/pages/imageview/image_view_page.dart';
import 'package:KakaoTalk/pages/main/view/main_view_page.dart';
import 'package:KakaoTalk/pages/profile/view/profile_view_page.dart';
import 'package:KakaoTalk/pages/profile_change/view/profile_change_view_page.dart';
import 'package:KakaoTalk/pages/route/view/route_view_page.dart';
import 'package:KakaoTalk/pages/search/view/search_view_page.dart';
import 'package:KakaoTalk/pages/splash/view/splash_view_page.dart';
import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:KakaoTalk/pages/userRegister/page/userRegister_view_page.dart';
import 'package:get/get.dart';

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
    GetPage(
      name: RouteViewPage.url,
      page: () => const RouteViewPage(),
    ),
    GetPage(
      name: UserRegisterViewPage.url,
      page: () => const UserRegisterViewPage(),
    ),
    GetPage(
      name: ProfileViewPage.url,
      page: () => const ProfileViewPage(),
    ),
    GetPage(
      name: ProfileChangeViewPage.url,
      page: () => const ProfileChangeViewPage(),
    ),
    GetPage(
      name: SearchViewPage.url,
      page: () => const SearchViewPage(),
    ),
    GetPage(
      name: ImageViewPage.url,
      page: () => const ImageViewPage(),
    ),
  ];
}
