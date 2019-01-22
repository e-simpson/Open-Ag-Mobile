import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeRow extends StatelessWidget {
  final int recipeId;
  final String image;
  final String title;
  RecipeRow({this.image, this.title, this.recipeId}) : assert(title != null), assert(recipeId != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
      onPressed: (){},
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 0.1))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Material(color: Colors.white, child: Container(width: 80.0, height: 80.0, child: image != null ? Image.asset(image, height: 70.0) : null), borderRadius: BorderRadius.circular(50.0)),
                ],
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.black)),
              )),
              Icon(Icons.chevron_right, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }
}


