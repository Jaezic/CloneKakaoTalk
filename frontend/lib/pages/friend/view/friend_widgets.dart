import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:flutter/material.dart';

class FriendWidgets {
  static CommonButton FriendTuple({required User user, required Function() onTap}) {
    return CommonButton(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            user.profileimagepath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: ImageLoader(
                        url: user.profileimagepath!,
                        boxfit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset(
                        "./assets/images/profile.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 12,
            ),
            Text(
              user.nickname!,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Text(user.bio!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
