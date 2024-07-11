import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yigou/pages/goods/GoodsDetail.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';

class CateTab extends StatefulWidget {
  CateTab({Key? key}) : super(key: key);

  @override
  _CateTabState createState() => _CateTabState();
}

class _CateTabState extends State<CateTab>
    with AutomaticKeepAliveClientMixin, RouteAware {
  var cates = [];
  var selectCate = null;

  var children = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    query();
  }

  void query() async {
    List goodsList = await DBUtil.searchGoods();
    cates = ["服装", "鞋子", "生活", "数码"];
    selectCate = cates[0];
    clickCate(selectCate);
  }

  void clickCate(cate) async {
    selectCate = cate;
    List goodsList = await DBUtil.searchGoods();
    children =
        goodsList.where((element) => element["cate"] == selectCate).toList();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "商品分类",
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(children: [
          Expanded(
              child: Row(
            children: [
              Container(
                color: Color(0xfff6f6f6),
                height: double.infinity,
                width: 110,
                child: Column(
                  children: cates.map((item) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        clickCate(item);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                            color: selectCate == item
                                ? Color(0xffffffff)
                                : Colors.transparent),
                        child: Text(
                          item.toString(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                        child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            controller: _refreshController,
                            cacheExtent: 1000,
                            physics: const BouncingScrollPhysics(),
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1 / 1.4,
                              ),
                              itemBuilder: (context, index) {
                                Map item = children[index];
                                return GestureDetector(
                                  onTap: () {
                                    AppUtil.getTo(GoodsDetail(item));
                                  },
                                  child: Container(
                                      child: Column(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Container(
                                            child: Image.file(
                                              File(item["images"]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(item["name"],
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  )),
                                );
                              },
                              itemCount: children.length,
                            )))
                  ],
                ),
              ))
            ],
          ))
        ]));
  }
}
