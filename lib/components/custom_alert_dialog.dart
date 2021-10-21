import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionDialog extends StatelessWidget {
  final String message;
  final String actionName;
  final Function onActionTapped, onCancelTapped;
  final Color actionColor;

  CustomActionDialog({
    @required this.actionName,
    this.actionColor,
    this.message,
    @required this.onActionTapped,
    this.onCancelTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      message: Text(
        this.message,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            this.actionName,
            style: Theme.of(context).textTheme.bodyText1.copyWith(
              color: actionColor,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: onActionTapped,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Theme.of(context).primaryColor,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: onCancelTapped,
      ),
    );
  }
}
