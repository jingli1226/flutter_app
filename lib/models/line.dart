import 'package:yigou/models/point.dart';

/// 用户实体类
class Line {
  //主键
  List points = [];
  List? lines; // 如果存在说明是一个组
  int duichengIndex = -1;
  bool closed = true;
  String strokeColor = "";
  String fillColor = "";
  String type = ""; // 空的代表普通的,c:圆,t:椭圆

  Map toMap() {
    List ps = [];
    Map map = {
      'p': ps,
      'c': closed ? 1 : 0,
      's': strokeColor,
      'f': fillColor,
      "dc": duichengIndex
    };
    if (lines != null && lines!.length != 0) {
      map["lines"] = [];
      for (int i = 0; i < lines!.length; i++) {
        Line line = lines![i];
        map["lines"].add(line.toMap());
      }
    }
    for (int i = 0; i < points.length; i++) {
      Point p = points[i];
      ps.add({'x': p.x, 'y': p.y});
    }
    return map;
  }

  static List toMapList(List lines) {
    List list = [];
    for (int i = 0; i < lines.length; i++) {
      Line line = lines[i];
      Map map = line.toMap();
      list.add(map);
    }
    return list;
  }

  // 克隆
  static List<Line> clone(List lines) {
    List<Line> list = [];
    for (int i = 0; i < lines.length; i++) {
      Line l = lines[i];
      Line line = Line.toLine(l.toMap());
      list.add(line);
    }
    return list;
  }

  static List toLines(List array) {
    List<Line> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      Line line = toLine(item);
      list.add(line);
    }
    return list;
  }

  static Line toLine(Map map) {
    Line line = Line();
    List points = [];
    line.points = points;
    line.closed = map["closed"] == 1;
    line.strokeColor = map["s"];
    line.fillColor = map["f"];
    if (map.containsKey("dc")) {
      line.duichengIndex = map["dc"];
    }
    List ps = map["p"];
    for (int i = 0; i < ps.length; i++) {
      Map p = ps[i];
      double x = p["x"];
      double y = p["y"];
      Point point = Point(x, y);
      points.add(point);
    }
    return line;
  }
}
