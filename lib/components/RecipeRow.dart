import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ag_mobile/models/Recipe.dart';
import 'package:open_ag_mobile/routes/ViewRecipe.dart';

class RecipeRow extends StatelessWidget {
  final Recipe recipe;
  final Function whenComplete;
  final bool isDeployed;
  RecipeRow({this.recipe, this.whenComplete, this.isDeployed = false}) : assert(recipe != null), assert(whenComplete != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      onPressed: () => Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (context) => ViewRecipe(recipe))).whenComplete(whenComplete),
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 0.1))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Material(color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                    clipBehavior: Clip.antiAlias,
                    child: Container(width: 80.0, height: 80.0, child: Center(child: recipe.imagePath != null ? Image.asset(recipe.imagePath) : Text(recipe.name.substring(0,1), style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.green)))),
                  ),
                ],
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.black)),
                    isDeployed ? Text("Currently Deployed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.green)) : Container(),
                  ],
                ),
              )),
              Icon(Icons.chevron_right, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}


