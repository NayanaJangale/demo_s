import 'package:flutter/material.dart';

class CustomListSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30.0,
        top: 0.0,
        bottom: 0.0,
      ),
      child: Divider(
        height: 0.0,
      ),
    );
  }
}
