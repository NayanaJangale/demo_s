import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoIconAction extends StatelessWidget {
  final String actionText;
  final int actionIndex;
  final Function onActionPressed;
  final bool isImage;
  final String imagePath;
  final IconData iconData;

  CustomCupertinoIconAction({
    this.actionText,
    this.actionIndex,
    this.onActionPressed,
    this.isImage,
    this.imagePath,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              actionText,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.black54,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          isImage
              ? Image.asset(
                  imagePath,
                  height: 20.0,
                  width: 40.0,
                )
              : Icon(
                  iconData,
                  color: Colors.black54,
                  size: 30.0,
                ),
        ],
      ),
      onPressed: () {
        onActionPressed();
      },
    );
  }
}
