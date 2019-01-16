import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/routes/RecipeList.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}


class HomeState extends State<Home> {

  void openRecipeList(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }

  void openProfile(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => RecipeList()));
  }

  @override
  Widget build(BuildContext context) {

    Widget appBar = AppBar(
      elevation: 1.0,
      backgroundColor: Colors.white,
      title: Text( "Home", style: TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: <Widget>[IconButton(icon: Icon(Icons.collections_bookmark), onPressed: openRecipeList)],
    );

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: appBar,
    );
  }
}