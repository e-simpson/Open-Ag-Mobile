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

  FoodComputer();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnIp: ip,
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  FoodComputer.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    ip = map[columnIp];
  }

  static Future create(Database db) async {
    await db.execute('''
      create table $tableFoodComputer ( 
       $columnId integer primary key autoincrement, 
       $columnTitle text not null,
       $columnIp text not null
      )
    ''');
  }
}