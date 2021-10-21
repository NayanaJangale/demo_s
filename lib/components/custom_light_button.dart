import 'package:flutter/material.dart';
import 'package:student/themes/button_styles.dart';

class CustomLightButton extends StatelessWidget {
  final String caption;
  final Function onPressed;

  const CustomLightButton({
    this.caption,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: SoftCampusButtonStyles.getLightButtonDecoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              caption,
              style: SoftCampusButtonStyles.getLightButtonTextStyle(context),
            ),
          ),
        ),
      ),
    );
  }
}
