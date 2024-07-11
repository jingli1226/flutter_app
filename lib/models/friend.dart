/// 用户实体类
class Friend {
  String? id;
  String? avatar;
  String? nickname;
  String? tel;
  String? account;
  int? sex;
  String? signature;
  String? shownickname;
  int? vip;
  int? d_userid;
  int type = 0;
  Friend();

  static Friend fromMap(Map<String, dynamic> map) {
    Friend friend = Friend();
    friend.avatar = map["avatar"];
    friend.tel = map["tel"];
    friend.account = map["account"];
    friend.sex = map["sex"];
    friend.signature = map["signature"];
    friend.nickname = map["nickname"];
    friend.shownickname = map["shownickname"];
    friend.d_userid = map["d_userid"];

    return friend;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    return map;
  }
}
