import 'package:flutter/material.dart';
import 'package:yigou/tools/config.dart';

class Empty extends StatelessWidget {
  final String title;
  const Empty({Key? key, this.title = "暂时没有数据"}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.all(50),
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppConfig.font2),
            )
          ],
        ));
  }
}
