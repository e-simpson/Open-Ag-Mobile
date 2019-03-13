import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final IconData icon;
  final Function onChanged;
  RoundedTextField({this.controller, this.placeholder, this.icon, this.onChanged}) : assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7.0)),
      child: CupertinoTextField(
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
          border: Border.all(width: 1.0, color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    );
  }
}


