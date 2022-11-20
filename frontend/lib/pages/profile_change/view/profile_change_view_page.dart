import 'package:KakaoTalk/common/common.dart';
import 'package:KakaoTalk/common/widget/common_appbar.dart';
import 'package:KakaoTalk/common/widget/common_button.dart';
import 'package:KakaoTalk/pages/profile_change/controller/profile_change_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileChangeViewPage extends StatelessWidget {
  const ProfileChangeViewPage({super.key});

  static const url = '/profile_change';
  static TextStyle get _hintStyle => const TextStyle(color: Colors.black54, fontSize: 14);
  static TextStyle get _textStyle => const TextStyle(color: Colors.black, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileChangeController());
    const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        titleString: '프로필 수정',
        centerTitle: true,
        actions: [
          CommonButton(
            onTap: () {
              controller.updateProfile();
            },
            child: const Text('완료', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue)),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: Common.getWidth,
          child: Column(
            children: [
              Padding(
                padding: padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CommonButton(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                //controller.changeProfileImage();
                              },
                              child: Container(color: Colors.black, height: 80, width: 80),
                              // child: Obx(
                              //   () => null == null
                              //       ? Container(color: Colors.black, height: 80, width: 80)
                              //       : const SizedBox(
                              //           width: 80,
                              //           height: 80,
                              //           child: ImageLoader(
                              //             url: "",
                              //             boxfit: BoxFit.cover,
                              //             width: 80,
                              //             height: 80,
                              //           ),
                              //         ),
                              // ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //controller.changeProfileImage();
                          },
                          child: const Text('프로필 사진 바꾸기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 12)),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CommonButton(
                              padding: EdgeInsets.zero,
                              onTap: () {
                                controller.changeProfileImage();
                              },
                              child: Container(color: Colors.black, height: 80, width: 80),
                              // child: Obx(
                              //   () => null == null
                              //       ? Container(color: Colors.black, height: 80, width: 80)
                              //       : const SizedBox(
                              //           width: 80,
                              //           height: 80,
                              //           child: ImageLoader(
                              //             url: "",
                              //             boxfit: BoxFit.cover,
                              //             width: 80,
                              //             height: 80,
                              //           ),
                              //         ),
                              // ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //controller.changeProfileImage();
                          },
                          child: const Text('프로필 배경 바꾸기', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 12)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Common.divider(margin: const EdgeInsets.symmetric(vertical: 16)),
              Padding(
                padding: padding,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 100, child: Text('이름', style: _textStyle)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                style: _textStyle,
                                controller: controller.nameFieldController,
                                decoration: InputDecoration(
                                  hintStyle: _hintStyle,
                                  hintText: "이름",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                cursorColor: Colors.black38,
                              ),
                              Common.divider(margin: const EdgeInsets.symmetric(vertical: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 100, child: Text('소개', style: _textStyle)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                style: _textStyle,
                                controller: controller.bioFieldController,
                                decoration: InputDecoration(
                                  hintStyle: _hintStyle,
                                  hintText: "소개",
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                cursorColor: Colors.black38,
                              ),
                              Common.divider(margin: const EdgeInsets.symmetric(vertical: 16)),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
