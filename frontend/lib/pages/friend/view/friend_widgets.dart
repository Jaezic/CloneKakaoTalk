import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/common/widget/image_loader.dart';
import 'package:KakaoTalk/models/post_user_login_response.dart';
import 'package:KakaoTalk/pages/friend/controller/friend_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FriendWidgets {
  static Container friendBanner(FriendViewController controller) {
    return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: const Color.fromARGB(255, 243, 243, 243)),
        child: Center(
          child: Obx(() {
            const color2 = Color.fromARGB(255, 77, 77, 77);
            return controller.weather.value != null
                ? Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text('가천대학교', style: TextStyle(fontSize: 17, color: color2)),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                CupertinoIcons.location_fill,
                                color: color2,
                                size: 12,
                              )
                            ],
                          ),
                          Text(
                            controller.weather.value!.weatherinfo['오늘온도'] + '°',
                            style: const TextStyle(fontSize: 28, color: color2),
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            controller.weather.value!.weatherinfo['시간대'] == "밤" ? CupertinoIcons.moon_fill : CupertinoIcons.brightness_solid,
                            color: color2,
                            size: 15,
                          ),
                          Text(
                            '${controller.weather.value!.weatherinfo['하늘형태']}\n${controller.weather.value!.weatherinfo['풍속']}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 10, color: color2),
                          ),
                          Text(
                            '습도:${controller.weather.value!.weatherinfo['습도']}% 강수확률:${controller.weather.value!.weatherinfo['강수확률']}%',
                            style: const TextStyle(fontSize: 10, color: color2),
                          )
                        ],
                      )
                    ],
                  )
                : const Text('날씨 정보를 불러오는 중 입니다...', style: TextStyle(color: color2, fontWeight: FontWeight.bold));
          }),
        ));
  }

  static CommonButton FriendTuple({required User user, required Function() onTap}) {
    print(user.isonline);
    return CommonButton(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Stack(children: [
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
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Stack(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                      ),
                      Positioned(
                          top: 3,
                          left: 3,
                          child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(color: user.isonline! ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(30))))
                    ],
                  ))
            ]),
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
