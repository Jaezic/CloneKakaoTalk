import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    // 3.delay(() => Get.offAllNamed(RouteViewPage.url));
    3.delay(() => Get.offAllNamed(UserLoginViewPage.url));
    super.onReady();
  }
}
