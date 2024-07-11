/// 用户实体类
class User {
  int? id;
  String? headimg;
  String? nickname;
  String? mobile;
  String? account;
  int? sex;
  String? signature;
  int? vip;
  String? money;
  String? tx_money;
  User();

  static User fromMap(Map<String, dynamic> map) {
    User user = User();
    user.headimg = map["headimg"];
    user.mobile = map["mobile"];
    user.id = map["id"];
    user.account = map["account"];
    user.sex = map["sex"];
    user.signature = map["signature"];
    user.nickname = map["nikeName"];
    user.money = map["money"];
    user.tx_money = map["tx_money"];
    user.vip = map["vip"];
    return user;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    return map;
  }
}
