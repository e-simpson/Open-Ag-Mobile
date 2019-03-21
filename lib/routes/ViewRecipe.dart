import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_ag_mobile/components/RoundedTextField.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/models/User.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/constants.dart';
import 'package:open_ag_mobile/tools/jsonRecipeTools.dart';
import 'package:open_ag_mobile/tools/systemControlTools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


class ViewRecipe extends StatefulWidget {
  final Recipe initialRecipe;
  ViewRecipe(this.initialRecipe);
  @override ViewRecipeState createState() => ViewRecipeState(this.initialRecipe);
}


class ViewRecipeState extends State<ViewRecipe> {
  Recipe recipe;
  List<RecipePhase> phases;
  User creator;
  bool editing = false;
  int _wizardOrRaw = 1;
  bool canDeploy;

  ViewRecipeState(Recipe r){
    recipe = r;
  }

  void getCreatorUser() async {
    DatabaseProvider dbp = DatabaseProvider();
    await dbp.open();
    User u = await dbp.fetchUser(recipe.creatorUserId);
    if (u != null) setState((){creator = u;});
  }

  void checkIfDeployed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int activeId = prefs.getInt(activeRecipeIdPreference);
    setState(() {canDeploy = activeId == null || activeId != recipe.id;});
  }

  @override
  void initState() {
    super.initState();
    getCreatorUser();
    checkIfDeployed();
//    setState(() {
      phases = generateRecipePhasesFromJson(recipe.recipe);
//    });
  }

  void toggleEditingMode(){

  }
  void deployRecipe() async {
    setState(() {canDeploy = false;});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deployGrowthRecipe(prefs, recipe.id, phases);
    String completion = prefs.getString(activeRecipeDueDatePreference);

    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: Column(
          children: <Widget>[
            Center(child: Icon(CupertinoIcons.check_mark_circled_solid, size: 60.0, color: Theme.of(context).primaryColor)),
            Padding(padding: const EdgeInsets.only(bottom: 8.0)),
            Text(recipe.name + " Deployed", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text("Growth will complete on " + completion + ".", style: TextStyle(fontSize: 14.0))
          ],
        ),
      ),
    );
  }
  void deleteRecipe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int activeId = prefs.getInt(activeRecipeIdPreference);
    if (activeId != null && activeId == recipe.id) await removeRecipe(prefs);

    DatabaseProvider dbp = DatabaseProvider();
    await dbp.open();
    dbp.deleteRecipe(recipe.id);

    Navigator.pop(context);
  }

  //widget builders
  //TODO make component
  List<Widget> buildPhaseCycleWidgets(List<RecipePhaseCycle> cycles){
    List<Widget> widgets = List<Widget>();
    for (RecipePhaseCycle c in cycles) {
      RecipeEnvironment e = c.environment;
      Widget w = Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.indigo[300], borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text(e.name, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.white))),
                  Text("Ran for " + c.durationHours.toString() + " hours", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(color: Colors.white),
              Padding(padding: const EdgeInsets.only(bottom: 6.0)),
              roundedTextWithSideLabel(e.lightPpfdUmolM2S.toString() + " µmol/m^2/s", label: "Photosynthetic Photon Flux ", light: true),
              roundedTextWithSideLabel(e.lightIlluminationDistanceCm.toString() + " cm", label: "Light Illumination Distance ", light: true),
              roundedTextWithSideLabel(e.airTemperatureCelsius.toString() + " °C", label: "Air Temperature ", light: true),
              Text("Light Spectrum Ranges (Nm percent)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Padding(padding: const EdgeInsets.only(bottom: 6.0)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[
                    Text(e.lightLevels[0].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("380-399", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Text(e.lightLevels[1].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("400-499", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Text(e.lightLevels[2].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("500-599", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Text(e.lightLevels[3].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("600-700", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Text(e.lightLevels[4].value.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("701-780", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 12.0)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      );
      widgets.add(w);
    }
    return widgets;
  }
  List<Widget> buildPhaseWidgets(List<RecipePhase> phases){
    List<Widget> widgets = List<Widget>();
    for (RecipePhase p in phases) {
      Widget w = Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(color: Colors.indigo[400], borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text(p.name, style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.white))),
                  Text("Repeated for " + p.repeat.toString() + " days", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              Container(child: Column(children: buildPhaseCycleWidgets(p.cycles))),
            ],
          ),
        ),
      );
      widgets.add(w);
    }
    return widgets;
  }
  //TODO make component


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget infoController = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: CupertinoButton(padding: EdgeInsets.all(0.0),
            child: Text("Visual recipe", style: _wizardOrRaw == 1 ? null : TextStyle(color: theme.primaryColor)),
            onPressed: () => setState((){_wizardOrRaw = 1; }),
            color: _wizardOrRaw == 1 ? theme.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
          )),
          Expanded(child: CupertinoButton(padding: EdgeInsets.all(0.0),
            child: Text("JSON recipe", style: _wizardOrRaw == 2 ? null : TextStyle(color: theme.primaryColor)),
            color: _wizardOrRaw == 2 ? theme.primaryColor : Colors.grey[200],
            onPressed: () => setState((){_wizardOrRaw = 2; }),
            borderRadius: BorderRadius.only(topRight: Radius.circular(12.0), bottomRight: Radius.circular(12.0)),
          ))
        ]
    );

    Widget phasesInfo = phases != null ?
      Container(
        child: Column(children: buildPhaseWidgets(phases)),
      )
      : Padding(padding: const EdgeInsets.only(top: 66.0),
          child: CupertinoActivityIndicator(radius: 40.0)
    );

    Widget rawJson = Column(
     children: <Widget>[
       Container(
           padding: EdgeInsets.all(12.0),
           decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(12.0))),
           child: Text(recipe.recipe, style: TextStyle(fontFamily: 'Source', color: Colors.black, fontSize: 10.0))
       ),
       Padding(padding: EdgeInsets.only(top: 16.0)),
       Row(
         children: <Widget>[
           Expanded(
             child: CupertinoButton(
               color: Colors.grey[200],
               child: Text("Copy to clipboard", style: TextStyle(color: theme.primaryColor)),
               onPressed: (){Clipboard.setData(new ClipboardData(text: recipe.recipe));},
             ),
           ),
         ],
       )
     ],
    );

    Widget body = Column(
      children: <Widget>[
        recipe.imagePath != null ? Material(elevation: 3.0,
          child: Container(color: Colors.white, height: 200.0,
            child: SizedBox.expand(child: Image.asset(recipe.imagePath)),
          ),
        ) : Container(),

        Expanded(
          child: Container(
            child: ListView(
              padding: const EdgeInsets.all(22.0),
              children: <Widget>[
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0, color: Colors.black))),
                    canDeploy != null && canDeploy == false ? Text("DEPLOYED", style: TextStyle(fontSize: 16.0, color: theme.primaryColor)) : Container()
                  ],
                ),
                Text("Created " + DateFormat("MMMM d, yyyy").format(DateTime.fromMillisecondsSinceEpoch(recipe.timestamp)), style: TextStyle(fontSize: 18.0, color: Colors.black54)),
//                Divider(),
                Padding(padding: const EdgeInsets.only(top: 16.0)),
                infoController,
                Padding(padding: const EdgeInsets.only(top: 16.0)),
                _wizardOrRaw == 1 ? phasesInfo : rawJson,

                Padding(padding: const EdgeInsets.only(top: 16.0), child: Divider(height: 0.0)),
                Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                  CupertinoButton(padding: EdgeInsets.all(0.0), onPressed: deleteRecipe, child: Text("Delete " + recipe.name, style: TextStyle(color: Colors.red, fontSize: 16.0)))
                ]),
              ],
            ),
          ),
        ),

        canDeploy != null && canDeploy == true ? Row(children: <Widget>[
            Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 36.0, left: 16.0, right: 16.0),
              child: CupertinoButton(child: Text("Deploy " + recipe.name), onPressed: deployRecipe, color: theme.primaryColor),
            )),
          ],
        ) : Container(),
      ],
    );

    Widget navNar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text(recipe.name),
      actionsForegroundColor: theme.primaryColor,
      trailing: CupertinoButton(child: Icon(CupertinoIcons.pencil, color: theme.primaryColor), onPressed: toggleEditingMode, padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0)),
      padding: const EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
    );


    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: navNar,
      body: body,
    );
  }
}