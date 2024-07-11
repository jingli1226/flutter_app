/// 形象
class Figure3D {
  //主键
  int? id;
  String url = "";
  String name = "";
  String createtime = "";
  String createid = "";
  int usenum = 0;
  String image = "";
  Map toMap() {
    Map map = {
      'id': id,
      'url': url,
      'name': name,
      'createtime': createtime,
      'createid': createid,
      'usenum': 0,
      'image': image
    };
    return map;
  }

  static List toList(List array) {
    List<Figure3D> list = [];
    for (int i = 0; i < array.length; i++) {
      Map item = array[i];
      Figure3D figure3d = toFigure3D(item);
      list.add(figure3d);
    }
    return list;
  }

  static Figure3D toFigure3D(Map map) {
    Figure3D figure3d = Figure3D();
    figure3d.url = map["url"];
    figure3d.createtime = map["createtime"];

    figure3d.createid = map["createid"];
    figure3d.usenum = map["usenum"];
    figure3d.name = map["name"];
    figure3d.id = map["id"];
    figure3d.image = map["image"];

    return figure3d;
  }
}
