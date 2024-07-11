// 用户实体类
class Session {
  int? id;
  //主键
  String? to_account;
  String? nickname;
  String? avatar;
  //发送人
  String? account;
  int? chattype;
  int? msg_type;
  //类型
  String? content;
  String? time;
  String? action;
  int? type; //0:好友 1:群
  int rank = 0; //排序 越大 越靠前
  bool darao = false; //打扰
  int? unread;
  Session(
      {this.id,
      this.to_account,
      this.account,
      this.chattype,
      this.content,
      this.time,
      this.nickname,
      this.type,
      this.action,
      this.msg_type,
      this.avatar,
      this.unread});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      'to_account': to_account,
      'account': account,
      'chattype': chattype,
      'content': content,
      'time': time,
      'avatar': avatar,
      'nickname': nickname,
      'type': type,
      "action": action,
      "msg_type": msg_type,
      "unread": unread
    };
    return map;
  }
}
