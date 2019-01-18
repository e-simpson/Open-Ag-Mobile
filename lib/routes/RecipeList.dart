import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/routes/CreateRecipe.dart';


class RecipeList extends StatefulWidget {
  @override
  RecipeListState createState() => RecipeListState();
}


class RecipeListState extends State<RecipeList> {

  void createRecipe(){
    Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => CreateRecipe()));
//    Navigator.pushNamed(context, "createrecipe");
  }

  @override
  Widget build(BuildContext context) {

    Widget appBar = AppBar(
      elevation: 1.0,
      backgroundColor: Colors.white,
      title: Text( "Growth Recipes", style: TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: createRecipe)],
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[100],
      appBar: appBar,
    );
  }
}