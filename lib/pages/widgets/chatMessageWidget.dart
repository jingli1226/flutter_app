import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yigou/models/user.dart';
import 'package:yigou/pages/widgets/MyNetImage.dart';
import 'package:yigou/tools/AppUtil.dart';
import 'dart:convert' as convert;

class ChatMessageWidget extends StatelessWidget {
  final Map chatMessage;
  final User? mine;

  const ChatMessageWidget({Key? key, required this.chatMessage, this.mine})
      : super(key: key);

  void playAudio(item) async {
    var url = item["resource"];
    AudioPlayer audioPlayer = AudioPlayer();

    await audioPlayer.setSourceUrl(url);
  }

  void enterGame(item, context) {
    var url = item["resource"];

    Map<String, dynamic> reso = convert.jsonDecode(item["resource"]);
    var game =
        AppUtil.games.firstWhere((element) => reso["id"] == element["id"]);
    // String url = jsonEncode(Utf8Encoder().convert(game["mainfile"]));

    String gameUrl = Uri.encodeComponent(game["mainfile"]);
  }

  // 弹出底部菜单列表模态对话框
  Future<int?> _showModalBottomSheet(context) {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  String url = Uri.encodeComponent(
                      "https://www.xiaowanwu.cn/safe/jubao");
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    "举报",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                      child: const Text("取消"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var s = chatMessage["s"];
    var r = chatMessage["r"];
    var t = chatMessage["t"];
    var m = chatMessage["m"];
    var headimg = chatMessage["headimg"];

    var resource = chatMessage["resource"];
    Widget msgContent;
    if (t == "m") {
      // 漫画风格
      Map<String, dynamic> reso = convert.jsonDecode(resource);
      int width = reso["width"];
      int height = reso["height"];
      double tl = reso["tl"];
      double tt = reso["tt"];
      double tw = reso["tw"];
      double th = reso["th"];

      String url = reso["url"];

      double iw = MediaQuery.of(context).size.width - 80;
      double ih = iw * height / width;
      if (ih > MediaQuery.of(context).size.width * 0.7) {
        ih = MediaQuery.of(context).size.width * 0.7;
        iw = ih * width / height;
      }

      msgContent = CachedNetworkImage(
          imageUrl: AppUtil.getQiniuUrl(url, iw * 2, ih * 2),
          imageBuilder: (context, imageProvider) => Container(
                width: iw,
                height: ih,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        left: iw * tl,
                        top: ih * tt,
                        width: iw * tw,
                        height: ih * th,
                        child: Container(
                          // color: Colors.red,
                          alignment: Alignment.center,
                          child: Text(
                            m,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color(0xff000000), fontSize: 16),
                          ),
                        ))
                  ],
                ),
              ));
    } else if (t == "t") {
      msgContent = ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color:
              s == mine?.id ? const Color(0xff00ff00) : const Color(0xffddddff),
          padding: const EdgeInsets.all(10),
          child: Text(
            m,
            style: const TextStyle(color: Color(0xff000000), fontSize: 16),
          ),
        ),
      );
    } else if (t == "a") {
      Map<String, dynamic> reso = convert.jsonDecode(resource);
      String name = reso["name"];
      msgContent = ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color:
              s == mine?.id ? const Color(0xff00ff00) : const Color(0xffddddff),
          padding: const EdgeInsets.all(10),
          child: Text.rich(
            TextSpan(children: [
              const TextSpan(
                  text: "发送了 ",
                  style: TextStyle(color: Color(0xff000000), fontSize: 16)),
              TextSpan(
                  text: name,
                  style:
                      const TextStyle(color: Color(0xff8000ff), fontSize: 16)),
              const TextSpan(
                  text: " 动作",
                  style: TextStyle(color: Color(0xff000000), fontSize: 16)),
            ]),
            style: const TextStyle(color: Color(0xff000000), fontSize: 16),
          ),
        ),
      );
    } else if (t == "p") {
      Map<String, dynamic> reso = convert.jsonDecode(resource);
      int width = reso["width"];
      int height = reso["height"];
      double iw = MediaQuery.of(context).size.width * 0.5;
      double ih = iw * height / width;
      if (ih > MediaQuery.of(context).size.width * 0.7) {
        ih = MediaQuery.of(context).size.width * 0.7;
        iw = ih * width / height;
      }

      msgContent = SizedBox(
        width: iw,
        height: ih,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: MyNetImage(
            url: AppUtil.getQiniuUrl(reso["url"], iw * 2, ih * 2),
          ),
        ),
      );
    } else if (t == "gif") {
      Map<String, dynamic> reso = convert.jsonDecode(resource);
      int width = int.parse(reso["width"].toString());
      int height = int.parse(reso["height"].toString());
      double iw = MediaQuery.of(context).size.width * 0.9;
      double ih = iw * height / width;
      if (ih > 80) {
        ih = 80;
        iw = ih * width / height;
      }

      if (reso["url"] == null) {
        msgContent = Container();
      } else {
        msgContent = SizedBox(
          width: iw,
          height: ih,
          child: Image(image: AssetImage("images/biaoqing/" + reso["url"])),
        );
      }
    } else if (t == "sound") {
      msgContent = GestureDetector(
        onTap: () {
          playAudio(chatMessage);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff9999ee),
          ),
          width: 100,
          height: 40,
          child: Row(
            children: [
              const SizedBox(width: 10),
              const Icon(Icons.volume_down_alt),
              Text(
                chatMessage["desc"] + "s",
                style: const TextStyle(color: Color(0xff000000), fontSize: 16),
              )
            ],
          ),
        ),
      );
    } else if (t == "game") {
      Map<String, dynamic> reso = convert.jsonDecode(resource);

      msgContent = GestureDetector(
        onTap: () {
          enterGame(chatMessage, context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffeeeeff),
          ),
          width: 150,
          height: 120,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.games,
                    color: Color(0xffff7000),
                  ),
                  Text(
                    "游戏邀请",
                    style: TextStyle(
                        color: Color(0xffff7000),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 120,
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Text(
                      chatMessage["m"],
                      maxLines: 10,
                      style: const TextStyle(
                          color: Color(0xff000000), fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    } else {
      msgContent = Container();
    }
    var headimgContent = GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image(image: NetworkImage(headimg)),
        ),
      ),
    );

    Container content;
    if (s == mine?.id) {
      content = Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            msgContent,
            const SizedBox(
              width: 10,
            ),
            headimgContent,
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    } else {
      content = Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headimgContent,
            const SizedBox(width: 10),
            msgContent,
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                AppUtil.getTimeString(chatMessage["stime"], "创作"),
                style: const TextStyle(color: Color(0xff888888)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showModalBottomSheet(context);
            },
            child: content,
          )
        ],
      ),
    );
  }
}
