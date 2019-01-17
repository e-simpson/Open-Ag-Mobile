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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnEmail: email,
    };
    if (id != null) map[columnId] = id;
    return map;
  }

//  FoodComputer();

  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    email = map[columnEmail];
  }
}

class UserProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableUser ( 
              $columnId integer primary key autoincrement, 
              $columnName text,
              $columnEmail text
            )
            ''');
        });
  }

  Future<User> insert(User u) async {
    u.id = await db.insert(tableUser, u.toMap());
    return u;
  }

  Future<User> getFoodComputer(int id) async {
    List<Map> maps = await db.query(tableUser,
        columns: [columnId, columnName, columnEmail],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return User.fromMap(maps.first);
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User u) async {
    return await db.update(tableUser, u.toMap(), where: '$columnId = ?', whereArgs: [u.id]);
  }

  Future close() async => db.close();
}