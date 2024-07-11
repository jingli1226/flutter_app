import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yigou/base/pictureOverview.dart';
import 'package:yigou/pages/goods/GoodsDetail.dart';
import 'package:yigou/tools/AppUtil.dart';

class MyNetImage extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  const MyNetImage({Key? key, this.url = "", this.fit, this.width, this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppUtil.getTo(PictureOverview(
          image: url,
        ));
      },
      child: CachedNetworkImage(
        imageUrl:
            (url == null || url!.isEmpty) ? AppUtil.getRandomImage() : url,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
