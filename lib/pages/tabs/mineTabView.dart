import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/models/user.dart';
import 'package:yigou/pages/goods/OrderList.dart';
import 'package:yigou/pages/tabs/fav.dart';

import 'package:yigou/pages/user/settingView.dart';
import 'package:yigou/pages/widgets/avatar.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/storage.dart';

class MineTabViewPage extends StatefulWidget {
  const MineTabViewPage({Key? key}) : super(key: key);

  @override
  _MineTabViewPageState createState() => _MineTabViewPageState();
}

class _MineTabViewPageState extends State<MineTabViewPage> {
  var list = [];
  User? user;
  List goodsList = [];

  ///see AutomaticKeepAliveClientMixin

  @override
  void initState() {
    getUser();
    queryData();
  }

  void queryData() {}

  void getUser() async {
    user = await StorageUtil.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        // title: Text(user != null ? user["nickname"] : "",style:TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
          child: Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 135, 121, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                padding: EdgeInsets.fromLTRB(10, 60, 10, 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Avatar(
                                //"https://img2.baidu.com/it/u=170237391,555920326&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500"),
                                "https://ts1.cn.mm.bing.net/th/id/R-C.57384e4c2dd256a755578f00845e60af?rik=uy9%2bvT4%2b7Rur%2fA&riu=http%3a%2f%2fimg06file.tooopen.com%2fimages%2f20171224%2ftooopen_sy_231021357463.jpg&ehk=whpCWn%2byPBvtGi1%2boY1sEBq%2frEUaP6w2N5bnBQsLWdo%3d&risl=&pid=ImgRaw&r=0"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.nickname ?? "user",
                                maxLines: 4,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppUtil.getTo(OrderList(0));
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.padding),
                              SizedBox(height: 10),
                              Text(
                                "待付款",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(100, 100, 100, 1)),
                              )
                            ],
                          ))),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppUtil.getTo(OrderList(1));
                          },
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.dnd_forwardslash),
                                const SizedBox(height: 10),
                                const Text(
                                  "待发货",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(100, 100, 100, 1)),
                                )
                              ],
                            ),
                          ))),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppUtil.getTo(OrderList(2));
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt),
                              SizedBox(height: 10),
                              Text(
                                "待收货",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(100, 100, 100, 1)),
                              )
                            ],
                          ))),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppUtil.getTo(OrderList(3));
                          },
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.file_download),
                              SizedBox(height: 10),
                              Text(
                                "待评价",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromRGBO(100, 100, 100, 1)),
                              )
                            ],
                          ))),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        AppUtil.getTo(const Fav());
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite),
                          SizedBox(width: 10),
                          Text(
                            "收藏",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(100, 100, 100, 1)),
                          ),
                          Spacer(),
                          Icon(Icons.navigate_next)
                        ],
                      )),
                  SizedBox(height: 25),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        AppUtil.getTo(const Setting());
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 10),
                          Text(
                            "设置",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(100, 100, 100, 1)),
                          ),
                          Spacer(),
                          Icon(Icons.navigate_next)
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
