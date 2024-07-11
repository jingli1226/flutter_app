import 'dart:convert';

import 'package:yigou/models/line.dart';
import 'package:yigou/models/point.dart';

/// 形象
class Sucai {
  //主键
  int? id;
  List lines = [];
  String name = "";
  String createtime = "";
  String createid = "";
  int usenum = 0;
  Map toMap() {
    List ps = [];
    // Map map = {'p': ps, 'c': closed?1:0, 's': strokeColor, 'f': fillColor};
    // for (int i = 0; i < points.length; i++) {
    //   Point p = points[i];
    //   ps.add({'x': p.x, 'y': p.y});
    // }
    return {};
  }

  static List toList(List array) {
    List<Sucai> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      Sucai sucai = toSucai(item);
      list.add(sucai);
    }
    return list;
  }

  static Sucai toSucai(Map map) {
    Sucai sucai = Sucai();
    sucai.lines = Line.toLines(jsonDecode(map["url"]));
    sucai.createtime = map["createtime"];
    sucai.createid = map["createid"];
    sucai.usenum = map["usenum"];
    sucai.name = map["name"];
    sucai.id = map["id"];

    return sucai;
  }
}
