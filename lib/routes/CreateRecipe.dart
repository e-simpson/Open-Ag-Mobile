import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/components/Describe.dart';
import 'package:open_ag_mobile/components/RoundedTextField.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/models/User.dart';
import 'package:open_ag_mobile/tools/DatabaseProvider.dart';
import 'package:open_ag_mobile/tools/jsonRecipeTools.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:circular_check_box/circular_check_box.dart';


class CreateRecipe extends StatefulWidget {
  @override
  CreateRecipeState createState() => CreateRecipeState();
}


class CreateRecipeState extends State<CreateRecipe> {
  int _step = 1;
  int _wizardOrRaw;

  //Recipe variables
  TextEditingController rawInputController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<RecipePhase> phases = List<RecipePhase>();

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

    Recipe r = Recipe();
    r.name = nameController.text;
    DateTime now = DateTime.now();
    r.timestamp = now.millisecondsSinceEpoch;

    User author = await dbp.fetchUserByEmail(emailController.text);
    if (author == null) {
      author = User();
      author.name = authorController.text;
      author.email = emailController.text;
      author = await dbp.upsertUser(author);
    }
    r.creatorUserId = author.id;

    if (_wizardOrRaw == 2) r.recipe = rawInputController.text;
    else r.recipe = generateRecipeJSON(phases, r.name, author.name, author.email, now);

    await dbp.upsertRecipe(r);

    Navigator.pop(context);
  }

  //widget builders
  List<Widget> buildPhaseCycleWidgets(List<RecipePhaseCycle> cycles){
    List<Widget> widgets = List<Widget>();
    for (RecipePhaseCycle c in cycles) {
      RecipeEnvironment e = c.environment;
      int index = cycles.indexOf(c)+1;
      c.name = "Cycle"+index.toString();
      c.environment.name = "Environment" + index.toString();
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
                  Expanded(child: Text("Environment " + index.toString(), style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.white))),
                  Text("Run for ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Container(width: 40.0, child: RoundedTextField(placeholder: "16", keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){c.durationHours = int.parse(s);})),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Text("Hours", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(bottom: 16.0)),
              roundedTextFieldWithSideLabel(label: "Photosynthetic Photon Flux Density", placeholder: "800", light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.lightPpfdUmolM2S = int.parse(s);}),
              roundedTextFieldWithSideLabel(label: "Light Illumination Distance (Cm)", placeholder: "10", light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.lightIlluminationDistanceCm = int.parse(s);}),
              roundedTextFieldWithSideLabel(label: "Air Temperature (°C)", placeholder: "22", light: true, keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){e.airTemperatureCelsius = int.parse(s);}),
              Text("Light Spectrum (Nm percent)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Padding(padding: const EdgeInsets.only(bottom: 6.0)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: "0.0", onChanged: (s){e.lightLevels[0].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("380-399", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: "0.0", onChanged: (s){e.lightLevels[1].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("400-499", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: "0.0", onChanged: (s){e.lightLevels[2].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("500-599", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: "0.0", onChanged: (s){e.lightLevels[3].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
                    Padding(padding: const EdgeInsets.only(bottom: 4.0)),
                    Text("600-700", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.0)),
                  ]),
                  Column(children: <Widget>[
                    Container(width: 60.0, child: RoundedTextField(placeholder: "0.0", onChanged: (s){e.lightLevels[4].value = double.parse(s);}, keyboardType: TextInputType.numberWithOptions(decimal: true))),
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
      int index = (phases.indexOf(p)+1);
      p.name = "Phase" + index.toString();
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
                  Expanded(child: Text("Phase " + index.toString(), style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.white))),
                  Text("Repeat for ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Padding(padding: const EdgeInsets.only(right: 8.0)),
                  Container(width: 40.0, child: RoundedTextField(placeholder: "30", keyboardType: TextInputType.numberWithOptions(decimal: false), onChanged: (s){p.repeat = int.parse(s);})),
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


  //Add to recipe object
  void addEnvironment(RecipePhase p){
    RecipePhaseCycle cycle = RecipePhaseCycle();
    cycle.environment = RecipeEnvironment();
    setState(() {p.cycles.add(cycle);});
  }
  void addGrowthPhase(){
    setState(() {phases.add(RecipePhase());});
  }


  //stepper helpers
  Function nullBuilder = (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Row(children: <Widget>[Container(child: null), Container(child: null)]);
  };
  void advanceStep(){
    if (_step <= 2) setState(() { _step++;});
    else if (_step == 3) saveAndComplete();
  }
  void goBack(){
    if (_step >= 1) setState(() { _step--;});
  }



  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget recipeTopBar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      actionsForegroundColor: theme.primaryColor,
      middle: Text("New Growth Recipe"),
      trailing: CupertinoButton(padding: EdgeInsets.all(0.0), child: Icon(Icons.help_outline), onPressed: (){launch('https://wiki.openag.media.mit.edu/recipe/start');}),
    );

    //STEP 1-----------------
    Widget stepOne = Column(
      children: <Widget>[
        Describe("The recipe wizard provides a setup interface with the most common configurables." + "\n\nGrowth recipes are converted into JSON format during deployment. Use the JSON input mode to paste a JSON recipe."),
        Padding(padding: const EdgeInsets.only(bottom: 28.0)),
        CupertinoButton(
          padding: const EdgeInsets.only(bottom: 12.0),
          onPressed: () => setState((){_wizardOrRaw = 1;}),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("Use Recipe Wizard", style: TextStyle(color: Colors.black87))),
              CircularCheckBox(value: _wizardOrRaw == 1, onChanged: (b){setState((){_wizardOrRaw = b ? 1 : null;});})
            ],
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.only(bottom: 12.0),
          onPressed: () => setState((){_wizardOrRaw = 2;}),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("Use JSON Input", style: TextStyle(color: Colors.black87))),
              CircularCheckBox(value: _wizardOrRaw == 2, onChanged: (b){setState((){_wizardOrRaw = b ? 2 : null;});})
            ],
          ),
        ),
      ],
    );
    //-----------------------

    //STEP 2-----------------
    Widget rawInputBox = CupertinoTextField(
      onChanged: (s){setState(() {_step = _step;});},
      controller: rawInputController,
      placeholder: "Paste JSON text here.",
      maxLines: 18,
      style: TextStyle(fontFamily: 'Source', color: Colors.black, fontSize: 14.0),
      cursorColor: theme.primaryColor,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(12.0)))
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
        Describe("Growth Recipe consists of one or more growth phases.\n\nA growth phase details the phase's growth environments and the amount of days they should run for.\n\nA growth environment consists of parameters and the amount of time in a day they should run for."),
        Padding(padding: const EdgeInsets.only(bottom: 30.0)),
        phasesBox
      ],
    );

    Widget stepTwo = _wizardOrRaw == 1 || _wizardOrRaw == null ? recipeWizard : rawInputBox;
    //-----------------------

    //STEP 3-----------------
    Widget stepThree = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Describe("Add the growth recipe name, author name, and an email. This information will be stored on this device and sent to the Food Computer during deployment."),
        Padding(padding: const EdgeInsets.only(bottom: 24.0)),
        roundedTextFieldWithTopLabel(label: "Recipe Name*", icon: CupertinoIcons.tag_solid, c: nameController),
        roundedTextFieldWithTopLabel(label: "Author", icon: CupertinoIcons.person_solid, c: authorController),
        roundedTextFieldWithTopLabel(label: "Email", icon: CupertinoIcons.mail_solid, c: emailController),
        Text("Required Field*")
//        Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
//        Padding(padding: EdgeInsets.only(bottom: 12.0)),
      ]
    );
    //-----------------------

    Widget stepper = Stepper(
      steps: [
        Step(
          title: Text("Style", style: TextStyle(color: Colors.black, fontSize: 14.0)),
          content: stepOne, isActive: _step == 1,
          subtitle: _wizardOrRaw != null ? Text(_wizardOrRaw == 1 ? "Wizard" : "JSON") : null,
          state: StepState.disabled
        ),
        Step(
            title: Text("Configure", style: TextStyle(color: Colors.black, fontSize: 14.0)),
            subtitle: phases.length > 0 ? Text(phases.length == 1 ? phases.length.toString() + " Phase" : phases.length.toString() + " Phases") : null,
            content: stepTwo, isActive: _step == 2,
            state: StepState.disabled
        ),
        Step(
            title: Text("Describe", style: TextStyle(color: Colors.black, fontSize: 14.0)),
            content: stepThree, isActive: _step == 3,
            state: StepState.disabled
        )
      ],
      type: StepperType.horizontal,
      controlsBuilder: nullBuilder,
      currentStep: _step - 1,
      onStepCancel: null,
      onStepContinue: null,
      onStepTapped: null,
    );

    Widget controlButtons = Row(mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _step > 1 ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton(
            child: Text("Back", style: TextStyle(color: theme.primaryColor)),
            onPressed: goBack
          ),
        ) : Container(),
        Expanded(child:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoButton(
              child: Text(_step != 3 ? "Continue" : "Complete"),
              onPressed: _step == 1 && _wizardOrRaw != null
                  || _step == 2  && _wizardOrRaw == 1 && phases.length > 0 && phases[0].cycles.length > 0
                  || _step == 2  && _wizardOrRaw == 2 && rawInputController.text.isNotEmpty
                  || _step == 3 && nameController.text.isNotEmpty ? advanceStep : null,
              color: theme.primaryColor
            ),
          )
        ),
      ],
    );

    Widget body = Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Container(child: stepper)),
          Container(
            decoration: _step == 2  && _wizardOrRaw == 1 && phases.length > 0 && phases[0].cycles.length > 0 ? BoxDecoration(color: Colors.grey[50], boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), offset: Offset(0.0, -10.0), blurRadius: 5.0)]) : null,
            child: controlButtons
          )
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        if (_step == 1) return true;
        showDialog(context: context, builder: (c){ return new CupertinoAlertDialog(
          title: Text("Are you sure you want to exit?"),
          content: Text("A recipe has not been saved."),
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