import 'dart:io';

import 'package:flutter/material.dart';

const AGORA_APP_ID = 'afee5a5da5244c8aa723c6788accb821';

// String DOMAIN = "http://127.0.0.1:8099/majiang_zxw";
// String SERVER = "127.0.0.1";

Color fontColor = const Color.fromARGB(255, 94, 61, 33);

// const String DOMAIN2 = "http://192.168.0.115:8112/social";

const String SERVER = "139.196.40.161";

Color themeBgColor = const Color(0xfff2da2a);

class AppConfig {
  static const Color font1 = Color(0xff333333);
  static const Color font2 = Color(0xff666666);
  static const Color font3 = Color(0xff999999);
  static const Color font4 = Color(0x44000000);
  static const int themeDeepColorInt = 0xff8779ff;
  static const int themeColorInt = 0xff6ae79a;

  static const Color themeDeepColor = Color(themeDeepColorInt);

  static const Color themeColor = Color(themeColorInt);

  static const double padding = 15;

  static const Color mainColor = Color.fromARGB(255, 134, 207, 183);
  static const int mainColorInt = 0xffA6E2CE;

  static const Color blue = Color(0xff6980ff);
  static double messageLatestHeight = Platform.isIOS ? 135 : 120;
  static const double bottomBarHeight = 49;
  static const double height = 90;

  static const String version = "1.0.0";
  static double actionChatHeight = 0;
  static String DOMAIN = "http://192.168.0.107:9102";
  static String DOMAIN_SocketIO = "";

  static const Color grayBgColor = Color(0xfff5f5f5);
  static Rect leftFigureRect = const Rect.fromLTWH(0.05, 0.1, 0.4, 0.4);
  static Rect rightFigureRect = const Rect.fromLTWH(0.55, 0.1, 0.4, 0.4);
  static Rect figureAreaDefaultRect = const Rect.fromLTWH(0, 0, 0, 0);

  static Rect getLeftFigureRect(double x, double y) {
    return Rect.fromLTWH(
        figureAreaDefaultRect.width * leftFigureRect.left + x,
        figureAreaDefaultRect.width * leftFigureRect.top + y,
        figureAreaDefaultRect.width * leftFigureRect.width,
        figureAreaDefaultRect.width * leftFigureRect.height);
  }

  static Rect getRightFigureRect(double x, double y) {
    return Rect.fromLTWH(
        figureAreaDefaultRect.width * rightFigureRect.left + x,
        figureAreaDefaultRect.width * rightFigureRect.top + y,
        figureAreaDefaultRect.width * rightFigureRect.width,
        figureAreaDefaultRect.width * rightFigureRect.height);
  }
}
