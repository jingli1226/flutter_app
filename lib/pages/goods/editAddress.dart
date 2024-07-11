import 'package:flutter/material.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yigou/tools/storage.dart';

class EditAddress extends StatefulWidget {
  Map? address;
  Function? onSave;
  EditAddress(this.address, {Key? key, this.onSave}) : super(key: key);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress>
    with AutomaticKeepAliveClientMixin {
  var list = [];
  var cats = [];
  bool isDefault = false;
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController provinceEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController countyEditingController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.address != null) {
      textEditingController.text = widget.address!["email"];
    }
  }

  @override
  bool get wantKeepAlive => true;

  ///see AutomaticKeepAliveClientMixin

  void confirm() async {
    if (textEditingController.text.trim() == "") {
      EasyLoading.showError("请输入地址");
      return;
    }
    List list = await StorageUtil.getAddressList();
    list.add({
      "province": provinceEditingController.text,
      "city": cityEditingController.text,
      "county": countyEditingController.text,
      "address": textEditingController.text,
      "name": nameEditingController.text,
      "phone": phoneEditingController.text
    });
    await StorageUtil.saveAddressList(list);
    if (widget.onSave != null) {
      widget.onSave!();
    }
    AppUtil.back();
  }

  void getUser() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: MyText(widget.address == null ? "添加地址" : "修改地址"),
        ),
        backgroundColor: AppConfig.grayBgColor,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: AppUtil.getCommonPadding(),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText("联系人"),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.left,
                        controller: nameEditingController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: AppConfig.font4),
                            hintText: "请输入联系人姓名",
                            border: InputBorder.none),
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText("联系电话"),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        textAlign: TextAlign.left,
                        controller: phoneEditingController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(color: AppConfig.font4),
                            hintText: "请输入联系方式",
                            border: InputBorder.none),
                      )),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText("地址"),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          textAlign: TextAlign.left,
                          controller: textEditingController,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: AppConfig.font4),
                              hintText: "请填写地址",
                              border: InputBorder.none),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: AppUtil.getCommonPadding(),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText("设为默认"),
                        const SizedBox(
                          width: 10,
                        ),
                        Switch(
                            value: isDefault,
                            onChanged: (v) {
                              setState(() {
                                isDefault = v;
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 200,
              child: MyButton(
                "确定",
                onTap: () {
                  confirm();
                },
              ))
        ])));
  }
}
