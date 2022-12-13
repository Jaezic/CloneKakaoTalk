import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/userLogin/page/userlogin_view_page.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();
  String currentChatRoomid = "";
  Rxn<User> user = Rxn();
  RxList<String> FriendIdList = RxList();
  Future<AuthService> init() async {
    Common.logger.d('$runtimeType init!');
    return this;
  }

  Future<void> logout() async {
    user.value!.clear();
    Get.offAllNamed(UserLoginViewPage.url);
  }
}
