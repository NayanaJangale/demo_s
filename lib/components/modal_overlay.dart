
import 'package:flutter/material.dart';

class OverlayForSelectImage extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              right: 8.0,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "click_images",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Align(
              alignment: Alignment.center,
              child: FlatButton(
                textColor: Colors.blueAccent,
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Ok, Got it',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.lightBlue),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
