import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakaotalk/common/common.dart';
import 'package:kakaotalk/common/widget/common_appbar.dart';
import 'package:kakaotalk/common/widget/common_button.dart';
import 'package:kakaotalk/pages/friend/controller/friend_view_controller.dart';
import 'package:line_icons/line_icons.dart';

class FriendViewPage extends StatelessWidget {
  const FriendViewPage({super.key});

  static const url = '/friend';
  static CommonAppBar appBar = CommonAppBar(
    titleString: '친구',
    fontSize: 25,
    fontWeight: FontWeight.bold,
    centerTitle: false,
    // elevation: 1.0,
    actions: const [
      Icon(Icons.search),
      SizedBox(
        width: 20,
      ),
      Icon(LineIcons.cog),
      SizedBox(
        width: 10,
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendViewController());
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: GetPlatform.isMobile ? null : 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonButton(
                  padding: EdgeInsets.zero,
                  onTap: () {},
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: Container(
                          height: 55,
                          width: 55,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        '정민규',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
                Common.divider(margin: const EdgeInsets.symmetric(vertical: 15)),
                const Text(
                  '친구 3',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                FriendTuple(),
                FriendTuple(),
                FriendTuple(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CommonButton FriendTuple() {
    return CommonButton(
      padding: EdgeInsets.zero,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 40,
                width: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              '정민규',
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
