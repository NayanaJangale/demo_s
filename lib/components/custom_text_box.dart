import 'package:flutter/material.dart';

class CustomTextBox extends StatelessWidget {
  final TextInputType keyboardType;
  final Color colour;
  final TextEditingController controller;
  final IconData icon, suffixIcon;
  final String labelText;
  final int maxLength;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputAction inputAction;

  const CustomTextBox({
    this.keyboardType,
    this.colour,
    this.controller,
    this.icon,
    this.labelText,
    this.maxLength,
    this.onFieldSubmitted,
    this.focusNode,
    this.inputAction,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(primaryColor: this.colour),
      child: new TextFormField(
        autofocus: true,
        style: TextStyle(
          color: colour == Colors.white ? Colors.white : Colors.black87,
        ),
        focusNode: this.focusNode,
        textInputAction: inputAction,
        onFieldSubmitted: this.onFieldSubmitted,
        maxLength: this.maxLength,
        controller: this.controller,
        cursorColor: this.colour,
        decoration: InputDecoration(
          prefixIcon: new Icon(
            this.icon,
            color: this.colour,
          ),
          labelText: this.labelText,
          labelStyle: TextStyle(
            color: this.colour,
          ),
          suffixIcon: new Icon(
            this.suffixIcon,
            color: this.colour,
          ),
        ),
        keyboardType: this.keyboardType,
      ),
    );
  }
}
