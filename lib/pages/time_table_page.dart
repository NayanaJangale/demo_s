import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/student.dart';
import 'package:student/models/time_table.dart';

class TimeTablePage extends StatefulWidget {
  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _timeTablePageGK;

  List<TimeTable> _timeTable = [];

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    _timeTablePageGK = GlobalKey<ScaffoldState>();

    fetchTimeTable().then((result) {
      setState(() {
        _timeTable = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");

    return DefaultTabController(
      length: days.length,
      initialIndex: DateTime.now().weekday-1,
      child: CustomProgressHandler(
        isLoading: this._isLoading,
        loadingText: this._loadingText,
        child: Scaffold(
          key: _timeTablePageGK,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_your_timetable"),
            ),
            elevation: 0.0,
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              tabs: List<Widget>.generate(
                days.length,
                (i) => Tab(
                  text:
                      AppTranslations.of(context).text("key_${days[i].substring(
                    0,
                    3,
                  )}"),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: List<Widget>.generate(
              days.length,
              (i) => getPeriodList(days[i]),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPeriodList(String day) {
    String periodTitle = '', periodTime = '', periodClass = '';
    return RefreshIndicator(
      onRefresh: () async {
        fetchTimeTable().then((result) {
          _timeTable = result;
        });
      },
      child: ListView.separated(
        separatorBuilder: (context, index) {
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
        },
        itemCount: _timeTable.length,
        itemBuilder: (BuildContext context, int index) {
          switch (day) {
            case "Sunday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Sunday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Monday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Monday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Tuesday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Tuesday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Wednesday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Wednesday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Thursday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Thursday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Friday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Friday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            case "Saturday":
              Map<String, dynamic> periodData =
                  getTitleAndClass(_timeTable[index].Saturday);
              periodTitle = periodData['periodTitle'];
              periodClass = periodData['periodClass'];
              break;
            default:
              periodClass = '';
              periodTitle = 'Free Period';
              break;
          }
          periodTime = '${_timeTable[index].period_desc}';

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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 15.0,
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 3.0,
                              bottom: 3.0,
                            ),
                            child: Text(''),
                          ),
                          width: 3.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              // 10% of the width, so there are ten blinds.
                              colors: [
                                Colors.grey[300],
                                Colors.grey[400],
                                Colors.grey,
                              ],
                              // whitish to gray
                              tileMode: TileMode
                                  .repeated, // repeats the gradient over the canvas
                            ),
                          ),
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
                                    StringHandlers.capitalizeWords(periodTitle),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  periodClass,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Text(
                              periodTime,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
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
      ),
    );
  }

  getTitleAndClass(String rawPeriodData) {
    String periodTitle, periodClass;
    if (rawPeriodData != null && rawPeriodData.trim() != '') {
      if (rawPeriodData.contains(':')) {
        periodTitle = rawPeriodData.split(':')[0];
        periodClass = rawPeriodData.split(':')[1];
      } else {
        periodTitle = rawPeriodData;
        periodClass = '';
      }
    } else {
      periodTitle = 'Free Period';
      periodClass = '';
    }

    return {
      'periodTitle': periodTitle,
      'periodClass': periodClass,
    };
  }

  Future<List<TimeTable>> fetchTimeTable() async {
    List<TimeTable> timetable = [];
    try {
      setState(() {
        _isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              TimeTableUrls.GET_STUDENT_TIMETABLE,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            timetable = responseData
                .map(
                  (item) => TimeTable.fromJson(item),
                )
                .toList();
          });
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
      _isLoading = false;
    });

    return timetable;
  }
}
