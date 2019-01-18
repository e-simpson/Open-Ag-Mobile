import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/components/RoundedTextField.dart';
import 'package:open_ag_mobile/tools/constants.dart';
import 'package:open_ag_mobile/tools/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Setup extends StatefulWidget {
  @override
  SetupState createState() => SetupState();
}


enum ConnectionState { WAITING, SEARCHING, FOUND }
class SetupState extends State<Setup> {
  ConnectionState _connectionState = ConnectionState.WAITING;
  TextEditingController nameController = TextEditingController();

  void finishSetup() async {
    //TODO save contents of computer
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(foodComputerNamePreference, nameController.text);
    Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
  }

  void foundComputer(){
    setState(() {
      setState(() {_connectionState = ConnectionState.FOUND;});
    });
  }

  void startSearching(){
    setState(() {_connectionState = ConnectionState.SEARCHING;});

    //TODO implement
    Future.delayed(const Duration(seconds: 2), foundComputer);
  }


  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;

    Widget appBar = CupertinoNavigationBar(
      actionsForegroundColor: primary,
      middle: Text(
          _connectionState == ConnectionState.WAITING ? "Turn on your Food Computer" :
          _connectionState == ConnectionState.SEARCHING ? "Searching for a Food Computer" :
          "Food Computer found",  //FOUND
          style: TextStyle(color: Colors.black),
      ),
    );

    Widget searchingIndicator = Container(color: Colors.grey[100],
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(),
            Padding(padding: const EdgeInsets.only(left: 12.0),
              child: Text("Searching...", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            )
          ],
        )
    );

    Widget bottomContent = _connectionState == ConnectionState.WAITING ? FullWidthCupertinoButton("Next", startSearching, primary) : // CupertinoButton(child: Text("Next", style: Theme.of(context).textTheme.button), borderRadius: BorderRadius.circular(0.0), onPressed: startSearching) :
                           _connectionState == ConnectionState.SEARCHING ? searchingIndicator :
                           FullWidthCupertinoButton("Finish", nameController.text.isNotEmpty ? finishSetup : null, primary); // CupertinoButton(child: Text("Finish"), onPressed: nameController.text.isNotEmpty ? finishSetup : null);

    Widget bottomBar = Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black54, width: 0.1))),
      height: 100.0,
      child: bottomContent,
    );

    Widget textContent = Text(
       _connectionState == ConnectionState.WAITING ? "Turn on your Food Computer Turn on your Food Computer Turn on your Food Computer Turn on your Food Computer Turn on your Food Computer Turn on your Food Computer" :
       _connectionState == ConnectionState.SEARCHING ? "Searching for a Food Computer Searching for a Food Computer Searching for a Food Computer Searching for a Food Computer Searching for a Food Computer Searching for a Food Computer Searching for a Food Computer " :
       "Your Food Computer has been found! Give it a name, you can always change it later.",  //FOUND
       style: TextStyle(color: Colors.black, fontSize: 16.0),
    );

    Widget glyphContent = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Image.asset("assets/computer.png", width: 200.0),
        ),
        Positioned(top: 0.0, right: 0.0,
            child: Material(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(50.0),
              child: Padding(padding: const EdgeInsets.all(10.0),
                child: Container(width: 80.0, height: 80.0,
                  child: Image.asset(
                      _connectionState == ConnectionState.WAITING ? "assets/plugin.png" :
                      _connectionState == ConnectionState.SEARCHING ? "assets/searching.png" :
                      "assets/check.png",  //FOUND
                      width: 80.0),
                ),
              ),
            )
        )
      ],
    );

    Widget nameField = Container(alignment: Alignment.bottomCenter,
        child: Container(color: Colors.grey[50],
            child: Padding(padding: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Food Computer Name", style: TextStyle(fontWeight: FontWeight.bold, )),
                  ),
                  RoundedTextField(controller: nameController, icon: Icons.computer, placeholder: "John's Food Computer"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 68.0),
                    child: Text("192.12.1.30", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          )
    );



    Widget contentStack = Padding(padding: const EdgeInsets.all(22.0),
      child: Stack(
        children: <Widget>[
          textContent,
          Center(child: glyphContent),
          _connectionState == ConnectionState.FOUND ? nameField : Container()
        ]
      )
    );

    return Scaffold(
//        resizeToAvoidBottomPadding: false,
        appBar: appBar,
        body: contentStack,
        bottomNavigationBar: bottomBar
    );
  }
}