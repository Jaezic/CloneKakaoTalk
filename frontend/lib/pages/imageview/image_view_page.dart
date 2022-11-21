import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({super.key});

  static const url = '/image_view';
  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            arg[0] == true
                ? PhotoView(
                    imageProvider: AssetImage(arg[1]), // 배경 이미지
                  )
                : PhotoView(
                    maxScale: PhotoViewComputedScale.contained, minScale: PhotoViewComputedScale.contained, imageProvider: CachedNetworkImageProvider(arg[1])),
            SafeArea(
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        LineIcons.times,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
