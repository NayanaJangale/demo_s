import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_cupertino_action.dart';
import 'package:student/components/custom_cupertino_action_message.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/notification_topics.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/attendance.dart';
import 'package:student/models/configuration.dart';
import 'package:student/models/student.dart';
import 'package:student/models/subject.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  GlobalKey<ScaffoldState> _attendancePageGK;

  bool _isLoading;
  String _loadingText, _month, _subjectName, _subjectID;
  List<Subject> _subjects = [];
  Subject selectedSubject;

  List<Attendance> _attendances = [];
  List<Configuration> _configurations = [];
  String selectedAttendaceType = "";
  bool Selected_attendace = false;

  double cHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._attendancePageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';
    _subjectName = "Select Subject";
    DateTime dt = DateTime.now();
    _month = dt.month.toString();

    fetchConfiguration(ConfigurationGroups.Attendance).then((result) {
      setState(() {
        _configurations = result;
        Configuration conf = _configurations.firstWhere(
            (item) => item.confName == ConfigurationNames.SUBJECTWISE);
        Selected_attendace =
            conf != null && conf.confValue == "Y" ? true : false;
        selectedAttendaceType = Selected_attendace?AttendanceConfigurationNames.Subjectwise:AttendanceConfigurationNames.Classwise;
        if (selectedAttendaceType == AttendanceConfigurationNames.Classwise) {
          fetchAttendance(_month, "-1").then((result) {
            setState(() {
              _attendances = result;
            });
          });
        } else if (selectedAttendaceType == ConfigurationNames.SUBJECTWISE) {
          fetchSubjects().then((result) {
            fetchAttendance(_month, result[0].subject_id.toString())
                .then((result) {
              setState(() {
                _attendances = result;
              });
            });
            setState(() {
              _subjects = result;
              _subjectName = _subjects[0].subject_name;
              selectedSubject = _subjects[0];
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;

    this._loadingText = AppTranslations.of(context).text("key_loading");

    CalendarCarousel calendarCarousel = CalendarCarousel<Event>(
      height: cHeight * 0.65,
      iconColor: Theme.of(context).primaryColor,
      headerMargin: EdgeInsets.all(0),
      headerTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
      todayButtonColor: Colors.transparent,
      todayTextStyle: Theme.of(context).textTheme.bodyText1.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
      weekDayBackgroundColor: Theme.of(context).primaryColor,
      weekdayTextStyle: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
      weekDayPadding: EdgeInsets.only(top: 10, bottom: 10),
      weekDayMargin: EdgeInsets.only(
        top: 1,
        left: 1,
        right: 1,
        bottom: 5,
      ),
      weekDayFormat: WeekdayFormat.short,
      customDayBuilder: (
        /// you can provide your own build function to make custom day containers
        bool isSelectable,
        int index,
        bool isSelectedDay,
        bool isToday,
        bool isPrevMonthDay,
        TextStyle textStyle,
        bool isNextMonthDay,
        bool isThisMonthDay,
        DateTime day,
      ) {
        if (_attendances.length > 0 &&
            isThisMonthDay &&
            day.day <= _attendances[_attendances.length - 1].at_day) {
          Attendance attendance =
              _attendances.where((item) => item.at_day == day.day).elementAt(0);

          Color bgColour, textColour;
          textColour = Colors.white;
          switch (attendance.at_status) {
            case 'P':
              bgColour = Colors.green;
              break;
            case 'H':
              bgColour = Colors.red;
              break;
            case 'A':
              bgColour = Colors.blueAccent;
              break;
            default:
              bgColour = Colors.grey[300];
              textColour = Colors.grey[700];
              break;
          }
          if (day.weekday == DateTime.sunday) {
            bgColour = Colors.red;
            textColour = Colors.white;
          }
          return CircleAvatar(
            backgroundColor: bgColour,
            child: Center(
              child: Text(
                day.day.toString(),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: textColour,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              day.day.toString(),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          );
        }
      },
      onCalendarChanged: (DateTime date) {
        _month = date.month.toString();
        fetchAttendance(_month, "-1").then((result) {
          setState(() {
            _attendances = result;
          });
        });
      },
    );

    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _attendancePageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle:
                AppTranslations.of(context).text("key_monthly_attendance"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            String subID = selectedAttendaceType ==  AttendanceConfigurationNames.Classwise
                ? "-1"
                : selectedSubject != null ? selectedSubject.subject_id : "-1";
            fetchAttendance(_month, subID).then((result) {
              setState(() {
                _attendances = result;
              });
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Selected_attendace
                    ? Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            right: 12.0,
                            bottom: 8.0,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (_subjects != null && _subjects.length > 0) {
                                showSubjects();
                              } else {
                                fetchSubjects().then((result) {
                                  setState(() {
                                    _subjects = result;
                                    showSubjects();
                                  });
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        AppTranslations.of(context)
                                            .text("key_subject"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      _subjectName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: calendarCarousel,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context)
                                      .text("key_present"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10.0),
                                  color: Colors.green,
                                  width: 15,
                                  height: 15,
                                  child: Text(''),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context)
                                      .text("key_absent"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  color: Colors.blueAccent,
                                  width: 15,
                                  height: 15,
                                  child: Text(''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context)
                                      .text("key_holiday"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  color: Colors.red,
                                  width: 15,
                                  height: 15,
                                  child: Text(''),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  AppTranslations.of(context)
                                      .text("key_not_available"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12.0),
                                  color: Colors.grey[300],
                                  width: 15,
                                  height: 15,
                                  child: Text(''),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Subject>> fetchSubjects() async {
    List<Subject> subjects = [];
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
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SubjectUrls.GET_STUDENT_SUBJECTS,
          params,
        );

        Response response = await get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            subjects = responseData
                .map(
                  (item) => Subject.fromMap(item),
                )
                .toList();
          });
        }
      } else {
        FlushbarMessage.show(
            context,
            AppTranslations.of(context).text("key_no_internet"),
            AppTranslations.of(context).text("key_check_internet"),
            MessageTypes.WARNING);
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

    return subjects;
  }

  void showSubjects() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_subject"),
        ),
        actions: List<Widget>.generate(
          _subjects.length,
          (index) => CustomCupertinoActionSheetAction(
            actionIndex: index,
            actionText:
                StringHandlers.capitalizeWords(_subjects[index].subject_name),
            onActionPressed: () {
              setState(() {
                selectedSubject = _subjects[index];
                _subjectName = selectedSubject.subject_name;
                _subjectID = selectedSubject.subject_id.toString();
              });
              fetchAttendance(_month, selectedSubject.subject_id.toString())
                  .then((result) {
                setState(() {
                  _attendances = result;
                });
              });
              Navigator.pop(context);
            },
          ),
        ),
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            AppTranslations.of(context).text("key_cancel"),
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<List<Attendance>> fetchAttendance(String month, String subID) async {
    List<Attendance> attendances = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          "month": month,
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          "subject_id": subID,
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              AttendanceUrls.GET_MONTH_ATTENDANCE,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            attendances = responseData
                .map(
                  (item) => Attendance.fromJson(item),
                )
                .toList();
          });
          DBHandler().updateNotificationsByTopic(NotificationTopics.ATTENDANCE);
          Student student = AppData.current.student;
          int count  = await DBHandler().getUnReadNotifications(
            student.stud_no.toString(),
            student.brcode,
            student.client_code,
          );
          setState(() {
            FlutterAppBadger.updateBadgeCount(count);
          });
        }
      } else {
        FlushbarMessage.show(
            context,
            AppTranslations.of(context).text("key_no_internet"),
            AppTranslations.of(context).text("key_check_internet"),
            MessageTypes.WARNING);
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

    return attendances;
  }

  Future<List<Configuration>> fetchConfiguration(String confGroup) async {
    List<Configuration> configurations = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          ConfigurationFieldNames.ConfigurationGroup: confGroup,
          "stud_no": AppData.current.student.stud_no.toString(),
          "yr_no": AppData.current.student.yr_no.toString(),
          "brcode": AppData.current.student.brcode.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              ConfigurationUrls.GET_CONFIGURATION_BY_GROUP,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          configurations = responseData
              .map(
                (item) => Configuration.fromJson(item),
              )
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
      _isLoading = false;
    });

    return configurations;
  }
}
