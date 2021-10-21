import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

  final String labelText;
  final int hintMaxLines;
  final bool textEnable;
  final bool textautofocus;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    this.labelText,
    this.hintMaxLines,
    this.textEnable = false,
    this.textautofocus = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.controller,
    this.keyboardType = TextInputType.text
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: new TextFormField(
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        focusNode: this.widget.focusNode,
        keyboardType: widget.keyboardType,
        controller: this.widget.controller,
        onFieldSubmitted: this.widget.onFieldSubmitted,
        decoration: InputDecoration(
            hintStyle: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            hintMaxLines: widget.hintMaxLines,
          //  hintText: widget.labelText.toUpperCase(),
            enabled: widget.textEnable,
            labelStyle :Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
        ),

      ),
    );
  }
}
