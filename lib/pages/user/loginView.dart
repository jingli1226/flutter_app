import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/home.dart';
import 'package:yigou/pages/user/registerView.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:yigou/tools/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewPage extends StatefulWidget {
  const LoginViewPage({Key? key}) : super(key: key);

  @override
  _LoginViewPageState createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  final TextEditingController _phoneController =
      TextEditingController(text: "");
  final TextEditingController _passWordController =
      TextEditingController(text: "");
  final TextEditingController _vcodeController = TextEditingController();

  //表单状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _username = ''; // 用户名
  final _password = ''; // 验证码
  final _rightCode = '';
  int loginType = 0;

  final _isShowPwd = false; //是否显示验证码
  final _isShowClear = false; //是否显示输入框尾部的清除按钮
  bool _checkAgreement = false; //是否显示输入框尾部的清除按钮

  Timer? _timer;
  int seconds = 60;
  bool isWechatInstalled = false;
  bool passwordLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void _checkAgreementHandler(check) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkAgreement = check;
    });
  }

  void loginHandler() async {
    if (_phoneController.text.isEmpty) {
      EasyLoading.showInfo("手机号或者密码不能为空");
      return;
    }
    if (loginType == 0) {
      if (_passWordController.text.isEmpty) {
        EasyLoading.showInfo("手机号或者密码不能为空");
        return;
      }
    } else {
      if (_vcodeController.text.isEmpty) {
        EasyLoading.showInfo("手机号或者密码不能为空");
        return;
      }
    }

    if (!_checkAgreement) {
      EasyLoading.showInfo("请阅读并同意用户协议");
      return;
    }

    var res =
        await DBUtil.login(_phoneController.text, _passWordController.text);
    if (res == null) {
      EasyLoading.showError("用户名或者密码不正确");
    } else {
      EasyLoading.showSuccess("登录成功");
      await StorageUtil.saveUser(res);
      AppUtil.user = await StorageUtil.getUser();
      AppUtil.replace(HomePage());
    }
  }

  void registerHandler() {
    AppUtil.replace(RegisterViewPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          leading: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          toolbarHeight: 80,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light)),
      backgroundColor: AppConfig.themeDeepColor,
      body: Container(
          padding: AppUtil.getCommonPadding(),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 100),
                    MyText(
                      "校园二手交易市场",
                      textAlign: TextAlign.left,
                      color: Colors.white,
                      fontSize: 20,
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(height: 50),
                    Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(30),
                            //       color: const Color(0xffECECEC)),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       GestureDetector(
                            //           onTap: () {
                            //             setState(() {
                            //               loginType = 0;
                            //             });
                            //           },
                            //           child: Container(
                            //               padding: const EdgeInsets.fromLTRB(
                            //                   20, 10, 20, 10),
                            //               decoration: BoxDecoration(
                            //                   borderRadius: loginType == 0
                            //                       ? BorderRadius.circular(30)
                            //                       : null,
                            //                   color: loginType == 0
                            //                       ? const Color(0xff367b64)
                            //                       : null),
                            //               child: MyText(
                            //                 "密码登录",
                            //                 color: loginType == 0
                            //                     ? Colors.white
                            //                     : const Color(0xff888888),
                            //               ))),
                            //       GestureDetector(
                            //         onTap: () {
                            //           setState(() {
                            //             loginType = 1;
                            //           });
                            //         },
                            //         child: Container(
                            //             padding: const EdgeInsets.fromLTRB(
                            //                 20, 10, 20, 10),
                            //             decoration: BoxDecoration(
                            //                 borderRadius: loginType == 1
                            //                     ? BorderRadius.circular(30)
                            //                     : null,
                            //                 color: loginType == 1
                            //                     ? const Color(0xff888888)
                            //                     : null),
                            //             child: MyText(
                            //               "验证码登录",
                            //               color: loginType == 1
                            //                   ? Colors.white
                            //                   : const Color(0xff888888),
                            //             )),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            const SizedBox(height: 10),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: TextField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "请输入用户名",
                                        hintStyle: TextStyle(
                                            color: Color(0xff999999))),
                                  ))
                                ],
                              ),
                            ),
                            SizedBox(height: loginType == 0 ? 10 : 0),
                            loginType == 0
                                ? Container(
                                    height: 1, color: const Color(0xffeeeeee))
                                : Container(),
                            loginType == 0
                                ? Container(
                                    child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: TextField(
                                        controller: _passWordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "请输入密码",
                                            hintStyle: TextStyle(
                                                color: Color(0xff999999))),
                                      ))
                                    ],
                                  ))
                                : Container(),
                            const SizedBox(height: 10),
                            Container(
                                height: 1, color: const Color(0xffeeeeee)),

                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                loginHandler();
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color(0xff367b64)),
                                  child: MyText(
                                    "登录",
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                registerHandler();
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color(0xff367b64)),
                                  child: MyText(
                                    "注册",
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              _checkAgreement = !_checkAgreement;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: Image.asset(
                              !_checkAgreement
                                  ? "images/unchecked.png"
                                  : "images/checked.png",
                              width: 15,
                              height: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "我已阅读并同意",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        GestureDetector(
                          child: const Text("《平台协议》",
                              style: TextStyle(
                                  color: Color(0xffffffff), fontSize: 13)),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 20)
            ],
          )),
    );
  }
}
