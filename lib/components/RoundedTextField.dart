import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  RoundedTextField({this.controller, this.placeholder, this.icon}) : assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(7.0)),
      child: CupertinoTextField (
        placeholder: placeholder,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        prefix: icon != null ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.grey),
        ) : null,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
  }
}


