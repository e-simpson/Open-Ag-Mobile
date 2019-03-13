import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/components/RoundedTextField.dart';


class CreateRecipe extends StatefulWidget {
  @override
  CreateRecipeState createState() => CreateRecipeState();
}


class CreateRecipeState extends State<CreateRecipe> {
  int _step = 1;
  int _wizardOrRaw;
  bool _hideRecipeStyle = false;
  bool _hideConfiguration = false;
  bool _hideDescribe = false;

  TextEditingController rawInputController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Widget> environments = List<Widget>();
  List<Widget> phases = List<Widget>();

  @override
  void dispose() {
    rawInputController.dispose();
    nameController.dispose();
    authorController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget stepHeader(int number, String text, Function onTap){
    double opacity = _step >= number ? 1 : 0.2;
    return CupertinoButton(
      padding: EdgeInsets.only(bottom: 0.0),
      onPressed: _step >= number ? (){setState(() {onTap();});} : null,
      child: Row(crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(width: 38.0, child: Text(number.toString(), style: TextStyle(color: Colors.black.withOpacity(opacity), fontSize: 80.0, fontWeight: FontWeight.bold))),
          Container(width: 30.0),
          Padding(padding: const EdgeInsets.only(bottom: 9.0),
            child: Text(text, style: TextStyle(color: Colors.black.withOpacity(opacity), fontSize: 40.0, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void updateStep(){
    if (_wizardOrRaw == null) _step = 1;
    else if (_wizardOrRaw == 1){
      _step = 2;
      if (environments.length == 0 || phases.length == 0) _step = 2;
      else if (nameController.text.isNotEmpty) _step = 4;
      else _step = 3;
    }
    else if (_wizardOrRaw == 2){
      _step = 2;
      if (rawInputController.text.isEmpty) _step = 2;
      else if (nameController.text.isNotEmpty) _step = 4;
      else _step = 3;
    }
  }

  void addEnvironment(){
    Widget environment = Container(
      child: Column(
        children: <Widget>[
          describe("1", 10)
        ],
      ),
    );
    setState(() {environments.add(environment);});
  }

  void addGrowthPhase(){
    setState(() {
      phases.add(describe(
          "t", 10
      ));
    });
  }

  void saveAndFinish(){

  }

  Widget describe(String text, double height, {bool bold = false}){
    return Padding(padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          height: height,
          alignment: Alignment.topLeft,
          child: Text(text, style: bold ? TextStyle(fontWeight: FontWeight.bold) : null),
        )
    );
  }

  Widget padLeft(Widget w){
    return Padding(padding: const EdgeInsets.only(left: 72.0), child: w);
  }

  @override
  Widget build(BuildContext context) {
    updateStep();
    ThemeData theme = Theme.of(context);

    Widget recipeTopBar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      actionsForegroundColor: theme.primaryColor,
      middle: Text("New Growth Recipe"),
      trailing: CupertinoButton(padding: EdgeInsets.all(0.0), child: Icon(Icons.help_outline), onPressed: (){}),
    );

    //STEP 1-----------------
    Widget stepOne = Column(
      children: <Widget>[
        describe(_wizardOrRaw == 1 || _wizardOrRaw == null ?
          "The recipe wizard provides a setup interface with the most common configurables."
          : "Growth recipes are deployed in JSON format, use this mode to simply paste in JSON text.", 48.0
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: CupertinoButton(padding: EdgeInsets.all(0.0),
              child: Text("Recipe Wizard", style: _wizardOrRaw == 1 ? null : TextStyle(color: theme.primaryColor)),
              onPressed: () => setState((){_wizardOrRaw = 1; }),
              color: _wizardOrRaw == 1 ? theme.primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
            )),
            Expanded(child: CupertinoButton(padding: EdgeInsets.all(0.0),
              child: Text("JSON Input", style: _wizardOrRaw == 2 ? null : TextStyle(color: theme.primaryColor)),
              color: _wizardOrRaw == 2 ? theme.primaryColor : Colors.grey[200],
              onPressed: () => setState((){_wizardOrRaw = 2; }),
              borderRadius: BorderRadius.only(topRight: Radius.circular(12.0), bottomRight: Radius.circular(12.0)),
            ))
        ]),
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

    Widget environmentsBox = Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Column(children: <Widget>[
          describe("Environments:", 20.0, bold: true),
          Column(children: environments),
          CupertinoButton(
            child: Text("Add Environment", style: TextStyle(color: theme.primaryColor)),
            onPressed: addEnvironment,
          ),
        ])
    );

    Widget phasesBox = Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Column(children: <Widget>[
          describe("Growth Phases:", 20.0, bold: true),
          Column(children: phases),
          CupertinoButton(
            child: Text("Add Growth Phase", style: TextStyle(color: theme.primaryColor)),
            onPressed: addGrowthPhase,
          ),
        ])
    );

    Widget recipeWizard = Column(
      children: <Widget>[
        environmentsBox,
        Padding(padding: EdgeInsets.only(bottom: 14.0)),
        phasesBox
      ],
    );

    Widget stepTwo = _wizardOrRaw == 1 || _wizardOrRaw == null ? recipeWizard : rawInputBox;
    //-----------------------

    //STEP 3-----------------
    Widget stepThree = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
        RoundedTextField(controller: nameController, icon: CupertinoIcons.tag_solid, onChanged: (s){setState(() {_step = _step;});},),
        Padding(padding: EdgeInsets.only(bottom: 12.0)),

        Text("Author", style: TextStyle(fontWeight: FontWeight.bold)),
        RoundedTextField(controller: authorController, icon: CupertinoIcons.person_solid),
        Padding(padding: EdgeInsets.only(bottom: 12.0)),

        Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
        RoundedTextField(controller: emailController, icon: CupertinoIcons.mail_solid),
        Padding(padding: EdgeInsets.only(bottom: 12.0)),

//        Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),

//        Padding(padding: EdgeInsets.only(bottom: 12.0)),
      ]
    );
    //-----------------------


    Widget body = ListView(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      children: <Widget>[
        stepHeader(1, "Recipe Style", (){_hideRecipeStyle = !_hideRecipeStyle;}),
        !_hideRecipeStyle ? padLeft(stepOne) : Container(),

        stepHeader(2, "Configuration", (){_hideConfiguration = !_hideConfiguration;}),
        !_hideConfiguration && _step >= 2 ? padLeft(stepTwo) : Container(),

        stepHeader(3, "Describe", (){_hideDescribe = !_hideDescribe;}),
        !_hideDescribe && _step >= 3 ? padLeft(stepThree) : Container(),

        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 32.0),
          child: CupertinoButton(
            child: Text("Complete"),
            color: theme.primaryColor,
            onPressed: _step == 4 ? saveAndFinish : null,
          ),
        ),
      ],
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
        body: body
      ),
    );
  }
}