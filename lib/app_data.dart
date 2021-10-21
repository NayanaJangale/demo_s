import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/models/section.dart';

import 'models/student.dart';
import 'models/user.dart';

class AppData {
  static AppData _current;
  static AppData get current {
    if (_current == null) {
      _current = AppData();
    }

    return _current;
  }

  User user;
  Student student;
  SharedPreferences preferences;

  FlutterLocalNotificationsPlugin _notificationPlugin;
  FlutterLocalNotificationsPlugin get notificationPlugin {
    if (_notificationPlugin == null) {
      var initializationSettingsAndroid =
      new AndroidInitializationSettings('@drawable/soft_round_logo');

      var initializationSettingsIOS = new IOSInitializationSettings(
          onDidReceiveLocalNotification: (i, string1, string2, string3) async {
            print("received notifications");
          });

      var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid,iOS: initializationSettingsIOS
         );

      _notificationPlugin = FlutterLocalNotificationsPlugin();
      _notificationPlugin.initialize(initializationSettings,
          onSelectNotification: (string) async {
            print("selected notification:" + string);
          });
    }

    return _notificationPlugin;
  }

  List<MCQSection> mcqsection = [];
  int exam_time;

  clear(){
    mcqsection.clear();
    mcqsection = [];
    exam_time = 0;
  }
}
