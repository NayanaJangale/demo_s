import 'package:flutter/material.dart';

class CustomPasswordBox extends StatefulWidget {
  final TextInputType keyboardType;
  final Color colour;
  final TextEditingController controller;
  final IconData icon;
  final String labelText;
  final FocusNode focusNode;
  final TextInputAction inputAction;
  final Function onFieldSubmitted;
  final int maxLength;

  const CustomPasswordBox({
    this.keyboardType,
    this.colour,
    this.controller,
    this.icon,
    this.labelText,
    this.focusNode,
    this.inputAction,
    this.onFieldSubmitted,
    this.maxLength,
  });

  @override
  _CustomPasswordBoxState createState() => _CustomPasswordBoxState();
}

class _CustomPasswordBoxState extends State<CustomPasswordBox> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: widget.colour,
      ),
      child: new TextFormField(
        autofocus: true,
        focusNode: widget.focusNode,
        textInputAction: widget.inputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLength: widget.maxLength,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: new Icon(
            widget.icon,
            color: widget.colour,
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _visible = !_visible;
              });
            },
            child: new Icon(
              _visible ? Icons.visibility : Icons.visibility_off,
              color: widget.colour,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: widget.colour,
          ),
        ),
        keyboardType: widget.keyboardType,
        obscureText: _visible,
      ),
    );
  }
}
