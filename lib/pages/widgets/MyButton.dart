import 'package:flutter/material.dart';
import 'package:yigou/tools/config.dart';

class MyButton extends StatelessWidget {
  final String? title;
  final int? color;
  double fontSize;
  Function? onTap;
  int? backgroundColor;
  TextAlign textAlign;
  bool gradient;
  double radius;
  double width;
  double height;
  FontWeight fontWeight;
  EdgeInsets margin;
  MyButton(this.title,
      {Key? key,
      this.color = 0xffffffff,
      this.gradient = true,
      this.backgroundColor = AppConfig.themeDeepColorInt,
      this.fontSize = 18,
      this.onTap,
      this.radius = 20,
      this.height = 40,
      this.width = 100,
      this.fontWeight = FontWeight.normal,
      this.margin = EdgeInsets.zero,
      this.textAlign = TextAlign.center})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
            margin: margin,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.red, //底色,阴影颜色
                            offset: Offset(2, 2), //阴影位置,从什么位置开始
                            blurRadius: 4, // 阴影模糊层度
                            spreadRadius: 0,
                          ) //阴影模糊大小
                        ],
                        gradient: gradient
                            ? LinearGradient(
                                //渐变位置
                                begin: Alignment.bottomLeft, //右上
                                end: Alignment.topRight, //左下
                                stops: const [
                                    0.0,
                                    1.0
                                  ], //[渐变起始点, 渐变结束点]
                                //渐变颜色[始点颜色, 结束颜色]
                                colors: [
                                    Color(backgroundColor!),
                                    Color(backgroundColor!)
                                  ])
                            : null),
                    child: Text(
                      title ?? "",
                      style: TextStyle(
                          color: Color(color!),
                          fontSize: fontSize,
                          fontWeight: fontWeight),
                    )))));
  }
}
