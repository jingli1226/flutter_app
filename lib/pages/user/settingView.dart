import 'package:flutter/material.dart';
import 'package:yigou/pages/user/loginView.dart';
import 'package:yigou/pages/user/withUs.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:yigou/tools/storage.dart';

class Setting extends StatefulWidget {
  const Setting({
    Key? key,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with AutomaticKeepAliveClientMixin {
  bool validate = false;
  bool mobileSearch = false;
  @override
  void initState() {
    getUser();
    queryData();
  }

  @override
  bool get wantKeepAlive => true;

  ///see AutomaticKeepAliveClientMixin

  void queryData() async {}

  void getUser() async {}
  void logout() {
    StorageUtil.clearUser();
    AppUtil.getTo(LoginViewPage());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: MyText("设置"),
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            margin: AppUtil.getCommonPadding(),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(height: 1, color: AppConfig.grayBgColor),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // AppUtil.getTo(const Punkte());
                      AppUtil.getTo(const WithUs());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText("关于我们"),
                          const Icon(Icons.navigate_next)
                        ],
                      ),
                    )),
                Container(height: 1, color: AppConfig.grayBgColor),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      logout();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText("切换账号"),
                          const Icon(Icons.navigate_next)
                        ],
                      ),
                    )),
                Container(height: 1, color: AppConfig.grayBgColor),
              ],
            ),
          ),
        ])));
  }
}
