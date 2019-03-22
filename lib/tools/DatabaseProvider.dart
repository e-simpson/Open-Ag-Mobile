import 'dart:async';
import 'dart:io';
import 'package:open_ag_mobile/models/FoodComputer.dart';
import 'package:open_ag_mobile/models/FoodComputerData.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/models/User.dart';
import 'package:open_ag_mobile/tools/prebuiltRecipes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//user
final String tableUser = 'user';
final String columnId = '_id';
final String columnName = 'name';
final String columnEmail = 'email';

//food computer
final String tableFoodComputer = 'foodcomputer';
//final String columnId = '_id';
final String columnTitle = 'title';
final String columnIp = 'ip';

//recipe
final String tableRecipe = 'recipe';
//final String columnId = '_id';
final String columnCreatorUserId = 'creatorUserId';
//final String columnTimestamp = 'timestamp';
//final String columnName = 'name';
final String columnRecipe = 'recipe';
final String columnImagePath = 'imagePath';

//food computer data
final String tableFoodComputerData = 'foodcomputerdata';
//final String columnId = '_id';
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



class DatabaseProvider {
  Database db;

  Future open() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "database.db");
    db = await openDatabase(dbPath, version: 1, onCreate: (db, v) async {
      this.db = db;
      await FoodComputer.create(db);
      await Recipe.create(db);
      await User.create(db);
      await FoodComputerData.create(db);
      await populatePreBuiltRecipes(this);
    });
  }

  Future close() async => db.close();

  //food computer
  Future<FoodComputer> upsertFoodComputer(FoodComputer fc) async {
    if (fc.id == null) fc.id = await db.insert(tableFoodComputer, fc.toMap());
    else await db.update(tableFoodComputer, fc.toMap(), where: "id = ?", whereArgs: [fc.id]);
    return fc;
  }
  Future<FoodComputer> fetchAFoodComputer() async {
    List<Map> maps = await db.query(tableFoodComputer,
        columns: [columnId, columnIp, columnTitle]);
    if (maps.length > 0) return FoodComputer.fromMap(maps.first);
    return null;
  }
  Future<FoodComputer> fetchFoodComputer(int id) async {
    List<Map> maps = await db.query(tableFoodComputer,
        columns: [columnId, columnIp, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return FoodComputer.fromMap(maps.first);
    return null;
  }
  Future<int> deleteFoodComputer(int id) async {
    return await db.delete(tableFoodComputer, where: '$columnId = ?', whereArgs: [id]);
  }

  //food computer data
  Future<FoodComputerData> upsertFoodComputerData(FoodComputerData fcd) async {
    if (fcd.id == null) fcd.id = await db.insert(tableFoodComputerData, fcd.toMap());
    else await db.update(tableFoodComputerData, fcd.toMap(), where: "id = ?", whereArgs: [fcd.id]);
    return fcd;
  }
  Future<FoodComputerData> fetchFoodComputerData(int id) async {
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
  Future<int> deleteFoodComputerData(int id) async {
    return await db.delete(tableFoodComputerData, where: '$columnId = ?', whereArgs: [id]);
  }

  //recipe
  Future<Recipe> upsertRecipe(Recipe r) async {
    if (r.id == null) r.id = await db.insert(tableRecipe, r.toMap());
    else await db.update(tableRecipe, r.toMap(), where: '$columnId = ?', whereArgs: [r.id]);
    return r;
  }
  Future<List<Recipe>> fetchAllRecipes() async {
    List<Map> maps = await db.query(tableRecipe, columns: [columnId, columnName, columnCreatorUserId, columnTimestamp, columnRecipe, columnImagePath]);
    List<Recipe> recipes = List<Recipe>();
    for (Map m in maps) recipes.add(Recipe.fromMap(m));
    return recipes;
  }
  Future<Recipe> fetchRecipe(int id) async {
    List<Map> maps = await db.query(tableRecipe,
        columns: [columnId, columnName, columnCreatorUserId, columnTimestamp, columnRecipe, columnImagePath],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return Recipe.fromMap(maps.first);
    return null;
  }
  Future<int> deleteRecipe(int id) async {
    return await db.delete(tableRecipe, where: '$columnId = ?', whereArgs: [id]);
  }

  //user
  Future<User> upsertUser(User user) async {
//    var count = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $tableUser WHERE $columnId = ?", [user.id]));
    if (user.id == null) user.id = await db.insert(tableUser, user.toMap());
    else await db.update(tableUser, user.toMap(), where: "id = ?", whereArgs: [user.id]);
    return user;
  }
  Future<User> fetchUser(int id) async {
    List<Map> maps = await db.query(tableUser,
        columns: [columnId, columnName, columnEmail],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) return User.fromMap(maps.first);
    return null;
  }
  Future<User> fetchUserByEmail(String email) async {
    List<Map> maps = await db.query(tableUser,
        columns: [columnId, columnName, columnEmail],
        where: '$columnEmail = ?',
        whereArgs: [email]
    );
    if (maps.length > 0) return User.fromMap(maps.first);
    return null;
  }
  Future<int> deleteUser(int id) async {
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }


}