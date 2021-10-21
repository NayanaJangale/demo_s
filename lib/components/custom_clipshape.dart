import 'package:flutter/material.dart';
import 'package:student/components/custom_shape.dart';
import 'package:student/components/responsive_ui.dart';

class CustomClipShape extends StatelessWidget {
  double height;
  double width;
  double pixelRatio;
  bool large;
  bool medium;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(width, pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(width, pixelRatio);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:large? height/4 : (medium? height/3.75 : height/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                 // colors: [Colors.orange[300], Colors.pinkAccent],
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorLight],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: large? height/4.5 : (medium? height/4.25 : height/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  //colors: [Colors.orange[200], Colors.pinkAccent],
                  colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
