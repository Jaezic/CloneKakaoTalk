import 'package:get/get.dart';
import 'package:kakaotalk/pages/route/view/route_view_page.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    3.delay(() => Get.offAllNamed(RouteViewPage.url));
    super.onReady();
  }
}
