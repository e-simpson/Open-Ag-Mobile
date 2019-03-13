import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/components/NamedProgressBar.dart';
import 'package:open_ag_mobile/components/SimpleChart.dart';
import 'package:open_ag_mobile/components/SimpleLineGraph.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';

import 'package:open_ag_mobile/components/RoundedTextField.dart';
import 'package:open_ag_mobile/entities/FoodComputer.dart';
import 'package:open_ag_mobile/entities/FoodComputerData.dart';
import 'package:open_ag_mobile/entities/Recipe.dart';
import 'package:open_ag_mobile/routes/CreateRecipe.dart';
import 'package:open_ag_mobile/routes/RecipeList.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}


class HomeState extends State<Home> {
  int _navigationIndex = 1;
  FoodComputer foodComputer;
  Recipe activeRecipe;
  FoodComputerData latestFoodComputerData;

  TextEditingController searchController = TextEditingController();


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

  void openCreateRecipe(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => CreateRecipe()));
  }





  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;


    //TODO turn into component
    Widget header = Container(color: Colors.white,
        child: Padding(padding: const EdgeInsets.all(14.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 26.0)),
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
        TitledProgressBar(title: "Water", value: 20, max: 60, color: Colors.blue, minText: "Empty", maxText: "Full"),
        TitledProgressBar(title: "Temperature", value: 38, max: 60, color: Colors.red, minText: "-20C", maxText: "40C"),
        TitledProgressBar(title: "PH Level", value: 24, max:  60, color: Colors.deepPurpleAccent, minText:  "Empty", maxText: "Full"),
        TitledProgressBar(title: "Light", value: 45, max:  60, color: Colors.orange, minText: "Low", maxText: "High"),
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

    Widget home = Column(children: <Widget>[
      header,
      Divider(height:0.0, color: Colors.black38),
      refreshableStats,
    ]);
    //TODO turn into component









    //TODO turn into component
    Widget monitorHeader = Column(mainAxisSize: MainAxisSize.max, //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(top: 26.0)),
        Row(
          children: <Widget>[
            Expanded(child: Text(foodComputer.title, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20.0), textAlign: TextAlign.start)),
            IconButton(icon: Icon(Icons.settings), color: Colors.grey, onPressed: (){})
          ],
        ),
        Padding(padding: const EdgeInsets.only(top: 4.0)),
      ]
    );

    Widget monitor = Padding(padding: const EdgeInsets.all(14.0),
      child: Column(children: <Widget>[
//        monitorHeader,
        Padding(padding: const EdgeInsets.only(top: 26.0)),
        Container(height: 300, child: SimplePieChart.withSampleData()),
        Container(height: 300, child: SimpleLineGraph.withSampleData())
      ])
    );
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
        ListView(padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top:16.0, bottom: 10.0, left: 16.0, right: 16.0),
              child: RoundedTextField(icon: Icons.search, placeholder: "Search", controller: searchController),
            ),
//            RecipeRow(recipeId: 1, title: "Arugula", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Spinach", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Carrots", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Pineapple", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Celery", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Cilantro", image: "assets/arugula.png"),
//            RecipeRow(recipeId: 1, title: "Brussel Sprouts", image: "assets/arugula.png"),
          ]
        )
      )
    );

    Widget recipes = Column(children: <Widget>[
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
      body: _navigationIndex == 0 ? monitor :
            _navigationIndex == 1 ? home :
            recipes,
      bottomNavigationBar: bottomBar,
    );
  }
}