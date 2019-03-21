import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/components/TitledProgressBar.dart';
import 'package:open_ag_mobile/components/RecipeRow.dart';
import 'package:open_ag_mobile/routes/Onboarding.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/constants.dart';

import 'package:intl/intl.dart';

import 'package:open_ag_mobile/models/FoodComputer.dart';
import 'package:open_ag_mobile/models/FoodComputerData.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/routes/CreateRecipe.dart';
import 'package:open_ag_mobile/routes/RecipeList.dart';
import 'package:open_ag_mobile/tools/jsonRecipeTools.dart';
import 'package:open_ag_mobile/tools/systemControlTools.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}


class HomeState extends State<Home> {
  int _navigationIndex = 1;

  SharedPreferences prefs;
  DatabaseProvider dbp;

  FoodComputer foodComputer;
  Recipe activeRecipe;
  List<RecipePhase> activePhases;
  List<Recipe> recipes = List<Recipe>();
  FoodComputerData latestFoodComputerData;

  //TODO move to recipe object
  String recipeCompletionText;
  String recipeStartDate;
  int recipeDurationCount;

  TextEditingController searchController = TextEditingController();

  void loadRecipes() async {
    recipes = await dbp.fetchAllRecipes();
    setState(() {recipes = recipes;});
  }
  void loadFoodComputer() async {
    foodComputer = await dbp.fetchFoodComputer(prefs.getInt(foodComputerIdPreference));
    setState(() {foodComputer = foodComputer;});
  }
  void loadActiveRecipe() async {
    int activeId = prefs.getInt(activeRecipeIdPreference);
    if (activeId == null) return;

    activeRecipe = await dbp.fetchRecipe(activeId);
    activePhases = generateRecipePhasesFromJson(activeRecipe.recipe);
    setState(() {
      activeRecipe = activeRecipe;
      activePhases = activePhases;
    });

    recipeCompletionText = prefs.getString(activeRecipeDueDatePreference);
    recipeStartDate = prefs.getString(activeRecipeStartDatePreference);
    recipeDurationCount = prefs.getInt(activeRecipeDayCountPreference);
  }
  Future refreshFoodComputerData() async {
    //TODO redo
    latestFoodComputerData = FoodComputerData();
    latestFoodComputerData.cycle = 10;
    latestFoodComputerData.timestamp = DateTime.now().millisecondsSinceEpoch;
    latestFoodComputerData.h2oLevel = 5;
    latestFoodComputerData.lightLevel = 2;
    latestFoodComputerData.nutrientALevel = 1;
    latestFoodComputerData.nutrientBLevel = 2;
    latestFoodComputerData.temperature = 27;
    latestFoodComputerData.phLevel = 4.7;
  }
  Future refreshAll() async {
    if (dbp == null) {
      dbp = DatabaseProvider();
      await dbp.open();
      prefs = await SharedPreferences.getInstance();
    }
    await Future.delayed(const Duration(milliseconds: 500), () {});
    loadFoodComputer();
    refreshFoodComputerData();
    loadActiveRecipe();
    loadRecipes();
  }

  @override
  void initState() {
    super.initState();
    refreshAll();
  }

  //state mods
  void disconnectFoodComputer() async {
    await removeFoodComputer(prefs, dbp, foodComputer.id);
    setState(() {foodComputer = null;});
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Onboarding()), (_) => false);
  }
  void removeActiveRecipe() async {
    await removeRecipe(prefs);
    setState(() {activeRecipe = null;});
  }

  void openRecipeList(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }

  void openProfile(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }

  void openCreateRecipe(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => CreateRecipe())).whenComplete(refreshAll);
  }

  List<Widget> buildRecipeRows(){
    List<Widget> widgets = List<Widget>();
    recipes.sort((a, b){return a.name.toLowerCase().compareTo(b.name.toLowerCase());});
    for (Recipe r in recipes) widgets.add(RecipeRow(recipe: r, whenComplete: refreshAll, isDeployed: (activeRecipe != null && activeRecipe.id == r.id)));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    Widget centerIndicator = Center(child: CupertinoActivityIndicator(radius: 60.0));

    //TODO turn into component
    Widget recipeWidget = Container(child: Column(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 16.0)),
        Center(child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Material(
              child: Container(height: 200.0, width: 200.0),
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(100.0),
            ),
            activeRecipe != null ? Column(children: <Widget>[
              activeRecipe.imagePath != null ? Image.asset(activeRecipe.imagePath, width: 250.0) : Text("Custom recipe:", style: TextStyle(fontSize: 20.0)),
              Padding(padding: const EdgeInsets.only(top: 8.0)),
              Text(activeRecipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0, color: primary)),
            ])
            : CupertinoButton(child: Icon(Icons.add, size: 140.0, color: Colors.green), onPressed: ()=> setState((){_navigationIndex = 2;}))
          ],
        )),
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        Center(child:
          Text(activeRecipe != null && recipeDurationCount != null ? ("Day 1 of " + recipeDurationCount.toString() + (recipeCompletionText != null ? "\nCompletes " + recipeCompletionText : '')) : "No active growth recipe",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          )
        )
      ],
    ));

    Widget header = Container(color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(14.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 42.0)),
              Row(
                children: <Widget>[
                  Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.desktop_mac)),
                  Expanded(child: Text(foodComputer != null ? foodComputer.title : "", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0), textAlign: TextAlign.start)),
                ],
              ),
              recipeWidget
            ],
          ),
        )
    );
    Widget stats = latestFoodComputerData != null ? Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
        child: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TitledProgressBar(title: "Current Temperature", value: 21, min: -20, max: 40, color: Colors.red, minText: "-20 °C", maxText: "40 °C", unit: "°C"),
            TitledProgressBar(title: "Light Level", value: 300, min: 0, max: 300, color: Colors.orange, minText: "Min", maxText: "Max", unit: "µmol/m^2/s"),
            TitledProgressBar(title: "PH Resevoir", value: 96, min: 0, max:  100, color: Colors.deepPurpleAccent, minText:  "Empty", maxText: "Full", unit: "%"),
            TitledProgressBar(title: "Water Resevoir", value: 87, min: 0, max: 100, color: Colors.blue, minText: "Empty", maxText: "Full", unit: "%"),
            Text("Updated " + DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(latestFoodComputerData.timestamp)), style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
          ],
        )
      ) : centerIndicator;
    Widget refreshableStats = Expanded(child:
      Container(child: RefreshIndicator(color: primary,
          onRefresh: refreshAll,
          child: ListView(children: <Widget>[stats]),		// scroll view
        )
      )
    );

    Widget homeScreen = Column(children: <Widget>[
      header,
      Divider(height:0.0, color: Colors.black38),
      refreshableStats,
    ]);
    //TODO turn into component


    //TODO turn into component
    Widget foodComputerInfo = foodComputer != null ? Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.desktop_mac)),
              Expanded(child: Text("Device Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
              Text("CONNECTED", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text(foodComputer.title, style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Model", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("PFC 3.0 EDU", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("IP Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text(foodComputer.ip, style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),

            Padding(padding: const EdgeInsets.only(top: 16.0), child: Divider(height: 0.0)),
            Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
              CupertinoButton(padding: EdgeInsets.all(0.0), onPressed:  foodComputer != null ? disconnectFoodComputer : null, child: Text("DISCONNECT", style: TextStyle(color: foodComputer != null ? Colors.red : Colors.grey, fontSize: 16.0)))
            ]),
          ],
        ),
      )
    ) : centerIndicator;
    Widget environmentSetting = Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.data_usage)),
              Expanded(child: Text("Sensor Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
            ]),
            Padding(padding: const EdgeInsets.only(top: 8.0)),


            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.invert_colors)),
                Text("Water", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left:32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Temperature", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("19.5 °C" , style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left:32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Potential Hydrogen (Ph)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("4.013", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.lightbulb_outline)),
                Text("Light", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Illumination Distance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("15 cm", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("PPFD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("253.97 umol/m^2/s", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.cloud_queue)),
                Text("Air", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Temperature", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text( "21.0 °C", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Carbon Dioxide", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text( "1571.0 ppm", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0),
              child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(child: Text("Humidity ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                Text("32.0 %", style: TextStyle(fontWeight: FontWeight.bold))
              ]),
            ),

          ]
        )
      )
    );
    Widget activeRecipeInfo = Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                Padding(padding: const EdgeInsets.only(right: 8.0), child: Icon(Icons.desktop_mac)),
                Expanded(child: Text("Active Recipe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Expanded(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                  Text(activeRecipe != null && activeRecipe.name != null ? activeRecipe.name : 'None', style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Expanded(child: Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                  Text(recipeStartDate != null ? recipeStartDate : "N/A", style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Expanded(child: Text("Due Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                  Text(recipeCompletionText != null ? recipeCompletionText : "N/A", style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Expanded(child: Text("Total Day Count", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0))),
                  Text(recipeDurationCount != null ? recipeDurationCount.toString() + " Days": "N/A", style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ),
              
              

              Padding(padding: const EdgeInsets.only(top: 16.0), child: Divider(height: 0.0)),
              Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                CupertinoButton(padding: EdgeInsets.all(0.0), onPressed: activeRecipe != null ? removeActiveRecipe : null, child: Text("END GROWTH", style: TextStyle(color: activeRecipe != null ? Colors.red : Colors.grey, fontSize: 16.0)))
              ]),
            ],
          ),
        )
    );
    Widget monitorScreen = ListView(
      padding: const EdgeInsets.only(top: 54.0, left: 14.0, right: 14.0),
//        crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        foodComputerInfo,
        Padding(padding: EdgeInsets.only(top: 14.0)),

        environmentSetting,
        Padding(padding: EdgeInsets.only(top: 14.0)),

        activeRecipe != null ? activeRecipeInfo : Container(),
        Padding(padding: EdgeInsets.only(top: 14.0)),
      ]);
    //TODO turn into component




    //TODO turn into component
    Widget recipeTopBar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text("Growth Recipes"),
      trailing: CupertinoButton(child: Icon(Icons.add, color: primary), onPressed: openCreateRecipe, padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0)),
//      leading: CupertinoButton(child: Icon(Icons.search, color: primary), onPressed: (){}, padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0)),
      padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
    );
    Widget recipeList = Expanded(child:
      Container(child:
        ListView(padding: const EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 0.0),
          children: <Widget>[
//            Padding(padding: const EdgeInsets.only(top:16.0, bottom: 10.0, left: 16.0, right: 16.0),
//              child: RoundedTextField(icon: Icons.search, placeholder: "Search", controller: searchController),
//            ),
            recipes != null && recipes.length > 0 ? Container(child: Column(children: buildRecipeRows())) : centerIndicator
         ]
        )
      )
    );
    Widget recipesScreen = Column(children: <Widget>[
      recipeTopBar,
      recipeList
    ]);
    //TODO turn into component








    Widget bottomBar = BottomNavigationBar(
      currentIndex: _navigationIndex,
      onTap: (int i){setState(() {_navigationIndex = i;});},
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), title: Text("Monitor")),
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark), title: Text("Recipes")),
      ]
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[100],
      body: _navigationIndex == 0 ? monitorScreen :
            _navigationIndex == 1 ? homeScreen :
            recipesScreen,
      bottomNavigationBar: bottomBar,
    );
  }
}