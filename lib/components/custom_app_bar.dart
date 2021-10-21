import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';

class CustomAppBar extends StatelessWidget {
  final String title, subtitle;

  const CustomAppBar({
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
      StringHandlers.capitalizeWords(this.title),
          style: Theme.of(context).appBarTheme.textTheme.subhead.copyWith(
            color: Colors.white
          ),
        ),
        ColorizeAnimatedTextKit(
            onTap: () {
            },
            text: [
              StringHandlers.capitalizeWords(this.subtitle)
            ],
            colors: [
              Colors.white,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            textStyle: Theme.of(context).appBarTheme.textTheme.subhead.copyWith(
              color: Colors.white,

            ),
            textAlign: TextAlign.start,
           // alignment: AlignmentDirectional.topStart // or Alignment.topLeft
        ),
      ],
    );
  }
}
