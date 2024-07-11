import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:yigou/pages/widgets/MyButton.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'package:yigou/tools/DBUtil.dart';
import 'package:permission_handler/permission_handler.dart';

class DeployPage extends StatefulWidget {
  String? title;
  int? outerid;
  String? url;
  int? width;
  int? height;
  int? type; //资源类型,0:图片 1:视频
  Function? onSave;
  DeployPage(
      {Key? key,
      this.title,
      this.outerid,
      this.url,
      this.type,
      this.width,
      this.height,
      this.onSave})
      : super(key: key);

  @override
  _DeployPageState createState() => _DeployPageState();
}

class _DeployPageState extends State<DeployPage> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ownerController = TextEditingController();

  final picker = ImagePicker();
  // List<File> images = [];
  File? file;
  late VideoPlayerController videoPlayerController;
  String? goodsImage;
  XFile? pickedFile;
  String? cate;

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _nameController.text = widget.title!;
    }
  }

  String timeFormat(String time) {
    DateTime nowTime = DateTime.parse(time);
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(nowTime);
  }

  void add() async {
    if (_nameController.text.isEmpty) {
      EasyLoading.showToast("请输入商品名称");
      return;
    }

    if (cate == null) {
      EasyLoading.showToast("请选择分类");
      return;
    }

    if (_remarkController.text.isEmpty) {
      EasyLoading.showToast("请输入商品描述");
      return;
    }

    if (_priceController.text.isEmpty) {
      EasyLoading.showToast("请输入商品价格");
      return;
    }

    if (file == null && widget.url == null) {
      EasyLoading.showToast("请选择图片");
      return;
    }

    await DBUtil.addGoods({
      "name": _nameController.text,
      "remark": _remarkController.text,
      "price": int.parse(_priceController.text),
      "images": file!.path,
      "cate": cate!
    });

    EasyLoading.showSuccess("发布成功");
    AppUtil.back();
    widget.onSave!();
  }

  void chooseImage() async {
    // 1、读取系统权限的弹框
    PermissionStatus status = await Permission.mediaLibrary.request();
    if (status.isDenied) {
      EasyLoading.showError("请去设置中心开启访问相册权限");
      return;
    }

    pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      goodsImage = pickedFile!.path;

      setState(() {
        file = File(pickedFile!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText("发布商品"),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10),
            child: MyButton(
              "发布",
              width: 80,
              height: 36,
              fontSize: 14,
              onTap: () {
                add();
              },
            ),
          )
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(245, 245, 245, 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                        value: "服装",
                        groupValue: cate,
                        onChanged: (v) {
                          setState(() {
                            cate = v as String;
                          });
                        }),
                    MyText("服装"),
                    Radio(
                        value: "鞋子",
                        groupValue: cate,
                        onChanged: (v) {
                          setState(() {
                            cate = v as String;
                          });
                        }),
                    MyText("鞋子"),
                    Radio(
                        value: "生活",
                        groupValue: cate,
                        onChanged: (v) {
                          setState(() {
                            cate = v as String;
                          });
                        }),
                    MyText("生活"),
                    Radio(
                        value: "数码",
                        groupValue: cate,
                        onChanged: (v) {
                          setState(() {
                            cate = v as String;
                          });
                        }),
                    MyText("数码")
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: MyText("商品名称"),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: TextField(
                  maxLines: 1,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "请输入商品名称",
                    hintStyle: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(200, 200, 200, 1)),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  controller: _nameController,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: MyText("商品描述"),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: TextField(
                  maxLines: 1,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "请输入商品描述",
                    hintStyle: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(200, 200, 200, 1)),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  controller: _remarkController,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: MyText("商品价格"),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: TextField(
                  maxLines: 1,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "请输入商品价格",
                    hintStyle: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(200, 200, 200, 1)),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  controller: _priceController,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: MyText("商品图片"),
              ),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          chooseImage();
                        },
                        child: file == null
                            ? (widget.url == null
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Color.fromRGBO(200, 200, 200, 1),
                                      size: 60,
                                    ),
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        widget.url!,
                                      ),
                                    ),
                                  ))
                            : Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Image.file(file!)),
                              ),
                      ),
                      // ...images
                      //     .map((e) => )
                      //     .toList()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
