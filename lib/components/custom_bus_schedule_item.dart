import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';

class CustomBusScheduleItem extends StatelessWidget {
  final String in_time;
  final String out_time;
  final String point_name;
  final Function onItemTap;

  CustomBusScheduleItem({
    this.in_time,
    this.out_time,
    this.point_name,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Table(
              columnWidths: {
                0: FractionColumnWidth(.4),
              },
              children: [
                TableRow(
                  children: [
                    Container(),
                    Container(),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Text(
                        AppTranslations.of(context).text("key_point"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Text(
                        StringHandlers.capitalizeWords(this.point_name),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Text(
                        AppTranslations.of(context).text("key_in_time"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Text(
                        StringHandlers.capitalizeWords(this.in_time),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        AppTranslations.of(context).text("key_out_time"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        StringHandlers.capitalizeWords(this.out_time),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
