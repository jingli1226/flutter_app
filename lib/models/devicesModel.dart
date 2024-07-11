/// 设备实体类
class DevicesInfo {
  static String dataBaseTableName ="prod_devices";
  late int? id = 1;
  late String devicesName;
  late int devicesType;
  late int devicesState;
  late DateTime createTime;
  late bool? check;

  DevicesInfo(this.devicesName,this.devicesType,this.devicesState,this.createTime,{this.id});

  /// map 转实体
  DevicesInfo.fromMap(Map<String,dynamic> map){
    devicesName = map['devices_name'];
    devicesType = map['devices_type'];
    devicesState = map['devices_state'];
    createTime = DateTime.parse(map['create_time']);
    if (map['id'] != null) {
      id = map['id'];
    }
  }

  /// 转map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'devices_name': devicesName,
      'devices_type': devicesType,
      'devices_state': devicesState,
      'create_time': createTime.toString(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
