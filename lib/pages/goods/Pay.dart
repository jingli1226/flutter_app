import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yigou/tools/storage.dart';

class Pay extends StatefulWidget {
  String money;
  String id;
  Pay(this.id, this.money, {Key? key}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  Map? goods;
  Map? address;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
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

  void queryData() {
    // ApiService.Pays(widget.id).then((value) {
    //   setState(() {
    //     goods = value["goods"];
    //     int i = 0;
    //   });
    // });
  }

  void pay() async {
    List list = await StorageUtil.getOrders();
    Map detail = list.firstWhere((element) => element["id"] == widget.id);
    detail["status"] = 1;
    await StorageUtil.saveOrders(list);
    EasyLoading.showSuccess("支付成功");
  }

  void addCart(Map item, int num) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
          title: MyText(
            "支付",
          ),
          centerTitle: true,
          elevation: 0.0,
          toolbarHeight: 50,
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: Container(
          child: Column(children: [
            const SizedBox(height: 20),
            MyText(
              "支付金额",
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  "¥",
                  fontSize: 15,
                  color: Colors.red,
                  weight: FontWeight.bold,
                ),
                MyText(
                  widget.money.toString(),
                  fontSize: 20,
                  color: Colors.red,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: AppUtil.getCommonPadding(),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/jdpay.png",
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      MyText("京东支付"),
                      const Spacer(),
                      Image.asset(
                        "images/radio_checked.png",
                        width: 20,
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 50),
            MyButton(
              "确认支付",
              width: 200,
              onTap: () {
                pay();
              },
            )
          ]),
        ));
  }
}
