import 'package:sqflite/sqflite.dart';

//sqlite string references
final String tableFoodComputerData = 'foodcomputerdata';
final String columnId = '_id';
final String columnFoodComputerId = "foodComputerId";
final String columnRecipeId = "recipeId";
final String columnCycle = "cycle";
final String columnTimestamp = "timestamp";
final String columnTemperature = "temperature";
final String columnPhLevel = "phLevel";
final String columnNutrientALevel = "nutrientALevel";
final String columnNutrientBLevel = "nutrientBLevel";
final String columnH2oLevel = "h2oLevel";
final String columnLightLevel = "lightLevel";

class FoodComputerData {
  int id;
  int foodComputerId;
  int recipeId;
  int cycle;
  int timestamp;
  double temperature;
  double phLevel;
  double nutrientALevel;
  double nutrientBLevel;
  double h2oLevel;
  double lightLevel;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnFoodComputerId: foodComputerId,
      columnRecipeId: recipeId,
      columnTimestamp: timestamp,
      columnCycle: cycle,
      columnPhLevel: phLevel,
      columnNutrientALevel: nutrientBLevel,
      columnNutrientBLevel: nutrientBLevel,
      columnH2oLevel: h2oLevel,
      columnLightLevel: lightLevel
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  FoodComputerData();

  FoodComputerData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    foodComputerId = map[columnFoodComputerId];
    recipeId = map[columnRecipeId];
    cycle = map[columnCycle];
    timestamp = map[columnTimestamp];
    temperature = map[columnTemperature];
    phLevel = map[columnPhLevel];
    nutrientALevel = map[columnNutrientALevel];
    nutrientBLevel = map[columnNutrientBLevel];
    h2oLevel = map[columnH2oLevel];
    lightLevel = map[columnLightLevel];
  }
}

class FoodComputerDataProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableFoodComputerData ( 
              $columnId integer primary key autoincrement, 
              $columnFoodComputerId integer,
              $columnRecipeId integer,
              $columnCycle text,
              $columnTimestamp integer,
              $columnTemperature real,
              $columnPhLevel real,
              $columnNutrientALevel real,
              $columnNutrientBLevel real,
              $columnH2oLevel real,
              $columnLightLevel real,
            )
            ''');
        });
  }

  Future<FoodComputerData> insert(FoodComputerData fcd) async {
    fcd.id = await db.insert(tableFoodComputerData, fcd.toMap());
    return fcd;
  }

  Future<FoodComputerData> getFoodComputerData(int id) async {
    List<Map> maps = await db.query(tableFoodComputerData,
        columns: [
          columnId,
          columnFoodComputerId,
          columnRecipeId,
          columnCycle,
          columnTimestamp,
          columnTemperature,
          columnPhLevel,
          columnNutrientALevel,
          columnNutrientBLevel,
          columnH2oLevel,
          columnLightLevel
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return FoodComputerData.fromMap(maps.first);
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableFoodComputerData, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(FoodComputerData fcd) async {
    return await db.update(tableFoodComputerData, fcd.toMap(), where: '$columnId = ?', whereArgs: [fcd.id]);
  }

  Future close() async => db.close();
}