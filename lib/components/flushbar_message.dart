
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:student/constants/message_types.dart';

class FlushbarMessage {
  static Widget show(BuildContext context, String title, String message, String messageType){
    return Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      isDismissible: true,
      duration: Duration(seconds: 4),
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      title: title,
      message: message,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(15.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundGradient:  LinearGradient(
        // Where the linear gradient begins and ends
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        // Add one stop for each color. Stops should increase from 0 to 1
        stops: [0.3, 0.5, 0.7, 0.9],
        colors: [
          messageType == MessageTypes.ERROR ? Colors.red[400] : (messageType == MessageTypes.INFORMATION ? Colors.green[400] : Colors.deepOrange[400]),
          messageType == MessageTypes.ERROR ? Colors.red[500] : (messageType == MessageTypes.INFORMATION ? Colors.green[500] : Colors.deepOrange[500]),
          messageType == MessageTypes.ERROR ? Colors.red[600] : (messageType == MessageTypes.INFORMATION ? Colors.green[600] : Colors.deepOrange[600]),
          messageType == MessageTypes.ERROR ? Colors.red[700] : (messageType == MessageTypes.INFORMATION ? Colors.green[700] : Colors.deepOrange[700]),
        ],
      ),
    )..show(context);
  }
}