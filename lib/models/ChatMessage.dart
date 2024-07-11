import 'package:flutter/material.dart';

/// 用户实体类
class ChatMessage {
  String? id;
  //主键
  String? to_account;
  //发送人
  String? from_account;
  String? from_nickname;
  String? from_avatar;
  int? msg_type; //1、文本消息 2、图片 3、语音 4、红包 5、系统消息 6、名片 7:视频
  String? groupName;
  String? groupAccount;
  String? groupAvatar;
  int? userid;
  GlobalKey? key;

  //接受人
  int? chattype;

  //类型
  String? content;
  Map? sendRed;
  String? time;
  String? red;
  String? action;
  int? type; // 0:好友 1:群
  int? read = 0;
  ChatMessage(
      {this.id,
      this.to_account,
      this.from_account,
      this.chattype,
      this.content,
      this.time,
      this.from_nickname,
      this.type,
      this.action,
      this.msg_type,
      this.read = 0,
      this.from_avatar});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      'to_account': to_account,
      'from_account': from_account,
      'chattype': chattype,
      'content': content,
      'time': time,
      "msg_type": msg_type,
      "red": red,
      "type": type,
      'from_nickname': from_nickname,
      'from_avatar': from_avatar,
      'read': read,
    };
    return map;
  }

  Map<String, dynamic> toChatMap() {
    Map data = {
      'to_account': to_account,
      'from_account': from_account,
      'chattype': chattype,
    };
    if (action == "reward") {
      data["red"] = sendRed;
    } else if (action == "card") {
      data["userid"] = userid;
      data["content"] = content;
    } else {
      data["content"] = content;
    }
    Map<String, dynamic> map = {"action": action, "data": data};
    return map;
  }
}
