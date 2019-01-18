


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

Widget FullWidthCupertinoButton(String text, Function onPressed, Color color){
  return CupertinoButton(
      child: Text(text, style: TextStyle(color: onPressed != null ? color : Colors.black26, fontSize: 20.0)),
      borderRadius: BorderRadius.circular(0.0), 
      onPressed: onPressed,
      color: color.withOpacity(0.2),
      disabledColor: Colors.grey[100]//Color.lerp(color.withOpacity(0.2), Colors.black12, 0.7),
  );
}

Widget NamedProgressBar(String name, int value, int max, Color color, String minText, String maxText){
  return Padding(padding: const EdgeInsets.only(left: 34.0, right: 34.0, top: 2.0, bottom: 46.0),
    child: Column(
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(name, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: color))],
        ),
        Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(top: 4.0),
              child: LinearPercentIndicator(
                width: 270.0,
                lineHeight: 14.0,
                percent: value/max,
                backgroundColor: Colors.grey[300],
                progressColor: color,
                animation: true,
                animationDuration: 1000,
                leading: Text(minText, style: TextStyle(color: Colors.grey)),
                trailing: Text(maxText, style: TextStyle(color: Colors.grey)),
//                center: Text(((value/max)*100).toInt().toString() + "%", style: TextStyle(color: (value/max) < 0.6 ? Colors.black : Colors.white)),
              ),
            ),
          ],
        ),
      ],
    ),
  );


//  return Padding(
//    padding: const EdgeInsets.all(8.0),
//    child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Text(minText, style: TextStyle(color: Colors.grey)),
//        Container(
//          width: 150.0,
//          child: LinearProgressIndicator(
//            valueColor: AlwaysStoppedAnimation<Color>(color),
//            backgroundColor: Colors.grey,
//            value: 0.3,
//          ),
//        ),
//        Text(maxText, style: TextStyle(color: Colors.grey))
//      ],
//    ),
//  );
}