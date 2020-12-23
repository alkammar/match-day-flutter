import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MdTextField extends StatelessWidget {
  final label;
  final text;
  final onChanged;

  const MdTextField({
    Key key,
    this.label,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: TextEditingController()..text = text,
      onChanged: onChanged,
    );
  }
}
