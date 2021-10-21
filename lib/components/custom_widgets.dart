import 'package:flutter/material.dart';

class CustomWidgets {
  static Widget captionedSeperatorWidget(BuildContext context, String caption) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.grey,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text(
          caption,
          style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
