import 'dart:async';
import 'dart:convert';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:student/app_data.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/notification_channel.dart';
import 'package:student/constants/notification_topics.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/models/notification.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';

class NotificationHandler {
  static List<User> user;
  static String notificationID,topic,notificationFor,title,content,clientCode,branchCode;

  static Future<dynamic> processMessage(Map<String, dynamic> message) async {
    try {
      if (message != null) {
         notificationID =
            message[SoftCampusNotificationFieldNames.NotificationID] ??
                '0';
         topic =
            message[SoftCampusNotificationFieldNames.Topic] ?? '';

         notificationFor =
            message[SoftCampusNotificationFieldNames.NotificationFor] ??
                '';
         title =
            message[SoftCampusNotificationFieldNames.Title] ?? '';
         content =
            message[SoftCampusNotificationFieldNames.Content] ?? '';
         clientCode =
            message[SoftCampusNotificationFieldNames.ClientCode] ?? '';
         branchCode =
            message[SoftCampusNotificationFieldNames.BranchCode] ?? '';

        String sectionID = message["section_id"] ?? '';
        String classID = message["class_id"] ?? '';
        String divisionID = message["division_id"] ?? '';

        String studentNo =
            message[SoftCampusNotificationFieldNames.StudNo] ?? '';

        if (topic != null && topic != '') {
          List<Student> students = [];
          if (classID == '' && divisionID == '') {
            if (sectionID == '') {
              students = await DBHandler()
                  .getStudentsInBranch(branchCode, clientCode);
            } else {
              students = await DBHandler().getStudentsInSection(
                  sectionID, branchCode, clientCode);
            }
          } else {
            if (classID != '' && divisionID == '') {
              students = await DBHandler()
                  .getStudentsInClass(classID, branchCode, clientCode);
            } else {
              students = await DBHandler().getStudentsInDivision(
                  classID, divisionID, branchCode, clientCode);
            }
          }

          if (students != null && students.length > 0) {
            for (Student student in students) {
              checkStudStatus (student);
            }
          }
        } else {
          if (studentNo != null && studentNo != '') {
            List<Student> students = [];
            students = await DBHandler().getStudentByStudNo(studentNo);

            if (students != null && students.length > 0) {
              if (students[0].stud_no.toString() == studentNo) {
                SoftCampusNotification notification =
                SoftCampusNotification(
                  NotificationFor: notificationFor,
                  NotificationDateTime: DateTime.now(),
                  Topic: '',
                  Title: title,
                  Content: content,
                  ClientCode: clientCode,
                  BranchCode: branchCode,
                  StudNo: studentNo,
                );

                if (notification != null) {
                  notification.isRead = "0";
                  DBHandler().saveNotification(notification);
                  int count = await DBHandler().getUnReadNotifications(
                    students[0].stud_no.toString(),
                    students[0].brcode,
                    students[0].client_code,
                  );
                  showNotification(
                    int.parse(notificationID),
                    title,
                    content,
                  );
                  FlutterAppBadger.updateBadgeCount(count);
                  print( "unread "+ count.toString());
                }
              }
            }
          }
        }
      }
    } catch (e) {}
  }
  static Future<void> checkStudStatus(Student student) async {
    try {
      bool isActive = true;
      NetworkHandler.getServerWorkingUrl().then((res) async {

        if (res != "key_check_internet") {

          Uri getStudentStatusUri = Uri.parse(
            res +
                ProjectSettings.rootUrl +
                StudentUrls.Get_student_status,
          ).replace(
            queryParameters: {
              StudentFieldNames.stud_no: student.stud_no.toString(),
              StudentFieldNames.yr_no: student.yr_no.toString(),
              StudentFieldNames.brcode: student.brcode.toString(),
              UserFieldNames.clientCode: student.client_code.toString(),
            },
          );
          http.Response response = await http.get(getStudentStatusUri);

          if (response.statusCode != HttpStatusCodes.OK) {
            return isActive = false;
          } else {
            var data = json.decode(response.body);
            if (data != null && data == 'Active') {
              SoftCampusNotification notification =
              SoftCampusNotification(
                NotificationFor: notificationFor,
                NotificationDateTime: DateTime.now(),
                Topic: topic,
                Title: title,
                Content: content,
                ClientCode: clientCode,
                BranchCode: branchCode,
                StudNo: student.stud_no.toString(),
              );

              if (notification != null) {
                notification.isRead = "0";
                DBHandler().saveNotification(notification);
                showNotification(
                  int.parse(notificationID),
                  title,
                  content,
                );
                int count = await DBHandler().getUnReadNotifications(
                  student.stud_no.toString(),
                  student.brcode,
                  student.client_code,
                );
                FlutterAppBadger.updateBadgeCount(count);
              }
            }
          }
        }
      });

    } catch (e) {


    }
  }
  static void showNotification(int notificationID, String title, String message) {
    var android = new AndroidNotificationDetails(
      NotificationChannel.CHANNEL_ID,
      NotificationChannel.CHANNEL_NAME,
      NotificationChannel.CHANNEL_DESCRIPTION,
    );

    var ios = new IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(android: android, iOS: ios);

    AppData.current.notificationPlugin.show(
      notificationID,
      title,
      message,
      notificationDetails,
    );
  }

  static void subscribeTopics(FirebaseMessaging firebaseMessaging) {
    firebaseMessaging.subscribeToTopic(NotificationTopics.HOMEWORK);
    firebaseMessaging.subscribeToTopic(NotificationTopics.CIRCULARS);
    firebaseMessaging.subscribeToTopic(NotificationTopics.MESSAGE);
    firebaseMessaging.subscribeToTopic(NotificationTopics.ATTENDANCE);
  }
}
