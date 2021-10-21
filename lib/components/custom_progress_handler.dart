import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class CustomProgressHandler extends StatelessWidget {
  final String loadingText;
  final Widget child;
  final bool isLoading;

  const CustomProgressHandler({
    Key key,
    this.loadingText,
    this.child,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Stack(
        children: <Widget>[
          child,
          new Opacity(
            child: new ModalBarrier(dismissible: false, color: Colors.grey),
            opacity: 0.3,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 100,
                  left: 50,
                  right: 50,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 40,
                  ),
                  child: LiquidLinearProgressIndicator(
                    value: 0.8, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor,
                    ), // Default
                    borderRadius: 12.0, // s to the current Theme's accentColor.
                    backgroundColor: Theme.of(context).primaryColorLight, // Defaults to the current Theme's backgroundColor.
                    direction: Axis
                        .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                    center: Text(
                      loadingText,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          child,
        ],
      );
    }
  }
}