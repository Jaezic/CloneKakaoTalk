import 'package:get/get.dart';
import 'package:kakaotalk/pages/userLogin/main/userlogin_view_page.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    3.delay(() => Get.offAllNamed(UserLoginViewPage.url));
    super.onReady();
  }
}
