import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ViewRecipe extends StatefulWidget {
  @override
  ViewRecipeState createState() => ViewRecipeState();
}


class ViewRecipeState extends State<ViewRecipe> {



  @override
  Widget build(BuildContext context) {

    Widget appBar = AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: Text( "Recipe", style: TextStyle(color: Colors.black)),
        centerTitle: true
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar,
    );
  }
}