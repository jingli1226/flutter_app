import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/generated/l10n.dart';
import 'package:yigou/pages/home.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/route_manager.dart';
import 'common/color.dart';

void main() {
  runApp(const MyApp());
  // registerWxApi(
  //     appId: AppConfig.WXAppId, universalLink: AppConfig.UniversalLink);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //这里替换你选择的颜色
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Colors.tealAccent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final easyload = EasyLoading.init();

    return GetMaterialApp(
        title: '校园二手交易平台',
        builder: (BuildContext context, Widget? child) {
          return easyload(context, child);
        },
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: createMaterialColor(AppConfig.mainColor),
            primaryColor: AppConfig.mainColor,
            textTheme:
                const TextTheme(button: TextStyle(color: Colors.black12)),
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                    color: Color.fromARGB(255, 65, 57, 57), fontSize: 20.0),
                color: Colors.white)),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale('zh'));
  }
}
