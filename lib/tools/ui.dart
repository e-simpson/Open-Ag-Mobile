import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget FullWidthCupertinoButton(String text, Function onPressed, Color color){
  return CupertinoButton(
      child: Text(text, style: TextStyle(color: onPressed != null ? color : Colors.black26, fontSize: 20.0)),
      borderRadius: BorderRadius.circular(0.0),
      onPressed: onPressed,
      color: color.withOpacity(0.2),
      disabledColor: Colors.grey[100]//Color.lerp(color.withOpacity(0.2), Colors.black12, 0.7),
  );
}
