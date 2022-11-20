import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:get/get.dart';

class ProfileViewController extends GetxController {
  Rxn<User> user = Rxn();
  @override
  void onInit() {
    var arg = Get.arguments;
    if ((arg['user'] as User).id! == AuthService.instance.user.value!.id) {
      user = AuthService.instance.user;
    } else {
      user.value = arg['user'];
    }
    super.onInit();
  }
}
