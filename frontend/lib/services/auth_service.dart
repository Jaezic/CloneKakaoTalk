import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();
  Rxn<User> user = Rxn();

  Future<AuthService> init() async {
    Common.logger.d('$runtimeType init!');
    return this;
  }

  Future<void> logout() async {
    user.value!.clear();
  }
}
