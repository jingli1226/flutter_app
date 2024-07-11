import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yigou/pages/goods/GoodsDetail.dart';
import 'package:yigou/pages/goods/deploy.dart';
import 'package:yigou/pages/goods/search.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeTabViewPage extends StatefulWidget {
  Function gotoTab;

  HomeTabViewPage(this.gotoTab, {Key? key}) : super(key: key);

  @override
  _HomeTabViewPageState createState() => _HomeTabViewPageState();
}

class _HomeTabViewPageState extends State<HomeTabViewPage>
    with AutomaticKeepAliveClientMixin, RouteAware {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List banner = [];
  List goodsList = [];

  TextEditingController priceMin = TextEditingController();
  TextEditingController priceMax = TextEditingController();

  @override
  void initState() {
    super.initState();
    queryData();
  }

  @override
  bool get wantKeepAlive => true;

  //回到当前页面
  @override
  void didPopNext() {
    queryData();
  }

  @override
  void didPop() {
    queryData();
  }

  void _onRefresh() async {
    queryData();
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

  void queryData() async {
    goodsList = await DBUtil.searchGoods();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenwidth = MediaQuery.of(context).size.width;
    double gap = 10;
    int columns = 2;

    double cwidth =
        (MediaQuery.of(context).size.width - AppUtil.getPadding() * 2);
    double itemWidth =
        (screenwidth - AppUtil.getPadding() * 2 - gap * (columns - 1)) /
            columns;
    double itemHeight = itemWidth + 130;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 50,
          title: MyText(
            "校园二手交易市场",
            weight: FontWeight.bold,
          ),
          shadowColor: Colors.transparent,
          backgroundColor: AppConfig.grayBgColor,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          actions: [
            IconButton(
              onPressed: () {
                AppUtil.getTo(DeployPage(
                  onSave: () {
                    queryData();
                  },
                ));
              },
              icon: Icon(Icons.add),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    AppUtil.getTo(Search());
                  },
                  child: Container(
                    height: 38,
                    margin: EdgeInsets.fromLTRB(
                        AppUtil.getPadding(), 5, AppUtil.getPadding(), 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppConfig.font2,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerLeft,
                          // color: Colors.red,

                          child: MyText(
                            "请输入搜索的商品",
                            color: AppConfig.font2,
                          ),
                        )),
                        MyButton(
                          "搜索",
                          width: 60,
                          height: 30,
                          fontSize: 14,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    width: double.infinity,
                    margin: AppUtil.getCommonPadding(),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: gap,
                        crossAxisSpacing: gap,
                        childAspectRatio: itemWidth / itemHeight,
                      ),
                      itemBuilder: (context, index) {
                        Map goods = goodsList[index];
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppUtil.getTo(GoodsDetail(goods));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        new File(goods["images"]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 30,
                                          alignment: Alignment.topLeft,
                                          child: MyText(
                                            goods["name"],
                                            color: AppConfig.font2,
                                            fontSize: 14,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                MyText(
                                                  "¥",
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                                MyText(
                                                  goods["price"].toString(),
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                  weight: FontWeight.bold,
                                                ),
                                                SizedBox(width: 10),
                                                MyText(
                                                  "原价",
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                                Text(
                                                  "¥" +
                                                      goods["price"].toString(),
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        );
                      },
                      itemCount: goodsList.length,
                    ))
              ],
            )));
  }
}
