import 'dart:convert';

import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';

Future populatePreBuiltRecipes(DatabaseProvider dbp) async {
  Recipe arugula = Recipe();
  arugula.name = "Arugula";
  Object o = {
    "format": "openag-phased-environment-v1",
    "version": "1",
    "creation_timestamp_utc": "2018-06-18T11:45:41Z",
    "name": "Arugula",
    "uuid": "96826d3e-78e5-4fa5-94ef-cc38672f40f0",
    "parent_recipe_uuid": null,
    "support_recipe_uuids": null,
    "description": {
      "brief": "Grows  Apollo Arugula.",
      "verbose": "Grows arugula in 30 days in a shallow water culture hydroponic system. The lights are on a balanced spectrum and follow a standard 24 hour light cycle with 16 hour days. Moderate temperatures are maintained throughout the grow."
    },
    "authors": [
      {
        "name": "Manvitha Ponnapati",
        "email": "manvitha@media.mit.edu",
        "uuid": "a3263729-e31b-4d6a-82fc-ca4e09fc3239"
      }
    ],
    "cultivars": [
      {
        "name": "Apollo Arugula",
        "uuid": "581d6309-1155-442f-8f50-9541a4005ea2"
      }
    ],
    "cultivation_methods": [
      {
        "name": "Shallow Water Culture",
        "uuid": "30cbbded-07a7-4c49-a47b-e34fc99eefd0"
      }
    ],
    "environments": {
      "standard_day": {
        "name": "Standard Day",
        "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
        "light_ppfd_umol_m2_s": 300,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 21
      },
      "standard_night": {
        "name": "Standard Night",
        "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
        "light_ppfd_umol_m2_s": 0,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 16
      }
    },
    "phases": [
      {
        "name": "Standard Growth",
        "repeat": 30,
        "cycles": [
          {
            "name": "Day",
            "environment": "standard_day",
            "duration_hours": 16
          },
          {
            "name": "Night",
            "environment": "standard_night",
            "duration_hours": 8
          }
        ]
      }
    ]
  };
  arugula.recipe = jsonEncode(o);
  arugula.timestamp = DateTime.now().millisecondsSinceEpoch;
  arugula.imagePath = "assets/arugula.png";

  Recipe kale = Recipe();
  kale.name = "Kale";
  o = {
    "format": "openag-phased-environment-v1",
    "version": "1",
    "creation_timestamp_utc": "2018-03-30T16:45:41Z",
    "name": "If Looks Could Kale",
    "uuid": "1ef23d6a-575e-4892-a6f9-7e62631fd34f",
    "parent_recipe_uuid": null,
    "support_recipe_uuids": null,
    "description": {
      "brief": "Provides white lighting conditions for 12 hours.",
      "verbose": "Sets a homogoneous spectrum at 100 Watts"
    },
    "authors": [
      {
        "name": "Jake Rye",
        "email": "jrye@mit.edu",
        "uuid": "76b031d5-f02b-4cc2-998f-1f79a8fde33e"
      },
      {
        "name": "Rob Baynes",
        "email": "rbaynes@mit.edu",
        "uuid": "4b9572c9-5d89-4341-ad16-91d1c92d3830"
      }
    ],
    "cultivars": [
      {
        "name": "Scarlet Kale",
        "uuid": "d6d76ff9-b12e-47bb-8e83-f872c7870856"
      }
    ],
    "cultivation_methods": [
      {
        "name": "Shallow Water Culture",
        "uuid": "30cbbded-07a7-4c49-a47b-e34fc99eefd0"
      }
    ],
    "environments": {
      "standard_day": {
        "name": "Standard Day",
        "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
        "light_ppfd_umol_m2_s": 800,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 22
      },
      "standard_night": {
        "name": "Standard Night",
        "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
        "light_ppfd_umol_m2_s": 0,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 18
      },
      "cold_day": {
        "name": "Cold Day",
        "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
        "light_ppfd_umol_m2_s": 800,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 10
      },
      "frost_night": {
        "name": "Frost Night",
        "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
        "light_ppfd_umol_m2_s": 0,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 2
      }
    },
    "phases": [
      {
        "name": "Standard Growth",
        "repeat": 29,
        "cycles": [
          {
            "name": "Day",
            "environment": "standard_day",
            "duration_hours": 18
          },
          {
            "name": "Night",
            "environment": "standard_night",
            "duration_hours": 6
          }
        ]
      },
      {
        "name": "Frosty Growth",
        "repeat": 1,
        "cycles": [
          {
            "name": "Day",
            "environment": "cold_day",
            "duration_hours": 18
          },
          {
            "name": "Night",
            "environment": "frost_night",
            "duration_hours": 6
          }
        ]

      }
    ]
  };
  kale.recipe = jsonEncode(o);
  kale.timestamp = DateTime.now().millisecondsSinceEpoch;
  kale.imagePath = "assets/kale.png";

  Recipe basil = Recipe();
  basil.name = "Basil";
  o = {
    "format": "openag-phased-environment-v1",
    "version": "1",
    "creation_timestamp_utc": "2018-06-18T11:45:41Z",
    "name": "Genovese Basil",
    "uuid": "92c3b8f9-3d12-4d03-8414-e9f5af8002ab",
    "parent_recipe_uuid": null,
    "support_recipe_uuids": null,
    "description": {
      "brief": "Grows sweet Genovese basil.",
      "verbose": "Grows sweet Genovese basil in 30 days in a shallow water culture hydroponic system. The lights are on a balanced spectrum and follow a standard 24 hour light cycle with 16 hour days. Moderate temperatures are maintained throughout the grow until the final harvest phase when they are radically dropped over one night to simulate a frost which makes the leaves more tender."
    },
    "authors": [
      {
        "name": "Manvitha Ponnapati",
        "email": "manvitha@media.mit.edu",
        "uuid": "a3263729-e31b-4d6a-82fc-ca4e09fc3239"
      }
    ],
    "cultivars": [
      {
        "name": "Genovese Basil",
        "uuid": "9dc80135-0c24-4a65-ae0b-95f1c5e53676"
      }
    ],
    "cultivation_methods": [
      {
        "name": "Shallow Water Culture",
        "uuid": "30cbbded-07a7-4c49-a47b-e34fc99eefd0"
      }
    ],
    "environments": {
      "standard_day": {
        "name": "Standard Day",
        "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
        "light_ppfd_umol_m2_s": 300,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 24
      },
      "standard_night": {
        "name": "Standard Night",
        "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
        "light_ppfd_umol_m2_s": 0,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 18
      },
      "cold_day": {
        "name": "Cold Day",
        "light_spectrum_nm_percent": {"380-399": 2.03, "400-499": 20.30, "500-599": 23.27, "600-700": 31.09, "701-780": 23.31},
        "light_ppfd_umol_m2_s": 300,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 10
      },
      "frost_night": {
        "name": "Frost Night",
        "light_spectrum_nm_percent": {"380-399": 0.0, "400-499": 0.0, "500-599": 0.0, "600-700": 0.0, "701-780": 0.0},
        "light_ppfd_umol_m2_s": 0,
        "light_illumination_distance_cm": 10,
        "air_temperature_celsius": 2
      }
    },
    "phases": [
      {
        "name": "Standard Growth",
        "repeat": 29,
        "cycles": [
          {
            "name": "Day",
            "environment": "standard_day",
            "duration_hours": 16
          },
          {
            "name": "Night",
            "environment": "standard_night",
            "duration_hours": 8
          }
        ]
      },
      {
        "name": "Final frost stress for tenderness",
        "repeat": 1,
        "cycles": [
          {
            "name": "Day",
            "environment": "cold_day",
            "duration_hours": 16
          },
          {
            "name": "Night",
            "environment": "frost_night",
            "duration_hours": 8
          }
        ]

      }
    ]
  };
  basil.recipe = jsonEncode(o);
  basil.timestamp = DateTime.now().millisecondsSinceEpoch;
  basil.imagePath = "assets/basil.png";

  dbp.upsertRecipe(arugula);
  dbp.upsertRecipe(basil);
  dbp.upsertRecipe(kale);

  arugula.name = "Bell Pepper";
  arugula.imagePath = "assets/bell-pepper.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Strawberry";
  arugula.imagePath = "assets/strawberry.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Blackberry";
  arugula.imagePath = "assets/blackberry.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Cabbage";
  arugula.imagePath = "assets/cabbage.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Carrot";
  arugula.imagePath = "assets/carrot.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Vine Tomato";
  arugula.imagePath = "assets/vine-tomato.png";
  dbp.upsertRecipe(arugula);

  arugula.name = "Zucchini";
  arugula.imagePath = "assets/zucchini.png";
  dbp.upsertRecipe(arugula);

  return;
}