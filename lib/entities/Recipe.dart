import 'package:sqflite/sqflite.dart';

//sqlite string references
final String tableUser = 'user';
final String columnId = '_id';
final String columnCreatorUserId = 'creatorUserId';
final String columnTimestamp = 'timestamp';
final String columnName = 'name';
final String columnRecipe = 'recipe';

class Recipe {
  int id;
  int creatorUserId;
  int timestamp;
  String name;
  String recipe;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCreatorUserId: creatorUserId,
      columnTimestamp: timestamp,
      columnName: name,
      columnRecipe: recipe
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  Recipe();

  Recipe.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    creatorUserId = map[columnCreatorUserId];
    timestamp = map[columnTimestamp];
    name = map[columnName];
    recipe = map[columnRecipe];
  }
}

class RecipeProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableUser ( 
              $columnId integer primary key autoincrement, 
              $columnCreatorUserId integer not null,
              $columnTimestamp integer not null,
              $columnName text not null,
              $columnRecipe text not null
            )
            ''');
        });
  }

  Future<Recipe> insert(Recipe r) async {
    r.id = await db.insert(tableUser, r.toMap());
    return r;
  }

  Future<Recipe> getFoodComputer(int id) async {
    List<Map> maps = await db.query(tableUser,
        columns: [columnId, columnCreatorUserId, columnTimestamp, columnRecipe],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return Recipe.fromMap(maps.first);
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Recipe r) async {
    return await db.update(tableUser, r.toMap(), where: '$columnId = ?', whereArgs: [r.id]);
  }

  Future close() async => db.close();
}