import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TitledProgressBar extends StatelessWidget {
  final String title;
  final int value;
  final int max;
  final Color color;
  final String minText;
  final String maxText;

  TitledProgressBar({this.title, this.value, this.max, this.color, this.minText, this.maxText}) : assert(title != null), assert(value != null), assert(max != null), assert(color != null), assert(minText != null), assert(maxText != null);


  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 34.0, right: 34.0, top: 2.0, bottom: 46.0),
      child: Column(
        children: <Widget>[
          Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: color))],
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
//                animation: true,
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
  }
}


