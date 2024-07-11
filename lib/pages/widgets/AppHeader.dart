import 'package:flutter/material.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';

class AppHeader extends StatelessWidget {
  final Widget? title;
  final bool? back;
  final List<Widget>? actions;
  final double? height;
  final Color? color;
  const AppHeader(
      {Key? key,
      this.title,
      this.back = true,
      this.actions,
      this.height,
      this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: height ?? AppConfig.height,
        width: double.infinity,
        color: color,
        padding: EdgeInsets.fromLTRB(AppUtil.getPadding(),
            MediaQuery.of(context).padding.top + 10, AppUtil.getPadding(), 10),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 40, right: 50),
              child: title,
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  back!
                      ? GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                          ),
                        )
                      : Container(),
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 20,
                  ),
                  actions != null
                      ? Row(
                          children: actions as List<Widget>,
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ));
  }
}
