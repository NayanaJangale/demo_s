import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/constants/menu_constants.dart';
import 'package:student/constants/notification_for.dart';
import 'package:student/handlers/string_handlers.dart';

class CustomNotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String notificationFor;
  final String notificationDate;
  final Function onItemTap;

  CustomNotificationItem({
    this.title,
    this.description,
    this.notificationFor,
    this.notificationDate,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 12,
        right: 12,
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/images/${getIconImage(notificationFor)}",
            color: Theme.of(context).primaryColorLight,
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      notificationDate,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getIconImage(String notificationFor) {
    switch (notificationFor) {
      case NotificationFor.CIRCULAR:
        return MenuIconConst.CircularsIcon;
        break;
      case NotificationFor.DOWNLOADS:
        return MenuIconConst.DownloadsIcon;
        break;
      case NotificationFor.GALLERY:
        return MenuIconConst.GalleryIcon;
        break;
      case NotificationFor.ATTENDANCE:
        return MenuIconConst.AttendanceIcon;
        break;
      case NotificationFor.MESSAGES:
        return MenuIconConst.MessagesIcon;
        break;
      case NotificationFor.HOMEWORK:
        return MenuIconConst.HomeWorkIcon;
        break;
      case NotificationFor.NOTIFICATIONS:
      default:
        return MenuIconConst.DefaultIcon;
    }
  }
}
