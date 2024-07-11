import 'dart:convert';

import 'package:yigou/models/line.dart';

/// 形象
class Figure {
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
    List<Figure> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      Figure figure = toFigure(item);
      list.add(figure);
    }
    return list;
  }

  static Figure toFigure(Map map) {
    Figure figure = Figure();
    figure.lines = Line.toLines(jsonDecode(map["url"]));
    figure.createtime = map["createtime"];

    figure.createid = map["createid"];
    figure.usenum = map["usenum"];
    figure.name = map["name"];
    figure.id = map["id"];

    return figure;
  }
}
