import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/user/loginView.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterViewPage extends StatefulWidget {
  const RegisterViewPage({Key? key}) : super(key: key);

  @override
  _RegisterViewPageState createState() => _RegisterViewPageState();
}

class _RegisterViewPageState extends State<RegisterViewPage> {
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

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

    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
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

  // 监听焦点
  Future<void> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      // 取消验证码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  void sendCodeHandler() {
    if (_phoneController.text.isEmpty) {
      EasyLoading.showToast("请输入手机号");
      return;
    }

    if (seconds != 60) {
      return;
    }
    setState(() {
      seconds--;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (seconds < 1) {
          timer.cancel();
          setState(() {
            seconds = 60;
          });
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  void submit() {
    if (_phoneController.text.isEmpty) {
      EasyLoading.showToast("用户名不能为空");
      return;
    }

    if (_nicknameController.text.isEmpty) {
      EasyLoading.showToast("昵称不能为空");
      return;
    }
    if (_passWordController.text.isEmpty) {
      EasyLoading.showToast("密码不能为空");
      return;
    }
    if (_cpasswordController.text != _passWordController.text) {
      EasyLoading.showToast("二次密码不能为空");
      return;
    }

    if (!_checkAgreement) {
      EasyLoading.showToast("请阅读并同意用户协议");
      return;
    }
    var res = DBUtil.register({
      "id": DateTime.now().millisecondsSinceEpoch % 10000,
      "username": _phoneController.text,
      "name": _nicknameController.text,
      "password": _passWordController.text,
      "birthday": "2002-10-23",
      "type": 0,
    }).then((value) {
      EasyLoading.showSuccess("注册成功");
      AppUtil.getTo(LoginViewPage());
    }).catchError((e) {});
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
                            //     width: 100,
                            //     padding: const EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //         borderRadius: loginType == 0
                            //             ? BorderRadius.circular(30)
                            //             : null,
                            //         color: loginType == 0
                            //             ? const Color(0xffF42648)
                            //             : null),
                            //     child: MyText(
                            //       "注册",
                            //       color: loginType == 0
                            //           ? Colors.white
                            //           : const Color(0xff888888),
                            //     )),
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
                            const SizedBox(height: 10),

                            Container(
                                height: 1, color: const Color(0xffeeeeee)),
                            const SizedBox(height: 10),
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _nicknameController,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请输入昵称",
                                      hintStyle:
                                          TextStyle(color: Color(0xff999999))),
                                ))
                              ],
                            )),
                            const SizedBox(height: 10),
                            Container(
                                height: 1, color: const Color(0xffeeeeee)),
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _passWordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请输入密码",
                                      hintStyle:
                                          TextStyle(color: Color(0xff999999))),
                                ))
                              ],
                            )),
                            const SizedBox(height: 10),
                            Container(
                                height: 1, color: const Color(0xffeeeeee)),
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _cpasswordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请再次输入密码",
                                      hintStyle:
                                          TextStyle(color: Color(0xff999999))),
                                ))
                              ],
                            )),
                            Container(
                                height: 1, color: const Color(0xffeeeeee)),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                submit();
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: loginType == 0
                                          ? BorderRadius.circular(30)
                                          : null,
                                      color: loginType == 0
                                          ? const Color(0xff000000)
                                          : null),
                                  child: MyText(
                                    "注册",
                                    color: loginType == 0
                                        ? Colors.white
                                        : const Color(0xff888888),
                                  )),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      AppUtil.getTo(LoginViewPage());
                                    },
                                    child: MyText(
                                      "已有账号？立即登录",
                                      color: const Color(0xff888888),
                                    )),
                              ],
                            )
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
                          child: Image.asset(
                            !_checkAgreement
                                ? "images/unchecked.png"
                                : "images/checked.png",
                            width: 15,
                            height: 15,
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
                        const Text(
                          "和",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        GestureDetector(
                          child: const Text(
                            "《隐私政策》",
                            style: TextStyle(
                                color: Color(0xffffffff), fontSize: 13),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          )),
    );
  }
}
