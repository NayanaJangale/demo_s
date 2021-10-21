import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_homework_item.dart';
import 'package:student/components/custom_data_not_found.dart';
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
import 'package:student/models/homework.dart';
import 'package:student/models/student.dart';
import 'package:student/models/submitted_homework.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/add_submit_homework_page.dart';
import 'package:student/pages/submitted_homework_page.dart';

import '../app_data.dart';

class HomeworkPage extends StatefulWidget {
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  bool _isLoading;
  String _loadingText;
  String msgKey;
  List<SubmittedHomework> submittedHomework = [];
  GlobalKey<ScaffoldState> _homeworkPageGK;
  List<Homework> _homeworks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _homeworkPageGK = GlobalKey<ScaffoldState>();
    msgKey = "key_loading_gallery";

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchHomework().then((result) {
      setState(() {
        _homeworks = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_see_your_homework"),

          ),

        ),

        key: _homeworkPageGK,
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: () async {
            fetchHomework().then((result) {
              setState(() {
                _homeworks = result;
              });
            });
          },
          child: _homeworks != null && _homeworks.length > 0
              ? ListView.builder(
                  itemCount: _homeworks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomHomeworkItem(
                      description: _homeworks[index].hw_desc,
                      homeworkDate: DateFormat('dd MMM')
                          .format(_homeworks[index].hw_date),
                      submissionDate: DateFormat('dd MMM')
                          .format(_homeworks[index].submission_dt),
                      networkPath: '',
                      checkvisible: true,
                      homework: _homeworks[index],
                      onItemTap: () {
                        submittedHomework.clear();
                        fetchSubmittedHomework(_homeworks[index].hw_no)
                            .then((result) {
                          setState(() {
                            submittedHomework = result;
                            if (submittedHomework.length > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SubmittedHomeworkPage(
                                            hw_no: submittedHomework[0]
                                                .hw_no,
                                            seq_no: submittedHomework[0]
                                                .seq_no,
                                            remark: submittedHomework[0]
                                                .remark)),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddSubmitHomeworkPage(
                                          hw_no: _homeworks[index].hw_no,
                                          submissionDate:
                                          _homeworks[index]
                                              .submission_dt,
                                        )),
                              );
                            }
                          });
                        });
                      },
                      periods: _homeworks[index].periods,
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomDataNotFound(
                        description: AppTranslations.of(context)
                            .text("key_homework_not_available"),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(Homework homework) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'Homework/GetHomeworkImage',
          ).replace(queryParameters: {
            "hw_no": homework.hw_no.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            UserFieldNames.clientCode: AppData.current.student.client_code,
          }).toString();
        }
      });

  Future<List<Homework>> fetchHomework() async {
    List<Homework> homework = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
          'user_no': AppData.current.user.userNo.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              HomeworkUrls.GET_STUDENT_HOMEWORK,
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
            homework = responseData
                .map(
                  (item) => Homework.fromJson(item),
                )
                .toList();
          });
          DBHandler().updateNotificationsByTopic(NotificationTopics.HOMEWORK);
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

    return homework;
  }

  Future<List<SubmittedHomework>> fetchSubmittedHomework(int hw_no) async {
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          "hw_no": hw_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
          "user_no": AppData.current.user.userNo.toString(),
          UserFieldNames.clientCode: AppData.current.user.clientCode
        };
        Uri fetchteacherAlbumsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SubmittedHomeworkUrls.GET_STUDENT_SUBMITTED_HOMEWORK,
          params,
        );

        Response response = await get(fetchteacherAlbumsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body.toString(),
            MessageTypes.WARNING,
          );
          setState(() {
            msgKey = "key_submitted_not_found";
          });
        } else {
          List responseData = json.decode(response.body);
          submittedHomework = responseData
              .map(
                (item) => SubmittedHomework.fromJson(item),
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
        setState(() {
          msgKey = "key_check_internet";
        });
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
      setState(() {
        msgKey = "key_api_error";
      });
    }

    setState(() {
      _isLoading = false;
    });

    return submittedHomework;
  }
}
