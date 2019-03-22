import 'dart:convert';

import 'package:open_ag_mobile/models/Recipe.dart';

//Object o = {
//  "format": "openag-phased-environment-v1",
//  "version": "1",
//  "creation_timestamp_utc": "2018-03-30T16:45:41Z",
//  "name": "If Looks Could Kale",
//  "uuid": "1ef23d6a-575e-4892-a6f9-7e62631fd34f",
//  "parent_recipe_uuid": null,
//  "support_recipe_uuids": null,
//  "description": {
//    "brief": "Provides white lighting conditions for 12 hours.",
//    "verbose": "Sets a homogoneous spectrum at 100 Watts"
//  },
//  "authors": [
//    {
//      "name": "Jake Rye",
//      "email": "jrye@mit.edu",
//    },
//  ],
//  "cultivation_methods": [
//    {
//      "name": "Shallow Water Culture",
//      "uuid": "30cbbded-07a7-4c49-a47b-e34fc99eefd0"
//    }
//  ],
//  "environments": {
//    "standard_day": {
//      "name": "Standard Day",
//      "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
//      "light_ppfd_umol_m2_s": 800,
//      "light_illumination_distance_cm": 10,
//      "air_temperature_celsius": 22
//    },
//    "standard_night": {
//      "name": "Standard Night",
//      "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
//      "light_ppfd_umol_m2_s": 0,
//      "light_illumination_distance_cm": 10,
//      "air_temperature_celsius": 18
//    },
//    "cold_day": {
//      "name": "Cold Day",
//      "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
//      "light_ppfd_umol_m2_s": 800,
//      "light_illumination_distance_cm": 10,
//      "air_temperature_celsius": 10
//    },
//    "frost_night": {
//      "name": "Frost Night",
//      "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
//      "light_ppfd_umol_m2_s": 0,
//      "light_illumination_distance_cm": 10,
//      "air_temperature_celsius": 2
//    }
//  },
//  "phases": [
//    {
//      "name": "Standard Growth",
//      "repeat": 29,
//      "cycles": [
//        {
//          "name": "Day",
//          "environment": "standard_day",
//          "duration_hours": 18
//        },
//        {
//          "name": "Night",
//          "environment": "standard_night",
//          "duration_hours": 6
//        }
//      ]
//    },
//    {
//      "name": "Frosty Growth",
//      "repeat": 1,
//      "cycles": [
//        {
//          "name": "Day",
//          "environment": "cold_day",
//          "duration_hours": 18
//        },
//        {
//          "name": "Night",
//          "environment": "frost_night",
//          "duration_hours": 6
//        }
//      ]
//
//    }
//  ]
//};

String generateRecipeJSON(List<RecipePhase> phases, String name, String author, String email, DateTime timestamp){
  Map<String, dynamic> recipe = Map<String, dynamic>();
  recipe.putIfAbsent("format", () {return "openag-phased-environment-v1";});
  recipe.putIfAbsent("version", () {return 1;});
  recipe.putIfAbsent("creation_timestamp_utc", () {return timestamp.toUtc().toString();});
  recipe.putIfAbsent("name", () {return name;});
  recipe.putIfAbsent("authors", () {return [{"name": author, "email": email}];});
  recipe.putIfAbsent("cultivation_methods", () {return [{"name": "Shallow Water Culture", "uuid": "30cbbded-07a7-4c49-a47b-e34fc99eefd0"}];});

  Map<String, dynamic> environmentsMap = Map<String, dynamic>();
  List<Map<String, dynamic>> phasesMap = List<Map<String, dynamic>>();

  for (RecipePhase p in phases) {
    Map<String, dynamic> phaseMap = Map<String, dynamic>();
    phaseMap.putIfAbsent("name", () {return p.name;});
    phaseMap.putIfAbsent("repeat", () {return p.repeat;});

    List<Map<String, dynamic>> cyclesMap = List<Map<String, dynamic>>();
    for (RecipePhaseCycle c in p.cycles) {
      Map<String, dynamic> cycleMap = Map<String, dynamic>();
      cycleMap.putIfAbsent("name", () {return c.name;});
      cycleMap.putIfAbsent("environment", () {return c.environment.name;});

      Map<String, dynamic> eMap = Map<String, dynamic>();
      eMap.putIfAbsent("name", () {return c.environment.name;});
      eMap.putIfAbsent("air_temperature_celsius", () {return c.environment.airTemperatureCelsius;});
      eMap.putIfAbsent("light_illumination_distance_cm", () {return c.environment.lightIlluminationDistanceCm;});
      eMap.putIfAbsent("light_ppfd_umol_m2_s", () {return c.environment.lightPpfdUmolM2S;});

      Map<String, dynamic> lightMap = Map<String, dynamic>();
//      for (LightSpectrumNmPercent level in c.environment.lightLevels){
//        lightMap.putIfAbsent(level.min.toString() + "-" + level.max.toString(), () {return level.value;});
//      }
      lightMap.putIfAbsent("380-399", () {return c.environment.lightLevels[0].value;});
      lightMap.putIfAbsent("400-499", () {return c.environment.lightLevels[1].value;});
      lightMap.putIfAbsent("500-599", () {return c.environment.lightLevels[2].value;});
      lightMap.putIfAbsent("600-700", () {return c.environment.lightLevels[3].value;});
      lightMap.putIfAbsent("701-780", () {return c.environment.lightLevels[4].value;});
      eMap.putIfAbsent("light_spectrum_nm_percent", () {return lightMap;});

      environmentsMap.putIfAbsent(c.environment.name, (){return eMap;});

      cycleMap.putIfAbsent("duration_hours", () {return c.durationHours;});
      cyclesMap.add(cycleMap);
    }
    phaseMap.putIfAbsent("cycles", () {return cyclesMap;});
    phasesMap.add(phaseMap);
  }

  recipe.putIfAbsent("environments", () {return environmentsMap;});
  recipe.putIfAbsent("phases", () {return phasesMap;});

  return jsonEncode(recipe);
}

List<RecipePhase> generateRecipePhasesFromJson(String recipe){
  List<RecipePhase> phases = List<RecipePhase>();

  print(recipe);

  Map<String, dynamic> recipeMap = jsonDecode(recipe);

  List<dynamic> phasesMap = recipeMap["phases"];
  Map<String, dynamic> environmentsMap = recipeMap["environments"];

  for (dynamic d in phasesMap) {
    Map<String, dynamic> pMap = d;
    RecipePhase p = RecipePhase();
    p.name = pMap["name"];
    p.repeat = pMap["repeat"];

    List<dynamic> dynamicListOfCycles = pMap["cycles"];
    for (dynamic dynamicCycleMap in dynamicListOfCycles) {
      Map<String, dynamic> cMap = dynamicCycleMap;
      RecipePhaseCycle cycle = RecipePhaseCycle();
      cycle.name = cMap["name"];
      cycle.durationHours = cMap["duration_hours"];

      Map<String, dynamic> eMap = environmentsMap[cMap["environment"]];
      RecipeEnvironment e = RecipeEnvironment();
      e.name = eMap["name"];
      e.airTemperatureCelsius = eMap["air_temperature_celsius"];
      e.lightIlluminationDistanceCm = eMap["light_illumination_distance_cm"];
      e.lightPpfdUmolM2S = eMap["light_ppfd_umol_m2_s"];

      Map<String, dynamic> specMap = eMap["light_spectrum_nm_percent"];
      List<LightSpectrumNmPercent> lightLevels = List<LightSpectrumNmPercent>();
      lightLevels.add(LightSpectrumNmPercent(380, 399)); lightLevels[0].value = specMap["380-399"];
      lightLevels.add(LightSpectrumNmPercent(400, 499)); lightLevels[1].value = specMap["400-499"];
      lightLevels.add(LightSpectrumNmPercent(500, 599)); lightLevels[2].value = specMap["500-599"];
      lightLevels.add(LightSpectrumNmPercent(600, 700)); lightLevels[3].value = specMap["600-700"];
      lightLevels.add(LightSpectrumNmPercent(701, 780)); lightLevels[4].value = specMap["701-780"];
      e.lightLevels = lightLevels;

      cycle.environment = e;

      p.cycles.add(cycle);

    }
    phases.add(p);
  }

  return phases;
}