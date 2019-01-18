import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CreateRecipe extends StatefulWidget {
  @override
  CreateRecipeState createState() => CreateRecipeState();
}


class CreateRecipeState extends State<CreateRecipe> {



  @override
  Widget build(BuildContext context) {

    Widget recipeTopBar = CupertinoNavigationBar(
      backgroundColor: Colors.white,
      middle: Text("New Growth Recipe"),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: recipeTopBar,
    );
  }
}