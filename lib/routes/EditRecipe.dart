import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_ag_mobile/components/Describe.dart';
import 'package:open_ag_mobile/components/RoundedTextField.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/jsonRecipeTools.dart';
import 'package:url_launcher/url_launcher.dart';


class EditRecipe extends StatefulWidget {
  final Recipe initialRecipe;
  final List<RecipePhase> initialPhases;
  EditRecipe(this.initialRecipe, this.initialPhases);
  @override EditRecipeState createState() => EditRecipeState(this.initialRecipe, this.initialPhases);
}


class EditRecipeState extends State<EditRecipe> {
  //Recipe variables
  TextEditingController rawInputController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  int _wizardOrRaw = 1;
  Recipe recipe;
  List<RecipePhase> phases;

  EditRecipeState(Recipe r, List<RecipePhase> p){
    recipe = r;
    phases = p;
    rawInputController.text = recipe.recipe;
  }

  @override
  void dispose() {
    rawInputController.dispose();
    nameController.dispose();
    authorController.dispose();
    emailController.dispose();
    super.dispose();
  }

  //finalize
  void saveAndComplete() async {
    DatabaseProvider dbp = DatabaseProvider();
    await dbp.open();

    if (_wizardOrRaw == 2) recipe.recipe = rawInputController.text;
    else recipe.recipe = generateRecipeJSON(phases, recipe.name, "", "", DateTime.fromMillisecondsSinceEpoch(recipe.timestamp));

    await dbp.upsertRecipe(recipe);

    Navigator.pop(context);
  }

  //Add to recipe object
  void addEnvironment(RecipePhase p){
    RecipePhaseCycle cycle = RecipePhaseCycle();
    int i = p.cycles.length;
    cycle.name = "Cycle " + i.toString();
    cycle.environment = RecipeEnvironment();
    cycle.environment.name = "Environment " + i.toString();
    setState(() {p.cycles.add(cycle);});
  }
  void addGrowthPhase(){
    RecipePhase p = RecipePhase();
    p.name = "Phase " + phases.length.toString();
    setState(() {phases.add(p);});
  }

  //widget builders
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
                  Text("Run for ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Container(width: 40.0, child: RoundedTextField(placeholder: c.durationHours.toString(), keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){c.durationHours = int.parse(s);})),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Text("Hours", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              roundedTextFieldWithSideLabel(label: "Photosynthetic Photon Flux Density", placeholder: e.lightPpfdUmolM2S.toString(), light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.lightPpfdUmolM2S = int.parse(s);}),
              roundedTextFieldWithSideLabel(label: "Light Illumination Distance (Cm)", placeholder: e.lightIlluminationDistanceCm.toString(), light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.lightIlluminationDistanceCm = int.parse(s);}),
              roundedTextFieldWithSideLabel(label: "Air Temperature (°C)", placeholder: e.airTemperatureCelsius.toString(), light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.airTemperatureCelsius = int.parse(s);}),
              Text("Light Spectrum (Nm percent)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Padding(padding: const EdgeInsets.only(bottom: 6.0)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: e.lightLevels[0].value.toString(), onChanged: (s){e.lightLevels[0].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("380-399", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: e.lightLevels[1].value.toString(), onChanged: (s){e.lightLevels[1].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("400-499", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: e.lightLevels[2].value.toString(), onChanged: (s){e.lightLevels[2].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("500-599", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: e.lightLevels[3].value.toString(), onChanged: (s){e.lightLevels[3].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("600-700", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: e.lightLevels[4].value.toString(), onChanged: (s){e.lightLevels[4].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("701-780", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      );

      w = Dismissible(key: ObjectKey(e), child: w, onDismissed: (d){setState(() { cycles.removeAt(cycles.indexOf(c));});},);
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
                  Text("Repeat for ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Container(width: 40.0, child: RoundedTextField(placeholder: p.repeat.toString(), keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){p.repeat = int.parse(s);})),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Text("Days", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              Container(child: Column(children: buildPhaseCycleWidgets(p.cycles))),
              Divider(color: Colors.white),
              Center(child: CupertinoButton(
                child: Text("Add Environment"), color: Colors.indigo[400],
                onPressed: (){addEnvironment(p);},
              ))
            ],
          ),
        ),
      );

      w = Dismissible(key: ObjectKey(p), child: w, onDismissed: (d){setState(() {phases.removeAt(phases.indexOf(p));});},);
      widgets.add(w);
    }
    return widgets;
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget recipeTopBar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      actionsForegroundColor: theme.primaryColor,
      middle: Text("Editing Growth Recipe"),
      trailing: CupertinoButton(padding: EdgeInsets.all(0.0), child: Icon(Icons.help_outline), onPressed: (){launch('https://wiki.openag.media.mit.edu/recipe/start');}),
    );

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

    Widget rawInputBox = Padding(padding: const EdgeInsets.only(top: 30.0),
      child: CupertinoTextField(
          controller: rawInputController,
          placeholder: "Paste JSON text here.",
          maxLines: 18,
          style: TextStyle(fontFamily: 'Source', color: Colors.black, fontSize: 14.0),
          cursorColor: theme.primaryColor,
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(12.0)))
      ),
    );

    Widget phasesBox = Column(children: <Widget>[
      Container(child: Column(children: buildPhaseWidgets(phases))),
      CupertinoButton(
        child: Text("Add Growth Phase", style: TextStyle(color: theme.primaryColor)),
        onPressed: addGrowthPhase,
      ),
    ]);

    Widget recipeWizard = Column(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(bottom: 30.0)),
        phasesBox
      ],
    );

    Widget title = Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0, color: Colors.black)),
        Text("Created " + DateFormat("MMMM d, yyyy").format(DateTime.fromMillisecondsSinceEpoch(recipe.timestamp)), style: TextStyle(fontSize: 18.0, color: Colors.black54)),
      ],
    );

    Widget info = ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        title,
        Padding(padding: const EdgeInsets.only(bottom: 30.0)),
        infoController,
        _wizardOrRaw == 1 || _wizardOrRaw == null ? recipeWizard : rawInputBox
      ],
    );

    Widget controlButtons = Column(
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                  child: Text("Save Recipe"),
                  color: theme.primaryColor,
                  onPressed: saveAndComplete
              ),
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26.0),
          child: Describe("Only edited values will be modified and saved."),
        ),
      ],
    );



    Widget body = Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container(child: info)),
          Container(
              decoration: BoxDecoration(color: Colors.grey[50], boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), offset: Offset(0.0, -10.0), blurRadius: 5.0)]),
              child: controlButtons
          )
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (c){ return new CupertinoAlertDialog(
          title: Text("Are you sure you want to exit?"),
          content: Text("Any edits made will not not been saved."),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text('Cancel'),
                isDefaultAction: true,
                onPressed: () { Navigator.pop(c); }
            ),
            CupertinoDialogAction(
                child: const Text('Discard'),
                isDestructiveAction: true,
                onPressed: () { Navigator.pop(c); Navigator.pop(c);}
            ),
          ],
        );});
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: recipeTopBar,
        body: body,
      ),
    );
  }
}