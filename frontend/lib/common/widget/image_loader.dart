import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.loadingWidth,
    this.loadingHeight,
    this.boxfit = BoxFit.contain,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final double? loadingWidth;
  final double? loadingHeight;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    if (url == "" || url == "https://asset.loading_background.png") {
      return SizedBox(width: width, height: height);
    } else {
      return Align(
        alignment: Alignment.center,
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          alignment: Alignment.center,
          fit: boxfit,
          placeholder: (context, url) => SizedBox(
            width: width,
            height: height,
            child: Shimmer.fromColors(
              baseColor: Colors.black.withOpacity(0.06),
              highlightColor: Colors.black12,
              child: Container(
                width: width,
                height: height,
                color: Colors.white,
              ),
            ),
          ),
          // imageBuilder: (context, imageProvider) => Container(
          //       width: width,
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.grey),
          //         borderRadius: const BorderRadius.all(Radius.circular(16)),
          //         image: DecorationImage(image: imageProvider),
          //       ),
          //     ),
          // errorWidget: (context, url, error) => Image.asset("assets/images/errimg.jpg", width: width, height: height, fit: BoxFit.fill)),
          errorWidget: (context, url, error) => Container(
            width: width,
            height: height,
            color: Colors.grey,
          ),
        ),
      );
    }
  }
}
