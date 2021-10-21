import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String labelText;

  const CustomText({
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          labelText,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
