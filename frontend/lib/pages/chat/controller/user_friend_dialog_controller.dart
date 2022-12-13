import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/chat/controller/chat_view_controller.dart';
import 'package:KakaoTalk/services/auth_service.dart';
import 'package:get/get.dart';

class UserFriendDialogController extends GetxController {
  RxList<User> addpossibleList = RxList<User>();
  @override
  void onInit() {
    // TODO: implement onInit
    for (var fuser in AuthService.instance.FriendList.value) {
      bool check = false;
      for (var user in ChatViewController.instance.userList.value) {
        if (user.id == fuser.id) check = true;
      }
      if (!check) {
        addpossibleList.value.add(fuser);
      }
    }
    update();
    super.onInit();
  }
}
