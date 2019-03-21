import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final Function onChanged;
  final TextInputType keyboardType;
  final Color color;
  RoundedTextField({this.controller, this.placeholder, this.icon, this.onChanged, this.keyboardType, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      child: CupertinoTextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        placeholder: placeholder,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        cursorColor: Theme.of(context).primaryColor,
        prefix: icon != null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.grey),
        ) : null,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 1.0, color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(7.0),
        ),
        maxLines: 1,
      ),
    );
  }
}

Widget roundedTextFieldWithTopLabel({TextEditingController c, String label, IconData icon, bool light = false, Function onChanged, TextInputType keyboardType}){
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: !light ? Colors.black87 : Colors.white)),
        RoundedTextField(controller: c, icon: icon, onChanged: onChanged, keyboardType: keyboardType),
        Padding(padding: EdgeInsets.only(bottom: 12.0)),
      ],
    ),
  );
}


Widget roundedTextFieldWithSideLabel({String placeholder, TextEditingController c, String label, IconData icon, bool light = false, Function onChanged, TextInputType keyboardType}){
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: <Widget>[
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: !light ? Colors.black87 : Colors.white)),
          Padding(padding: const EdgeInsets.only(right: 10.0)),
          Expanded(child: RoundedTextField(placeholder: placeholder, controller: c, icon: icon, onChanged: onChanged, keyboardType: keyboardType)),
        ],
      ),
    ),
  );
}

Widget roundedTextWithSideLabel(String text, {String label, bool light = false}){
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: !light ? Colors.black87 : Colors.white))),
          Padding(padding: const EdgeInsets.only(right: 10.0)),
          Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: !light ? Colors.black87 : Colors.white)),
        ],
      ),
    ),
  );
}
