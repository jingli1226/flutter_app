import 'package:flutter/material.dart';
import 'package:yigou/generated/l10n.dart';
import 'package:yigou/pages/tabs/car_tab_view.dart';
import 'package:yigou/pages/tabs/cate_tab_view.dart';
import 'package:yigou/pages/tabs/home_tab_view.dart';
import 'package:yigou/pages/tabs/mineTabView.dart';
import 'package:yigou/pages/user/loginView.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/event_bus.dart';
import 'package:yigou/tools/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool check = false;
  bool enter = false;
  bool secretOpen = false;
  var eventListen;

  late PageController _pageController;

  int unread = 0;

  List<Map<String, dynamic>> dataList = [];

  final List<Map> _tabs = [
    {
      "name": "首页",
      "icon": Icon(Icons.home_filled),
    },
    {"name": "分类", "icon": Icon(Icons.category)},
    {"name": S.current.cart, "icon": Icon(Icons.car_repair)},
    {
      "name": S.current.mine,
      "icon": Icon(Icons.access_alarms),
    },
  ];
  late Map _selectedTab;
  bool _checkPwd = false; //是否显示输入框尾部的清除按钮
  int _currentIndex = 0;
  bool showTabbar = true;
  @override
  void initState() {
    super.initState();

    eventListen = eventBus.on<SocketEvent>().listen((event) {
      queryData();
    });

    queryData();

    _selectedTab = _tabs[0];
    _pageController =
        PageController(initialPage: _currentIndex, keepPage: true);

    eventBus.on<HideKeyboard>().listen((event) {
      setState(() {
        showTabbar = true;
      });
    });
    login();
    setState(() {
      secretOpen = true;
      enter = true;
    });
  }

  void queryData() async {}

  void _checkPwdHandler(check) async {
    setState(() {
      _checkPwd = check;
    });
  }

  void login() async {
    var user = await StorageUtil.getUser();
    if (user == null) {
      AppUtil.getTo(LoginViewPage());
    } else {
      AppUtil.user = user;

      setState(() {});
    }
  }

  String timeFormat(String time) {
    DateTime nowTime = DateTime.parse(time);
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(nowTime);
  }

  void unagreeHandler() {}

  void agreeHandler() {
    if (!_checkPwd) {
      EasyLoading.showInfo("请先阅读协议");
      return;
    }
    setState(() {
      secretOpen = true;
      enter = true;
    });
    login();
  }

  void clickTab(index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 20;
    var tab = _tabs[_currentIndex];
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(), // 禁止左右滑动切换页面
              controller: _pageController,
              children: [
                HomeTabViewPage((tab) {
                  clickTab(tab);
                }),
                CateTab(),
                const CarTabViewPage(),
                const MineTabViewPage()
              ],
            ),
          ),
          Container(
            color: const Color(0xfff0f5f0),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10, top: 10),
            child: Row(
              children: _tabs.map((e) {
                int index = _tabs.indexOf(e);

                return Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        clickTab(index);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Opacity(
                                opacity: _currentIndex == index ? 1 : 0.5,
                                child: e["icon"]),
                            SizedBox(height: 5),
                            MyText(
                              e["name"],
                              fontSize: 13,
                              color: _currentIndex == index
                                  ? const Color(0xff000000)
                                  : const Color(0xffaaaaaa),
                            ),
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
