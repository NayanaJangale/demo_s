import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/school_calendar.dart';
import 'package:student/models/student.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<SchoolCalender> yearCalendar = [];
  GlobalKey<ScaffoldState> _calendarPageGK;

  bool _isLoading;
  String _loadingText;

  List<String> months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._calendarPageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchSchoolCalendar().then((result) {
      setState(() {
        yearCalendar = result;
        print(yearCalendar.length.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");
    return DefaultTabController(
      length: months.length,
      initialIndex: DateTime.now().month,
      child: CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Scaffold(
          key: _calendarPageGK,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle:
              AppTranslations.of(context).text("key_your_school_calendar"),
            ),
            elevation: 0.0,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              tabs: List<Widget>.generate(
                months.length,
                    (i) => Tab(
                  text: AppTranslations.of(context).text(
                    "key_${months[i]}",
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: List<Widget>.generate(
              months.length,
                  (i) => getMonthCalendar(i + 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMonthCalendar(int i) {
    List<SchoolCalender> monthCalendar =
    yearCalendar.where((item) => item.from_date.month == i).toList();
    return RefreshIndicator(
      onRefresh: () async {
        fetchSchoolCalendar().then((result) {
          setState(() {
            yearCalendar = result;
            print(yearCalendar.length.toString());
          });
        });
      },
      child: monthCalendar != null && monthCalendar.length > 0
          ? ListView.separated(
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 62.0,
              top: 0.0,
              bottom: 0.0,
            ),
            child: Divider(
              height: 0.0,
            ),
          );
        },
        itemCount: monthCalendar.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 6,
              bottom: 9,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GradientText(
                              monthCalendar[index]
                                  .from_date
                                  .day
                                  .toString(),
                              style: Theme.of(context).textTheme.display1,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                // 10% of the width, so there are ten blinds.
                                tileMode: TileMode.repeated,
                                // repeats the gradient over the canvas
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).accentColor,
                                  Theme.of(context).primaryColorLight,
                                  Theme.of(context).secondaryHeaderColor,
                                ],
                              ),
                            ),
                            Text(
                              months[
                              monthCalendar[index].from_date.month -
                                  1],
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    monthCalendar[index].event_name !=
                                        null
                                        ? StringHandlers.capitalizeWords(
                                      monthCalendar[index]
                                          .event_name,
                                    )
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getDaySignature(monthCalendar[index]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            monthCalendar[index].event_cat_name != null
                                ? Text(
                              StringHandlers.capitalizeWords(
                                monthCalendar[index].event_cat_name,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                                : Container(),
                            Text(
                              monthCalendar[index].event_descr != null
                                  ? monthCalendar[index].event_descr
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )
          : Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CustomDataNotFound(
              description:AppTranslations.of(context).text("key_calendar_not_available"),

            );
          },
        ),
      ),
    );
  }

  String getDaySignature(SchoolCalender event) {
    if (event.from_date != event.to_date)
      return event.from_date.day.toString() +
          ' ' +
          months[event.from_date.month - 1] +
          ' - ' +
          event.to_date.day.toString() +
          ' ' +
          months[event.to_date.month - 1];
    else
      return '';
  }

  Future<List<SchoolCalender>> fetchSchoolCalendar() async {
    List<SchoolCalender> calendar = [];
    try {
      setState(() {
        this._isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchClassesUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SchoolCalendarUrls.GET_SCHOOL_CALENDAR,
          params,
        );

        http.Response response = await http.get(fetchClassesUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          List responseData = json.decode(response.body);
          calendar = responseData
              .map((item) => SchoolCalender.fromJson(item))
              .toList();
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }
    setState(() {
      this._isLoading = false;
    });

    return calendar;
  }
}
