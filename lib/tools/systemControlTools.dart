import 'package:intl/intl.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void deployGrowthRecipe(SharedPreferences prefs, int recipeId, List<RecipePhase> phases) {
  prefs.setInt(activeRecipeIdPreference, recipeId);
  DateTime d = DateTime.now();
  prefs.setString(activeRecipeStartDatePreference, DateFormat("MMMM d, yyyy h:mm a").format(d));
  int days = 0;
  for (RecipePhase p in phases) days+= p.repeat;
  prefs.setInt(activeRecipeDayCountPreference, days);
  d = d.add(Duration(days: days));
  prefs.setString(activeRecipeDueDatePreference, DateFormat("MMMM d, yyyy").format(d));
}

Future removeRecipe(SharedPreferences prefs) async {
  await prefs.remove(activeRecipeIdPreference);
  await prefs.remove(activeRecipeStartDatePreference);
  await prefs.remove(activeRecipeDueDatePreference);
  await prefs.remove(activeRecipeDayCountPreference);
}

Future removeFoodComputer(SharedPreferences prefs, DatabaseProvider dbp, int id) async {
  await removeRecipe(prefs);
  dbp.deleteFoodComputer(id);
  await prefs.remove(foodComputerIdPreference);
  await prefs.remove(foodComputerNamePreference);
}