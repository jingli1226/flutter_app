import 'dart:convert';

import 'package:yigou/models/animateKeyframe.dart';

/// 形象动作
class FigureAction {
  //主键
  int? id;
  List<AnimateKeyframe> keyframes = [];
  String name = "";
  String createtime = "";
  String createid = "";
  int figureid = 0;
  int usenum = 0;
  int loop = 1;
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
    List<FigureAction> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      FigureAction figure = toFigureAction(item);
      list.add(figure);
    }
    return list;
  }

  static FigureAction toFigureAction(Map map) {
    FigureAction figure = FigureAction();
    figure.keyframes =
        AnimateKeyframe.toAnimateKeyframes(jsonDecode(map["url"]));
    figure.createtime = map["createtime"];
    figure.createid = map["createid"];
    figure.usenum = map["usenum"];
    figure.name = map["name"];
    figure.id = map["id"];
    if (map.containsKey("loopvalue") && map["loopvalue"] != null) {
      figure.loop = map["loopvalue"];
    }

    figure.figureid = map["figureid"];
    return figure;
  }

  int getTotalTime() {
    int totalTime = 0;
    for (int i = 0; i < keyframes.length; i++) {
      AnimateKeyframe animateKeyframe = keyframes[i];
      totalTime = totalTime + animateKeyframe.time;
    }
    return totalTime;
  }
}
