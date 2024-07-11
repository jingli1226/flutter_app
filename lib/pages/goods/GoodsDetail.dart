import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:yigou/models/user.dart';

import 'package:yigou/pages/user/loginView.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yigou/tools/storage.dart';

class GoodsDetail extends StatefulWidget {
  Map goods;
  GoodsDetail(this.goods, {Key? key}) : super(key: key);

  @override
  _GoodsDetailState createState() => _GoodsDetailState();
}

class _GoodsDetailState extends State<GoodsDetail>
    with AutomaticKeepAliveClientMixin, RouteAware {
  Map? goods;

  int buyNum = 1;
  List images = [];
  List contentImages = [];

  double opacity = 0;
  Map? selectSpec;
  List comments = [];
  bool fav = false;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    goods = widget.goods;
    images = [goods!["images"]];
    contentImages = [goods!["images"]];
    query();
    isFav();
  }

  query() async {
    List goodsList = await DBUtil.searchGoods();
    goods = await goodsList.firstWhere((e) => e["id"] == goods!["id"]);
    List res = await StorageUtil.getComments();
    setState(() {
      comments = res
          .where((element) => element["goodsId"] == widget.goods["id"])
          .toList();
    });
  }

  isFav() async {
    List favs = await StorageUtil.getFavs();
    fav = favs.firstWhereOrNull((element) => element["id"] == goods!["id"]) !=
        null;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  void confirm() {
    // AppUtil.getTo(ConfirmOrder());
  }

  void _onRefresh() async {
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

  void submit() async {
    //
  }

  void addFav() async {
    if (!fav) {
      List cart = await StorageUtil.getFavs();
      cart.add({
        "title": goods!["title"],
        "image": goods!["image"],
        "price": goods!["price"],
        "id": goods!["id"],
        "num": 1,
      });
      await StorageUtil.saveFavs(cart);
    } else {
      List cart = await StorageUtil.getFavs();
      cart =
          cart.where((element) => element["id"] != widget.goods["id"]).toList();
      await StorageUtil.saveFavs(cart);
    }

    isFav();
  }

  void addCart() async {
    List cart = await StorageUtil.getCart();
    cart.add({
      "title": goods!["name"],
      "image": goods!["images"],
      "price": goods!["price"],
      "id": goods!["id"],
      "num": 1,
    });
    await StorageUtil.saveCart(cart);
    EasyLoading.showSuccess("添加成功");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double itemWidth =
        (MediaQuery.of(context).size.width - AppUtil.getPadding() * 2 - 10) / 2;
    double itemHeight = itemWidth + 50;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor:
              Color.fromARGB((opacity * 255).toInt(), 255, 255, 255),
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 40,
          titleSpacing: 0,
          title: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Opacity(
                        opacity: opacity,
                        child: MyText(
                          goods != null ? goods!["title"] : "商品详情",
                        ))),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Color.fromARGB(
                        255,
                        (255 - opacity * 255).toInt(),
                        (255 - opacity * 255).toInt(),
                        (255 - opacity * 255).toInt()),
                    size: 16,
                  ),
                  onPressed: () {
                    AppUtil.back();
                  },
                )
              ],
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, (255 - opacity * 255).toInt(),
                  (255 - opacity * 255).toInt(), (255 - opacity * 255).toInt()),
              size: 16,
            ),
            onPressed: () {
              AppUtil.back();
            },
          ),
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: Column(
          children: [
            Expanded(
                child: goods == null
                    ? Container()
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.width * 1,
                              child: Swiper(
                                itemHeight:
                                    MediaQuery.of(context).size.width * 0.5,
                                itemBuilder: (BuildContext context, int index) {
                                  String item = images[index];
                                  //条目构建函数传入了index,根据index索引到特定图片
                                  return Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: Image.file(
                                      File(item),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                scale: 0.8,
                                itemCount: images.length,
                                autoplay: false,
                                pagination: null, //这些都是控件默认写好的,直接用
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: MyText(goods!["name"]),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: MyText(
                                "商品详情",
                                fontSize: 14,
                                weight: FontWeight.bold,
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                margin: EdgeInsets.fromLTRB(
                                    AppUtil.getPadding(),
                                    10,
                                    AppUtil.getPadding(),
                                    10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: MyText(goods!["remark"])),
                            const SizedBox(height: 10),

                            // Html(
                            //   data: goods!["details"],
                            // ),
                          ],
                        ),
                      )),
            Container(
              padding: EdgeInsets.fromLTRB(
                  AppUtil.getPadding(),
                  AppUtil.getPadding(),
                  AppUtil.getPadding(),
                  AppUtil.getPadding() + MediaQuery.of(context).padding.bottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            addFav();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                  Color(0xffe0e8fd),
                                  Color(0xffe0e8fd)
                                ])),
                            child: Row(
                              children: [
                                !fav
                                    ? Icon(Icons.favorite_outline)
                                    : Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            addCart();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                  Color(0xffe0e8fd),
                                  Color(0xffe0e8fd)
                                ])),
                            child: MyText(
                              "加入购物车",
                              color: const Color(0xff000000),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
