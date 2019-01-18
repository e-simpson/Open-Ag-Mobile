import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeRow extends StatelessWidget {
  final int recipeId;
  final String image;
  final String title;
  RecipeRow({this.image, this.title, this.recipeId}) : assert(title != null), assert(recipeId != null);

  @override
  Widget build(BuildContext context) {
    return Container(
//        height: 70.0,
//      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black54, width: 0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Material(color: Colors.white, child: Container(width: 80.0, height: 80.0, child: image != null ? Image.asset(image, height: 70.0) : null), borderRadius: BorderRadius.circular(50.0)),
              ],
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26.0)),
            )),
            Icon(Icons.chevron_right, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}


