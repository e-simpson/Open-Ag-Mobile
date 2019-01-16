import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CreateRecipe extends StatefulWidget {
  @override
  CreateRecipeState createState() => CreateRecipeState();
}


class CreateRecipeState extends State<CreateRecipe> {



  @override
  Widget build(BuildContext context) {

    Widget appBar = AppBar(
      elevation: 1.0,
      backgroundColor: Colors.white,
      title: Text( "New Recipe", style: TextStyle(color: Colors.black)),
      centerTitle: true
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar,
    );
  }
}