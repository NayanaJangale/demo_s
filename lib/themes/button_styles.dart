import 'package:flutter/material.dart';

class SoftCampusButtonStyles {
  static getLinkButtonTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 16.0,
    );
  }

  static getDarkButtonDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor,
        ],
      ),
    );
  }

  static getLightButtonDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColorLight,
          Theme.of(context).secondaryHeaderColor,
        ],
      ),
    );
  }

  static getDarkButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.button.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  static getLightButtonTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.button.copyWith(
      color: Theme.of(context).primaryColorDark,
      fontWeight: FontWeight.w500,
    );
  }
}
