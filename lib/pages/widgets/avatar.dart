import 'package:flutter/material.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/tools/config.dart';

class Avatar extends StatelessWidget {
  String? url;
  Avatar(this.url, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (url != null && url!.isNotEmpty && !url!.startsWith("http")) {
      return MyNetImage(
        url: AppConfig.DOMAIN + url!,
      );
    }
    return url == null || url!.isEmpty
        ? Image.network(
            "https://img2.baidu.com/it/u=3959851551,53095557&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500",
            fit: BoxFit.cover,
          )
        : MyNetImage(
            url: url!,
            fit: BoxFit.cover,
          );
  }
}
