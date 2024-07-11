import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yigou/models/user.dart';
import 'package:yigou/pages/widgets/MyText.dart';
import 'package:yigou/tools/config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AppUtil {
  static List games = [];
  static User? user;

  static String? token;

  static String getUUID() {
    var uuid = const Uuid();
    return uuid.v1();
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Color toColor(String code) {
    if (code.isEmpty) {
      return const Color(0xff000000);
    }
    return Color(int.parse(code, radix: 16) + 0xFF000000);
  }

  static double getPadding() {
    return AppConfig.padding;
  }

  static getRandomImage() {
    List images = [
      "https://wx2.sinaimg.cn/mw690/006bkE4Cgy1hjov4rhcerj636c36ckjn02.jpg",
      "https://img0.baidu.com/it/u=1656670809,32120788&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=673",
      "https://p1.itc.cn/images01/20231110/080d84800e8e45c480c58ccd3ebbb9f6.jpeg",
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcbu01.alicdn.com%2Fimg%2Fibank%2FO1CN01mX9cgM1VO5GPRxomo_%21%212215963662642-0-cib.jpg&refer=http%3A%2F%2Fcbu01.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1702215179&t=5b746507bf7dadb9193c64405c2a67c0",
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fcbu01.alicdn.com%2Fimg%2Fibank%2FO1CN01ebSUX21xFfFu9oCBm_%21%212215541856414-0-cib.jpg&refer=http%3A%2F%2Fcbu01.alicdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1702215179&t=f77fcf9844c1ae52c2ba95196b7ae84b",
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2Fb7ad2d67-b02c-4543-a3be-f4e34452fb7a%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1702215208&t=abe96ff48c23937b24437344bddc7a1e"
    ];
    return images[Random().nextInt(images.length)];
  }

  static toJson(String s) {
    return jsonDecode(s);
  }

  /// fluro 传递中文参数前，先转换，fluro 不支持中文传递
  static String paramsEncode(String originalCn) {
    return jsonEncode(const Utf8Encoder().convert(originalCn));
  }

  /// fluro 传递后取出参数，解析
  static String paramsDecode(String encodeCn) {
    List<int> list = [];

    ///字符串解码
    for (var data in jsonDecode(encodeCn)) {
      list.add(data);
    }
    return const Utf8Decoder().convert(list);
  }

  static EdgeInsets getCommonPadding() {
    return EdgeInsets.fromLTRB(getPadding(), 10, getPadding(), 10);
  }

  static EdgeInsets getEdgeInsets(
      {double horizontal = 0, double vertically = 0}) {
    return EdgeInsets.fromLTRB(horizontal, vertically, horizontal, vertically);
  }

  static Future download(
    String url,
    String savePath, {
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    dynamic? data,
    Options? options,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Dio _dioInstance = Dio();
    try {
      return await _dioInstance.download(
        url,
        savePath,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        EasyLoading.showInfo('下载已取消！');
      } else {
        if (e.response != null) {
          // _handleErrorResponse(e.response);
        } else {
          EasyLoading.showError(e.message);
        }
      }
    } on Exception catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  // 解压缩zip文件，释放出csv文件
  static unZipFiles(file, name, void Function(String) onFinish) async {
    Directory documentsDir = (await getApplicationDocumentsDirectory());
    Directory desDir = Directory('${documentsDir.path}/' + name);
    if (!desDir.existsSync()) {
      Directory(desDir.path).create(recursive: true);
    }
    String zipFilePath = file;
    print("压缩文件路径zipFilePath = $zipFilePath");

    // 从磁盘读取Zip文件。
    List<int> bytes = File(zipFilePath).readAsBytesSync();
    // 解码Zip文件
    Archive archive = ZipDecoder().decodeBytes(bytes);

    // 将Zip存档的内容解压缩到磁盘。
    for (ArchiveFile file in archive) {
      if (file.isFile) {
        List<int> tempData = file.content;
        File f = File(desDir.path + "/" + file.name)
          ..createSync(recursive: true)
          ..writeAsBytesSync(tempData);
        print("解压后的文件路径 = ${f.path}");
        onFinish(f.path);
      } else {
        Directory(desDir.path + "/" + file.name).create(recursive: true);
      }
    }
    print("解压成功");
  }

  static String getQiniuUrl(String url, double imagewidth, double imageheight) {
    String imageurl = url +
        "?imageView/1/w/" +
        imagewidth.toInt().toString() +
        "/h/" +
        imageheight.toInt().toString();
    return imageurl;
  }

  static String getMsgType(int type) {
    String typeText = "";
    if (type == 5) {
      typeText = "点赞了您";
    } else if (type == 6) {
      typeText = "评论了您";
    }
    return typeText;
  }

  static String getTimeString(String date, String end) {
    if (date.isEmpty) {
      return "";
    }
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();
    int nowTime = now.millisecondsSinceEpoch;
    int timestamp = dateTime.millisecondsSinceEpoch;
    int dis = nowTime - timestamp;
    if (dis < 30 * 60 * 1000) {
      return "刚刚" + end;
    } else if (dis > 30 * 60 * 1000 && dis < 60 * 60 * 1000) {
      return "半小时前" + end;
    } else if (dis > 60 * 60 * 1000 && dis < 24 * 60 * 60 * 1000) {
      int h = dis ~/ (60 * 60 * 1000);
      return h.toString() + "小时前" + end;
    } else if (dis > 24 * 60 * 60 * 1000 && dis < 5 * 24 * 60 * 60 * 1000) {
      int d = dis ~/ (24 * 60 * 60 * 1000);
      return d.toString() + "天前" + end;
    }
    return DateFormat('MM-dd HH:mm').format(dateTime) + end;
  }

  static String formateTime() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  static String formateTimeByTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String geIntTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String end = "";
    DateTime now = DateTime.now();
    int nowTime = now.millisecondsSinceEpoch;
    int timestamp = dateTime.millisecondsSinceEpoch;
    int dis = nowTime - timestamp;
    if (dis < 30 * 60 * 1000) {
      return "刚刚" + end;
    } else if (dis > 30 * 60 * 1000 && dis < 60 * 60 * 1000) {
      return "半小时前" + end;
    } else if (dis > 60 * 60 * 1000 && dis < 24 * 60 * 60 * 1000) {
      int h = dis ~/ (60 * 60 * 1000);
      return h.toString() + "小时前" + end;
    } else if (dis > 24 * 60 * 60 * 1000 && dis < 5 * 24 * 60 * 60 * 1000) {
      int d = dis ~/ (24 * 60 * 60 * 1000);
      return d.toString() + "天前" + end;
    }
    return DateFormat('MM-dd HH:mm').format(dateTime) + end;
  }

  static void showConfirm(BuildContext context,
      {Function? onCancel,
      Function? onConfirm,
      String title = "",
      String cancelText = "取消",
      String confirmText = "确认"}) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            title,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: MyText(
                cancelText,
                color: AppConfig.font1,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) {
                  onCancel();
                }
              }, // 关闭对话框
            ),
            TextButton(
              child: MyText(
                confirmText,
                color: AppConfig.font1,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static getTo(Widget widget) {
    Get.to(widget, transition: Transition.cupertino);
  }

  static replace(Widget widget) {
    Get.offAll(widget);
  }

  static back() {
    Get.back();
  }

  static refreshUser() async {
    // var res = await ApiService.userinfo();
    // await StorageUtil.saveUser(res);
    // EasyLoading.dismiss();
    // AppUtil.user = await StorageUtil.getUser();
  }

  static copy(String data) {
    if (data != '') {
      Clipboard.setData(ClipboardData(text: data));
    }
    EasyLoading.showSuccess("复制成功");
  }
}
