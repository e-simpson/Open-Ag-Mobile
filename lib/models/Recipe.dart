import 'package:sqflite/sqflite.dart';

//sqlite string references
final String tableUser = 'recipe';
final String columnId = '_id';
final String columnCreatorUserId = 'creatorUserId';
final String columnTimestamp = 'timestamp';
final String columnName = 'name';
final String columnRecipe = 'recipe';
final String columnImagePath = 'imagePath';

class Recipe {
  int id;
  int creatorUserId;
  int timestamp;
  String name;
  String recipe;
  String imagePath;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCreatorUserId: creatorUserId,
      columnTimestamp: timestamp,
      columnName: name,
      columnRecipe: recipe,
      columnImagePath: imagePath
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
    imagePath = map[columnImagePath];
  }

  static Future create(Database db) async {
    await db.execute('''
      create table $tableUser ( 
        $columnId integer primary key autoincrement, 
        $columnCreatorUserId integer,
        $columnTimestamp integer,
        $columnName text not null,
        $columnRecipe text not null,
        $columnImagePath text
      )
    ''');
  }
}


class RecipeEnvironment {
  String name;
  List<LightSpectrumNmPercent> lightLevels;
  int lightPpfdUmolM2S;
  int lightIlluminationDistanceCm;
  int airTemperatureCelsius;

  RecipeEnvironment(){
    lightLevels = List<LightSpectrumNmPercent>();
    lightLevels.add(LightSpectrumNmPercent(380, 399));
    lightLevels.add(LightSpectrumNmPercent(400, 499));
    lightLevels.add(LightSpectrumNmPercent(500, 599));
    lightLevels.add(LightSpectrumNmPercent(600, 700));
    lightLevels.add(LightSpectrumNmPercent(701, 780));
  }
}

class LightSpectrumNmPercent {
  int min;
  int max;
  double value;

  LightSpectrumNmPercent(int min, int max){
    min = min; max = max; value = 0.0;
  }
}

class RecipePhase {
  String name;
  int repeat;
  List<RecipePhaseCycle> cycles;

  RecipePhase(){
    cycles = List<RecipePhaseCycle>();
  }
}

class RecipePhaseCycle {
  String name;
  RecipeEnvironment environment;
  int durationHours;
}