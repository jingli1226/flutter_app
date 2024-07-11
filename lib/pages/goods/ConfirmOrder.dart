import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/goods/Pay.dart';
import 'package:yigou/pages/goods/addressList.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yigou/tools/storage.dart';

class ConfirmOrder extends StatefulWidget {
  List list;

  ConfirmOrder(this.list, {Key? key}) : super(key: key);

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Map? orders;
  List items = [];
  Map? address;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    items = widget.list;
  }

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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

  ///see AutomaticKeepAliveClientMixin

  void confirm() async {
    if (address == null) {
      EasyLoading.showError("请选择收货地址");
      return;
    }

    List list = await StorageUtil.getOrders();
    String id = AppUtil.getUUID();
    list.add({
      "id": id,
      "createtime": AppUtil.formateTime(),
      "items": items,
      "status": 0,
      "price": getTotalPrice()
    });
    StorageUtil.saveOrders(list);
    AppUtil.getTo(Pay(id, getTotalPrice().toString()));
  }

  void addCart(Map item, int num) {}

  double getTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < items.length; i++) {
      Map item = items[i];
      totalPrice = totalPrice + (item["price"] ?? 0) * item["num"];
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = getTotalPrice();

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          title: MyText(
            "确认订单",
          ),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 50,
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: Container(
          padding:
              EdgeInsets.fromLTRB(AppConfig.padding, 0, 0, AppConfig.padding),
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      AppUtil.getTo(AddressList((item) {
                        setState(() {
                          address = item;
                        });
                      }));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          address == null
                              ? MyText(
                                  "请添加收获地址",
                                  color: AppConfig.font3,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                        address!["name"] + address!["phone"]),
                                    SizedBox(height: 5),
                                    MyText(
                                      address!["province"] +
                                          address!["city"] +
                                          address!["county"] +
                                          address!["address"],
                                      color: AppConfig.font3,
                                    )
                                  ],
                                ),
                          const Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...items
                            .map((item) => GestureDetector(
                                onTap: () {
                                  var id = item["id"];
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        child: Image.file(
                                          File(item["image"]),
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                          child: SizedBox(
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              item!["title"].toString(),
                                              fontSize: 18,
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
                                                  fontSize: 20,
                                                  weight: FontWeight.bold,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          addCart(item, -1);
                                                        },
                                                        child: Container(
                                                          child: MyText("-"),
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  12, 8, 12, 8),
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20)),
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xffD9D9D9))),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: MyText(
                                                            item["num"]
                                                                .toString()),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            const BoxDecoration(
                                                                border: Border(
                                                          top: BorderSide(
                                                              width: 1.0,
                                                              color: Color(
                                                                  0xffD9D9D9)),
                                                          bottom: BorderSide(
                                                              width: 1.0,
                                                              color: Color(
                                                                  0xffD9D9D9)),
                                                        )),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            addCart(item, 1);
                                                          },
                                                          child: Container(
                                                            child: MyText("+"),
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    12,
                                                                    8,
                                                                    12,
                                                                    8),
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius
                                                                    .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20)),
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xffD9D9D9))),
                                                          )),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                )))
                            .toList(),
                        const SizedBox(height: 10),
                        Container(height: 1, color: AppConfig.grayBgColor),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              "商品金额",
                            ),
                            MyText(
                              "¥" + totalPrice.toString(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        Container(height: 1, color: AppConfig.grayBgColor),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyText(
                              "合计:",
                            ),
                            MyText(
                              "¥" + totalPrice.toString(),
                              color: Colors.red,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       MyText(
                  //         "支付方式",
                  //       ),
                  //       MyText(
                  //         "在线支付",
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                      confirm();
                    },
                    child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xff7656ee)),
                        child: MyText(
                          "去结算",
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
