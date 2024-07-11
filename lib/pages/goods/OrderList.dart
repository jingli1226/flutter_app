import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yigou/models/user.dart';

import 'package:yigou/pages/goods/comment_view.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/pages/widgets/empty.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:yigou/tools/storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderList extends StatefulWidget {
  int type;
  OrderList(this.type, {Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // var cates = ["全部", "甜品", "简餐", "蔬菜", "面食"];
  var selectCate;
  var list = [];
  int? tab;
  var tuijians = [];
  var nowMessageLatest;

  int nowIndex = 0;
  bool keyboardShow = false;

  TabController? _tabController;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  bool get wantKeepAlive => true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ///see AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
    tab = widget.type;
    query();
  }

  query() async {
    setState(() {
      list = [];
    });
    List res = await StorageUtil.getOrders();
    setState(() {
      if (tab == null) {
        list = res;
      } else {
        list = res.where((element) => element["status"] == tab).toList();
      }
    });
    _refreshController.refreshCompleted();
  }

  send(Map item) async {
    List res = await StorageUtil.getOrders();
    Map o = res.firstWhereOrNull((element) => element["id"] == item["id"]);
    o["status"] = 2;
    await StorageUtil.saveOrders(res);
    query();
    // var res = await ApiService.orderComplete(item["id"]);
    // query();
  }

  confirmRecieve(Map item) async {
    List res = await StorageUtil.getOrders();
    Map o = res.firstWhereOrNull((element) => element["id"] == item["id"]);
    o["status"] = 3;
    await StorageUtil.saveOrders(res);
    query();
    // var res = await ApiService.orderComplete(item["id"]);
    // query();
  }

  cancelOrder(Map item) async {
    // var res = await ApiService.delOrder(item["id"]);
    // query();
  }

  void _onRefresh() async {
    // monitor network fetch
    query();
    _refreshController.refreshCompleted();

    // // if failed,use refreshFailed()
  }

  void _onLoading() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    // setState(() {

    // });
    _refreshController.loadComplete();
  }

  void _onPageChange(int index) {
    nowIndex = index;
    setState(() {});
    // _tabController?.animateTo(index);
  }

  void queryChatCircle() async {
    User? u = await StorageUtil.getUser();
  }

  void pay(item) {
    // ApiService.againPay(item["id"]).then((value) {
    //   AppUtil.getTo(Pay(value["payurl"], item["money"].toString()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          // title: Text(user != null ? user["nickname"] : "",style:TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 40,
          title: MyText(
            "订单列表",
            weight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xffffffff)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        tab = null;
                        query();
                      });
                    },
                    child: Column(
                      children: [
                        MyText(
                          "全部",
                          color: AppConfig.font1,
                          fontSize: 15,
                          weight:
                              tab == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                        const SizedBox(height: 5),
                        tab == null
                            ? Container(
                                height: 2,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: AppConfig.themeColor,
                                    borderRadius: BorderRadius.circular(2)),
                              )
                            : Container(
                                height: 2,
                              )
                      ],
                    ),
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          tab = 0;
                          query();
                        });
                      },
                      child: Column(
                        children: [
                          MyText(
                            "待付款",
                            color: AppConfig.font1,
                            weight:
                                tab == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                          const SizedBox(height: 5),
                          tab == 0
                              ? Container(
                                  height: 2,
                                  width: 15,
                                  decoration: BoxDecoration(
                                      color: AppConfig.themeColor,
                                      borderRadius: BorderRadius.circular(2)),
                                )
                              : Container(
                                  height: 2,
                                )
                        ],
                      )),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          tab = 1;
                          query();
                        });
                      },
                      child: Column(
                        children: [
                          MyText(
                            "待发货",
                            color: AppConfig.font1,
                            weight:
                                tab == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                          const SizedBox(height: 5),
                          tab == 1
                              ? Container(
                                  height: 2,
                                  width: 15,
                                  decoration: BoxDecoration(
                                      color: AppConfig.themeColor,
                                      borderRadius: BorderRadius.circular(2)),
                                )
                              : Container(
                                  height: 2,
                                )
                        ],
                      )),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          tab = 2;
                          query();
                        });
                      },
                      child: Column(
                        children: [
                          MyText(
                            "待收货",
                            color: AppConfig.font1,
                            weight:
                                tab == 2 ? FontWeight.bold : FontWeight.normal,
                          ),
                          const SizedBox(height: 5),
                          tab == 2
                              ? Container(
                                  height: 2,
                                  width: 15,
                                  decoration: BoxDecoration(
                                      color: AppConfig.themeColor,
                                      borderRadius: BorderRadius.circular(2)),
                                )
                              : Container(
                                  height: 2,
                                )
                        ],
                      )),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          tab = 3;
                          query();
                        });
                      },
                      child: Column(
                        children: [
                          MyText(
                            "已完成",
                            color: AppConfig.font1,
                            weight:
                                tab == 3 ? FontWeight.bold : FontWeight.normal,
                          ),
                          const SizedBox(height: 5),
                          tab == 3
                              ? Container(
                                  height: 2,
                                  width: 15,
                                  decoration: BoxDecoration(
                                      color: AppConfig.themeColor,
                                      borderRadius: BorderRadius.circular(2)),
                                )
                              : Container(
                                  height: 2,
                                )
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            list.isEmpty
                ? const Empty(
                    title: "当前状态下没有订单",
                  )
                : Expanded(
                    flex: 1,
                    child: Container(
                      color: AppConfig.grayBgColor,
                      child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: const WaterDropHeader(),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          cacheExtent: 1000,
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                              itemCount: (list.isNotEmpty ? list.length : 1),
                              itemBuilder: (BuildContext context, int index) {
                                if (list.isEmpty) {
                                  return const Empty(
                                    title: "当前没有待支付订单",
                                  );
                                }
                                return getItem(index);
                              })),
                    ))
          ],
        ));
  }

  Widget getItem(int index) {
    Map item = list[index];
    List goodsList = item["items"];
    int a = 1;
    return GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(bottom: 0, top: 10),
          padding: EdgeInsets.only(
              left: AppUtil.getPadding(),
              top: 10,
              right: AppUtil.getPadding(),
              bottom: 10),
          decoration: BoxDecoration(
              color: const Color(0xffffffff),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x01000000), //底色,阴影颜色
                  offset: Offset(1, 0), //阴影位置,从什么位置开始
                  blurRadius: 3, // 阴影模糊层度
                  spreadRadius: 0, //阴影模糊大小
                )
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    "下单时间:" + item["createtime"],
                    fontSize: 13,
                  ),
                  MyText(
                    getStatus(item),
                    color: const Color(0xffF42648),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: goodsList
                    .map((it) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: Image.file(
                                File(it["image"]),
                                width: 57,
                                height: 57,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  it["title"],
                                  maxLines: 2,
                                  fontSize: 13,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppConfig.themeColor,
                                              width: 1)),
                                      child: MyText(
                                        "限时抢",
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 40),
                              ],
                            )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MyText(
                                  "¥" + it["price"].toString(),
                                  color: Colors.black,
                                  weight: FontWeight.bold,
                                ),
                                SizedBox(height: 4),
                                MyText(
                                  "x" + it["num"].toString(),
                                  color: AppConfig.font2,
                                  fontSize: 12,
                                )
                              ],
                            )
                          ],
                        )))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyText(
                    "共1件商品",
                    color: AppConfig.font3,
                    fontSize: 12,
                  ),
                  const SizedBox(width: 10),
                  MyText(
                    "实付款:",
                    fontSize: 12,
                  ),
                  MyText(
                    "¥" + item["price"].toString(),
                    weight: FontWeight.bold,
                    fontSize: 15,
                    color: AppConfig.themeColor,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  item["status"] == 0
                      ? MyButton(
                          "关闭订单",
                          width: 120,
                          fontSize: 14,
                          backgroundColor: 0xffFFB149,
                          onTap: () {
                            cancelOrder(item);
                          },
                        )
                      : Container(),
                  const SizedBox(width: 10),
                  item["status"] == 1
                      ? MyButton(
                          "发货",
                          width: 120,
                          fontSize: 14,
                          onTap: () {
                            send(item);
                          },
                        )
                      : Container(),
                  item["status"] == 2
                      ? MyButton(
                          "确认收货",
                          width: 120,
                          fontSize: 14,
                          backgroundColor: 0xffFFB149,
                          onTap: () {
                            confirmRecieve(item);
                          },
                        )
                      : Container(),
                  item["status"] == 3
                      ? MyButton(
                          "去评价",
                          width: 120,
                          fontSize: 14,
                          backgroundColor: 0xffFFB149,
                          onTap: () {
                            AppUtil.getTo(CommentView(goodsList[0]["id"]));
                          },
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ));
  }

  String getStatus(Map item) {
    var status = item["status"];
    if (status == 0) {
      return "未支付";
    } else if (status == 1) {
      return "已支付";
    } else if (status == 2) {
      return "已发货";
    } else if (status == 3) {
      return "已完成";
    }
    return "";
  }
}
