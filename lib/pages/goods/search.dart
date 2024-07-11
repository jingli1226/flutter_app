import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/goods/GoodsDetail.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin, RouteAware {
  var cates = [];
  var selectCate = null;

  var children = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  //回到当前页面
  @override
  void didPopNext() {
    print("返回了");
  }

  @override
  void didPop() {
    print("返回了");
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

  void query() async {
    List goodsList = await DBUtil.searchGoods();
    setState(() {});
    children = goodsList
        .where((element) =>
            element["title"].toString().contains(editingController.text))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 40,
          title: MyText(
            "商品搜索",
            weight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                AppUtil.getPadding(), 0, AppUtil.getPadding(), 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                color: Color(0xffeeeeee),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  color: Color(0xffaaaaaa),
                ),
                SizedBox(width: 6),
                Expanded(
                    child: Container(
                  // color: Colors.red,

                  child: TextField(
                    style: TextStyle(),
                    maxLines: 1,
                    controller: editingController,
                    textAlignVertical: TextAlignVertical.center,
                    onSubmitted: (v) {
                      query();
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入搜索的商品",
                        hintStyle: TextStyle(color: Color(0xffaaaaaa))),
                  ),
                ))
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: AppUtil.getCommonPadding(),
                  child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      cacheExtent: 1000,
                      physics: const BouncingScrollPhysics(),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      child: CachedNetworkImage(
                                        imageUrl: item["image"],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                MyText(
                                  item["title"],
                                  color: AppConfig.font1,
                                )
                              ],
                            )),
                          );
                        },
                        itemCount: children.length,
                      ))))
        ]));
  }
}
