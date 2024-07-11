import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBUtil {
  static init() async {
    final Database database = await openDatabase(
        join(await getDatabasesPath(), 'goods2.db'), onCreate: (db, version) {
      db.execute(
        "CREATE TABLE USER(id INTEGER, username TEXT, password TEXT,birthday TEXT,name TEXT,type INTEGER,answers TEXT);",
      );
      return db.execute(
        "CREATE TABLE GOODS(id INTEGER, name TEXT, remark TEXT,price INTEGER,images TEXT,cate TEXT);",
      );
    }, version: 1);

    return database;
  }

  static Future<void> insert(Map<String, Object> map, Database db) async {
    // Get a reference to the database.

    // Insert the Node into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'USER',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> addGoods(Map<String, Object> map) async {
    // Get a reference to the database.
    final Database db = await init();
    // Insert the Node into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'GOODS',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> register(Map<String, Object> map) async {
    final Database db = await init();
    await db.insert(
      'USER',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map?> login(String username, String password) async {
    // Get a reference to the database.
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('USER',
        where: null, offset: 0, orderBy: null, limit: 100);

    if (maps.length == 0) {
      return null;
    }

    List list = List.generate(maps.length, (i) {
      var m = maps[i];
      return {
        "id": m["id"],
        "username": m["username"],
        "password": m["password"],
        "birthday": m["birthday"],
        "name": m["name"],
        "type": m["type"],
        "answers": m["answers"],
      };
    });

    try {
      Map? map = list.firstWhere((element) =>
          element["username"] == username && element["password"] == password);
      return map;
    } catch (e) {
      return null;
    }
  }

  static Future<List?> search() async {
    // Get a reference to the database.
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('USER',
        where: null, offset: 0, orderBy: null, limit: 100);

    List list = List.generate(maps.length, (i) {
      var m = maps[i];
      return {
        "id": m["id"],
        "username": m["username"],
        "password": m["password"],
        "birthday": m["birthday"],
        "name": m["name"],
        "type": m["type"],
        "answers": m["answers"],
      };
    });

    return list;
  }

  static Future<List> searchGoods() async {
    // Get a reference to the database.
    final Database db = await init();
    final List<Map<String, dynamic>> maps = await db.query('GOODS',
        where: null, offset: 0, orderBy: null, limit: 100);

    List list = List.generate(maps.length, (i) {
      var m = maps[i];
      return {
        "id": m["id"],
        "name": m["name"],
        "remark": m["remark"],
        "price": m["price"],
        "images": m["images"],
        "cate": m["cate"],
      };
    });

    return list;
  }

  static Future<int> update(String answers, String username) async {
    // Get a reference to the database.
    final Database db = await init();

    // Query the table for all The Dogs.
    final int v = await db.update(
      'USER',
      {"answers": answers},
      where: 'username = ?',
      whereArgs: [username],
    );
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return v;
  }

  static Future<int> updateUser(
      String birthday, String name, String username) async {
    // Get a reference to the database.
    final Database db = await init();

    // Query the table for all The Dogs.
    final int v = await db.update(
      'USER',
      {"birthday": birthday, "name": name},
      where: 'username = ?',
      whereArgs: [username],
    );
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return v;
  }
}
