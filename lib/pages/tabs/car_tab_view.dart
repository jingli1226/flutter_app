import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/goods/ConfirmOrder.dart';
import 'package:yigou/pages/widgets/LeftSlideActions.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yigou/tools/storage.dart';

class CarTabViewPage extends StatefulWidget {
  const CarTabViewPage({Key? key}) : super(key: key);

  @override
  _CarTabViewPageState createState() => _CarTabViewPageState();
}

class _CarTabViewPageState extends State<CarTabViewPage> {
  var list = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool selectedAll = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    list = await StorageUtil.getCart();
    for (int i = 0; i < list.length; i++) {
      Map item = list[i];
      item["selected"] = false;
    }
    setState(() {});
  }

  ///see AutomaticKeepAliveClientMixin

  void addCart(Map item, int num) {
    int n = item["num"] + num;
    if (n < 1) {
      return;
    }
  }

  void removeItem(Map item) {
    list.remove(item);
    StorageUtil.saveCart(list);
    setState(() {});
    // var then = ApiService.delCart(item["cartid"].toString()).then((value) {
    //   queryData();
    // });
  }

  void selectAll() {
    selectedAll = !selectedAll;
    for (var item in list) {
      item["selected"] = selectedAll;
    }
    setState(() {});
  }

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
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

  void submit() async {
    AppUtil.getTo(ConfirmOrder(list));
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    int length = 0;
    for (int i = 0; i < list.length; i++) {
      Map item = list[i];

      if (item["selected"]) {
        length++;
        totalPrice = totalPrice + (item["price"] ?? 0) * item["num"];
      }
    }
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark
            .copyWith(statusBarColor: Colors.transparent),
        // title: Text(user != null ? user["nickname"] : "",style:TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0.0,
        title: Column(
          children: [
            MyText(
              "购物车",
              weight: FontWeight.bold,
            ),
          ],
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(color: AppConfig.grayBgColor),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      padding: AppUtil.getCommonPadding(),
                      color: Colors.white,
                      child: Row(
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                selectAll();
                              },
                              child: selectedAll
                                  ? Image.asset(
                                      "images/checked.png",
                                      width: 20,
                                      height: 20,
                                    )
                                  : Image.asset(
                                      "images/unchecked.png",
                                      width: 20,
                                      height: 20,
                                    )),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.all(3),
                            child: MyText(
                              "全部选择",
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    ...list.map((item) {
                      return Container(
                          child: LeftSlideActions(
                              actionsWidth: 40,
                              actions: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    removeItem(item);
                                  },
                                  child: Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffF42648)),
                                    child: MyText(
                                      "删除",
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                              child: GestureDetector(
                                  onTap: () {
                                    // var id = item["id"];
                                    // NavigatorUtil.jump(
                                    //     context, '/resourceDetail?id=$id');
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        AppUtil.getPadding(),
                                        10,
                                        AppUtil.getPadding(),
                                        10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            setState(() {
                                              item["selected"] =
                                                  !item["selected"];
                                            });
                                          },
                                          child: item["selected"] == true
                                              ? Image.asset(
                                                  "images/checked.png",
                                                  width: 20,
                                                  height: 20,
                                                )
                                              : Image.asset(
                                                  "images/unchecked.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ClipRRect(
                                          child: Image.file(
                                            File(item["image"]),
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: SizedBox(
                                          height: 90,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                item["title"],
                                                fontSize: 15,
                                                maxLines: 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  MyText(
                                                    "¥" +
                                                        (item["price"]
                                                            .toString()),
                                                    color:
                                                        const Color(0xffF44453),
                                                    fontSize: 16,
                                                    weight: FontWeight.bold,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                item["num"] =
                                                                    item["num"] -
                                                                        1;
                                                                if (item[
                                                                        "num"] <
                                                                    1) {
                                                                  item["num"] =
                                                                      1;
                                                                }
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                child: MyText(
                                                                  "-",
                                                                  fontSize: 20,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .fromLTRB(
                                                                        12,
                                                                        8,
                                                                        12,
                                                                        8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20)),
                                                                  // border: Border.all(
                                                                  //     color: const Color(
                                                                  //         0xffD9D9D9))
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: MyText(item[
                                                                      "num"]
                                                                  .toString()),
                                                              padding: AppUtil
                                                                  .getEdgeInsets(
                                                                      horizontal:
                                                                          14,
                                                                      vertically:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xffD9D9D9))),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  item["num"] =
                                                                      item["num"] +
                                                                          1;

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child:
                                                                    Container(
                                                                  child: MyText(
                                                                    "+",
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .fromLTRB(
                                                                          12,
                                                                          8,
                                                                          12,
                                                                          8),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomRight:
                                                                            Radius.circular(20)),
                                                                    // border: Border.all(
                                                                    //     color:
                                                                    //         const Color(0xffD9D9D9))
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ))));
                      // }

                      // return FrameSeparateWidget(
                      //     index: index, placeHolder: Container(), child: widget);
                    }),
                  ],
                ),
              )),
              Container(
                padding: EdgeInsets.fromLTRB(
                    AppUtil.getPadding(), 20, AppUtil.getPadding(), 20),
                color: Colors.white,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            MyText("合计:"),
                            MyText(
                              "¥" + totalPrice.toString(),
                              fontSize: 18,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (length == 0) {
                          EasyLoading.showError("请选择商品");
                          return;
                        }
                        submit();
                      },
                      child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppConfig.themeDeepColor),
                          child: MyText(
                            "确认结算(" + length.toString() + ")",
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
