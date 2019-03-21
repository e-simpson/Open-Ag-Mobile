import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TitledProgressBar extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final Color color;
  final String minText;
  final String maxText;
  final String unit;

  TitledProgressBar({this.title, this.value, this.min, this.max, this.color, this.minText, this.maxText, this.unit}) : assert(title != null), assert(value != null), assert(max != null), assert(color != null), assert(minText != null), assert(maxText != null);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 0.0, bottom: 42.0),
      child: Column(
        children: <Widget>[
          Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: color))),
              Text(value.toStringAsPrecision(3) + ' ' + unit, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: color))
            ],
          ),
          Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text(minText, style: TextStyle(color: Colors.grey), textAlign: TextAlign.left)),
              Padding(padding: const EdgeInsets.only(top: 4.0),
                child: LinearPercentIndicator(
                  width: 260.0,
                  lineHeight: 14.0,
                  percent: (((value - min) * 100) / (max - min))/100,
                  backgroundColor: Colors.grey[300],
                  progressColor: color,
                  animation: true,
                  animationDuration: 500,
//                  leading: Text(minText, style: TextStyle(color: Colors.grey), textAlign: TextAlign.left),
//                  trailing: Text(maxText, style: TextStyle(color: Colors.grey), , textAlign: TextAlign.right),
//                center: Text(((value/max)*100).toInt().toString() + "%", style: TextStyle(color: (value/max) < 0.6 ? Colors.black : Colors.white)),
                ),
              ),
              Expanded(child: Text(maxText, style: TextStyle(color: Colors.grey), textAlign: TextAlign.right)),
            ],
          ),
        ],
      ),
    );
  }
}


