import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/pages/goods/editAddress.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/pages/widgets/empty.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:yigou/tools/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddressList extends StatefulWidget {
  Function selectAddress;
  AddressList(this.selectAddress, {Key? key}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  var list = [];
  var tab = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  bool get wantKeepAlive => true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ///see AutomaticKeepAliveClientMixin

  @override
  void initState() {
    super.initState();
    queryData();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
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

  void queryData() async {
    list = await StorageUtil.getAddressList();
    setState(() {});
  }

  void _onPageChange(int index) {
    setState(() {});
    // _tabController?.animateTo(index);
  }

  void AddressList(Map item) {
    EasyLoading.showSuccess("发送成功!");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            centerTitle: true,
            title: MyText(
              "收货地址",
              fontSize: 15,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    AppUtil.getTo(EditAddress(null, onSave: () {
                      queryData();
                    }));
                  },
                  child: MyText("添加"))
            ],
            systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark)),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                flex: 1,
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
                            return const Empty();
                          }
                          return getItem(index);
                        })))
          ],
        ));
  }

  Widget getItem(int index) {
    Map item = list[index];

    return GestureDetector(
        onTap: () {
          widget.selectAddress(item);
          AppUtil.back();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.only(
            left: AppUtil.getPadding(),
            top: 20,
            right: AppUtil.getPadding(),
            bottom: 20,
          ),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              MyText(
                "地址",
                color: AppConfig.font1,
                fontSize: 15,
              ),
              const SizedBox(width: 10),
              MyText(
                item["province"] +
                    item["city"] +
                    item["county"] +
                    item["address"],
                color: AppConfig.font1,
                fontSize: 15,
              ),
              const Spacer(),
              const Icon(Icons.navigate_next)
            ],
          ),
        ));
  }
}
