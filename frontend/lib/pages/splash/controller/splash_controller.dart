import 'package:KakaoTalk/pages/route/view/route_view_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    3.delay(() => Get.offAllNamed(RouteViewPage.url));
    super.onReady();
  }
}
