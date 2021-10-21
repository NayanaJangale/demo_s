import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_notification_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/constants/notification_for.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/notification.dart';
import 'package:student/models/student.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<SoftCampusNotification> _notifications = [];
  bool _isLoading;
  String _loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._isLoading = false;
    this._loadingText = 'Loading . .';
    fetchNotifications().then((result) {
      setState(() {
        _notifications.clear();
        this._notifications = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title:AppTranslations.of(context).text("key_hi") +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_notification"),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchNotifications().then((result) {
              setState(() {
                _notifications.clear();
                _notifications = result;
              });
            });
          },
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 0.0,
              );
            },
            itemCount: _notifications.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomNotificationItem(
                title: _notifications[index].Title,
                description: _notifications[index].Content,
                notificationDate: DateFormat('dd-MMM')
                    .format(_notifications[index].NotificationDateTime),
                notificationFor: _notifications[index].NotificationFor,
                onItemTap: () {},
              );
            },
          ),
        ),
      ),
    );
  }

  fetchNotifications() async {
    List<SoftCampusNotification> tempNoti = [];

    setState(() {
      _isLoading = true;
    });
    try {
      Student student = AppData.current.student;
      tempNoti = await DBHandler().getNotifications(
        student.stud_no.toString(),
        student.brcode,
        student.client_code,
      );
      await DBHandler().updateListNotifications(tempNoti);
    } catch (e) {}

    setState(() {
      _isLoading = false;
    });

    print(tempNoti);

    if (tempNoti == null || tempNoti.length == 0) {
      tempNoti.add(
        SoftCampusNotification(
          StudNo: '0',
          BranchCode: '001',
          ClientCode: '1000',
          Title: AppTranslations.of(context).text("key_wel_soft_campus"),
          Content:
          AppTranslations.of(context).text("key_notification_content"),
          NotificationFor: NotificationFor.NOTIFICATIONS,
          NotificationDateTime: DateTime.now(),
        ),
      );
    }

    return tempNoti;
  }
}
