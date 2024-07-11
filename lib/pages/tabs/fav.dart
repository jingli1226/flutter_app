import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/goods/ConfirmOrder.dart';
import 'package:yigou/pages/goods/GoodsDetail.dart';
import 'package:yigou/pages/widgets/LeftSlideActions.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yigou/tools/storage.dart';

class Fav extends StatefulWidget {
  const Fav({Key? key}) : super(key: key);

  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav> {
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
    list = await StorageUtil.getFavs();

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
              "我的收藏",
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
                                    AppUtil.getTo(GoodsDetail(item));
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
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ClipRRect(
                                          child: MyNetImage(
                                            url: item["image"],
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
            ],
          )),
    );
  }
}
