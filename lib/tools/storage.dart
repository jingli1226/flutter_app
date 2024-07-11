import 'package:yigou/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class StorageUtil {
  static saveUser(Map map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", convert.jsonEncode(map));
  }

  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static saveGamesDownload(Map map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("games_download", convert.jsonEncode(map));
  }

  static getGamesDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("games_download");
    if (userJson != null && userJson.isNotEmpty) {
      Map<String, dynamic> map = convert.jsonDecode(userJson);
      return map;
    }
    return {};
  }

  static saveAddressList(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("addressList", convert.jsonEncode(list));
  }

  static getAddressList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("addressList");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveOrders(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("orders4", convert.jsonEncode(list));
  }

  static getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("orders4");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveComments(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("comments", convert.jsonEncode(list));
  }

  static getComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("comments");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveMessageLatests(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("messageLatests", convert.jsonEncode(list));
  }

  static getMessageLatests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("messageLatests");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveCart(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cart3", convert.jsonEncode(list));
  }

  static getCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("cart3");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveFavs(List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("favs", convert.jsonEncode(list));
  }

  static getFavs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("favs");
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveChatmessages(String? outerid, List list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("chat_" + outerid.toString(), convert.jsonEncode(list));
  }

  static getChatmessages(String? outerid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("chat_" + outerid.toString());
    if (userJson != null && userJson.isNotEmpty) {
      List list = convert.jsonDecode(userJson);
      return list;
    }
    return [];
  }

  static saveUsersFigureActions(String? outerid, Map? map) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "UsersFigureActions_" + outerid.toString(), convert.jsonEncode(map));
  }

  static getUsersFigureActions(String? outerid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson =
        prefs.getString("UsersFigureActions_" + outerid.toString());
    if (userJson != null && userJson.isNotEmpty) {
      Map map = convert.jsonDecode(userJson);
      return map;
    }
    return null;
  }

  static clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }

  static getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString("user");
    if (userJson != null && userJson.isNotEmpty) {
      Map<String, dynamic> userMap = convert.jsonDecode(userJson);
      User user = User.fromMap(userMap);
      return user;
      // user = new User();
      // user.id = userMap['id'];
      // user.mobile = userMap['mobile'];
      // user.nickname = userMap['nickname'];
      // user.headimg = userMap['headimg'];
      // if(userMap['gold']!=null){
      //   user.gold = userMap['gold'];
      //   user.diamond = userMap['diamond'];
      // }
      // return user;
    }
    return null;
  }
}
