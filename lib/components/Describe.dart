
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Describe extends StatelessWidget {
  final String text;
  final bool bold;
  Describe(this.text, {this.bold = false}) : assert(text != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(Icons.info_outline, color: Colors.black54, size: 32.0),
          Padding(padding: const EdgeInsets.only(right: 16.0)),
          Expanded(child: Text(text, style: bold ? TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0) : null))
        ],
      ),
    );
  }
}


