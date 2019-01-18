import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/entities/FoodComputer.dart';
import 'package:open_ag_mobile/entities/FoodComputerData.dart';
import 'package:open_ag_mobile/entities/Recipe.dart';
import 'package:open_ag_mobile/routes/RecipeList.dart';
import 'package:open_ag_mobile/tools/ui.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}


class HomeState extends State<Home> {
  int _navigationIndex = 1;
  FoodComputer foodComputer;
  Recipe activeRecipe;
  FoodComputerData latestFoodComputerData;

  void loadFoodComputer(){
    //TODO redo
    foodComputer = FoodComputer();
    foodComputer.title = "John's Food Computer";
    foodComputer.ip = "192.81.2.3";
  }
  void loadActiveRecipe(){
    //TODO redo
    activeRecipe = Recipe();
    activeRecipe.name = "Arugula";
  }
  void refreshFoodComputerData(){
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
  Future<void> refreshAll() async {
    loadFoodComputer();
    loadActiveRecipe();
    refreshFoodComputerData();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
    return;
  }

  @override
  void initState() {
    super.initState();
    loadFoodComputer();
    loadActiveRecipe();
    refreshFoodComputerData();
  }

  void openRecipeList(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }

  void openProfile(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }





  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    Widget header = Container(color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(12.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 16.0)),
              Row(
                children: <Widget>[
                  Expanded(child: Text(foodComputer.title, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0), textAlign: TextAlign.start)),
                  IconButton(icon: Icon(Icons.settings), color: Colors.grey, onPressed: (){})
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 4.0)),

              Center(child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Material(
                    child: Container(height: 200.0, width: 200.0),
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  CircularPercentIndicator(
                    progressColor: primary,
                    animation: true, animationDuration: 1000,
                    percent: latestFoodComputerData.cycle/30,
                    backgroundColor: Colors.transparent,
                    radius: 215.0,
                    lineWidth: 8.0,
                  ),
                  Column(children: <Widget>[
                    Image.asset("assets/" + activeRecipe.name.toLowerCase() + ".png", width: 250.0),
                    Padding(padding: const EdgeInsets.only(top: 8.0)),
                    Text(activeRecipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0, color: primary)),
                  ]),
                ],
              )),

              Center(child: Text("Day 10 of 20", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)))
            ],
          ),
        )
    );


    Widget stats = Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        NamedProgressBar("Water", 20, 60, Colors.blue, "Empty", "Full"),
        NamedProgressBar("Temperature", 38, 60, Colors.red, "-20C", "40C"),
        NamedProgressBar("PH Level", 24, 60, Colors.deepPurpleAccent, "Empty", "Full"),
        NamedProgressBar("Light", 45, 60, Colors.orange, "Low", "High"),
        Text("Updated " + DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(latestFoodComputerData.timestamp)), style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))
      ],
    );

    Widget refreshableStats = Expanded(child:
      Container(child:
        RefreshIndicator(
          color: primary,
          onRefresh: refreshAll,
          child: ListView(children: <Widget>[stats]),		// scroll view
        )
      )
    );


    Widget monitor = Container();

    Widget recipes = Container();

    Widget home = Column(children: <Widget>[
      header,
      Divider(height:0.0, color: Colors.black38),
      refreshableStats,
//      Expanded(child: Container(child: stats))
    ]);

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
        body: _navigationIndex == 0 ? monitor : _navigationIndex == 1 ? home : recipes,
        bottomNavigationBar: bottomBar,
    );
  }
}