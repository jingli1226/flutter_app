import 'package:flutter/material.dart';
import 'package:yigou/tools/config.dart';

class MyText extends StatelessWidget {
  final String? title;
  final Color? color;
  double fontSize;
  FontWeight weight;
  TextAlign textAlign;
  int? maxLines;
  MyText(this.title,
      {Key? key,
      this.color,
      this.maxLines,
      this.fontSize = 15,
      this.textAlign = TextAlign.center,
      this.weight = FontWeight.normal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(
      title ?? "",
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: fontSize,
          color: color ?? AppConfig.font1,
          fontWeight: weight),
    );
  }
}
