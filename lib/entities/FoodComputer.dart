import 'package:sqflite/sqflite.dart';

//sqlite string references
final String tableFoodComputer = 'foodcomputer';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnIp = 'ip';


class FoodComputer {
  int id;
  String title;
  String ip;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnIp: ip,
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  FoodComputer();

  FoodComputer.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    ip = map[columnIp];
  }
}

class FoodComputerProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableFoodComputer ( 
              $columnId integer primary key autoincrement, 
              $columnTitle text not null,
              $columnIp text not null
            )
            ''');
        });
  }

  Future<FoodComputer> insert(FoodComputer fc) async {
    fc.id = await db.insert(tableFoodComputer, fc.toMap());
    return fc;
  }

  Future<FoodComputer> getFoodComputer(int id) async {
    List<Map> maps = await db.query(tableFoodComputer,
        columns: [columnId, columnIp, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return FoodComputer.fromMap(maps.first);
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableFoodComputer, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(FoodComputer fc) async {
    return await db.update(tableFoodComputer, fc.toMap(), where: '$columnId = ?', whereArgs: [fc.id]);
  }

  Future close() async => db.close();
}