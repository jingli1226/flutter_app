import 'package:yigou/models/line.dart';

/// 动画关键帧
class AnimateKeyframe {
  //主键
  List lines = [];
  // 另一个对象的动画类型
  int otherAnimateType = 0;
  //时间 毫秒
  int time = 0;
  String strokeColor = "";
  String fillColor = "";
  Map toMap() {
    List ps = [];
    Map map = {'l': ps, 't': time, 'o': otherAnimateType};
    for (int i = 0; i < lines.length; i++) {
      Line l = lines[i];
      ps.add(l.toMap());
    }
    return map;
  }

  static List<AnimateKeyframe> toAnimateKeyframes(List array) {
    List<AnimateKeyframe> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      AnimateKeyframe key = toAnimateKeyframe(item);
      list.add(key);
    }
    return list;
  }

  static AnimateKeyframe toAnimateKeyframe(Map map) {
    AnimateKeyframe animateKeyframe = AnimateKeyframe();
    animateKeyframe.time = map["t"];
    animateKeyframe.otherAnimateType = map["o"];
    List lines = [];
    List ls = map["l"];
    animateKeyframe.lines = lines;
    for (int i = 0; i < ls.length; i++) {
      Map l = ls[i];
      lines.add(Line.toLine(l));
    }
    return animateKeyframe;
  }
}
