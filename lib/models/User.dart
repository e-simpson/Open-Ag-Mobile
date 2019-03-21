import 'package:sqflite/sqflite.dart';

//sqlite string references
final String tableUser = 'user';
final String columnId = '_id';
final String columnName = 'name';
final String columnEmail = 'email';


class User {
  int id;
  String name;
  String email;

  User();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnEmail: email,
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    email = map[columnEmail];
  }

  static Future create(Database db) async {
    await db.execute('''
     create table $tableUser ( 
        $columnId integer primary key autoincrement, 
        $columnName text,
        $columnEmail text
      )
    ''');
  }
}
