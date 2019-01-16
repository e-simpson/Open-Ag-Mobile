import 'package:flutter/material.dart';

class ImageAndTitle extends StatelessWidget{
  final String image;
  final String title;
  final Color textColor;
  ImageAndTitle({this.image, this.title, this.textColor = Colors.black}) : assert(image != null), assert(title != null);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(image, fit: BoxFit.scaleDown, height: 200.0),
          new Padding(padding: const EdgeInsets.only(bottom: 20.0)),
          new Text(title, style: new TextStyle(color: textColor.withOpacity(0.8), fontSize: 18.0), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
