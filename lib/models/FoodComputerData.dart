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

  FoodComputerData();

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

  static Future create(Database db) async {
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
        $columnLightLevel real
      )
    ''');
  }
}