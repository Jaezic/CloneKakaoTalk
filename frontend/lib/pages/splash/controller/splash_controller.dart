import 'package:KakaoTalk/common/api_service.dart';
import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/service_response.dart';
import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    // 3.delay(() => Get.offAllNamed(RouteViewPage.url));
    ApiResponse<String> response = await ApiService.instance.checkServer();
    await 3.delay();
    if (response.result) {
      Get.offAllNamed(UserLoginViewPage.url);
    } else {
      Common.showSnackBar(messageText: response.errorMsg);
      onReady();
    }
    super.onReady();
  }
}
