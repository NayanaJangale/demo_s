import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_alert_dialog.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_feedback_item.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/feedback_option.dart';
import 'package:student/models/feedback_query.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool _isLoading, _feedbackSubmitted;
  String _loadingText, _subtitle;
  List<FeedBackQuery> _queries = [];
  int _currentQueryNo = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._isLoading = false;
    this._feedbackSubmitted = false;
    this._loadingText = 'Loading . .';
    this._subtitle = 'Add your Feedback !';

    fetchFeedBackQueries().then((result) {
      setState(() {
        _queries = result;
        if (_queries != null &&
            _queries.length > 0 &&
            _queries.first.OptionDesc != null &&
            _queries.first.OptionDesc != StringHandlers.NotAvailable) {
          //Show List
          _feedbackSubmitted = true;
          _subtitle = 'Thanks for Feedback !';
        } else {
          //Take Feedback
          _feedbackSubmitted = false;
          _subtitle = 'Add Feedback !';
        }
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
            subtitle: this._subtitle,
          ),
        ),
        body: _feedbackSubmitted == true
            ? ListView.separated(
                itemCount: _queries.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomFeedbackItem(
                    query:
                        StringHandlers.capitalizeWords(_queries[index].Query),
                    option: _queries[index].OptionDesc,
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0.0,
                  );
                },
              )
            : getFeedbackQuery(),
      ),
    );
  }

  Future<List<FeedBackQuery>> fetchFeedBackQueries() async {
    List<FeedBackQuery> queries = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;

        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          "emp_no": "0",
          StudentFieldNames.brcode: student.brcode,
        };


        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              FeedBackQueryUrls.GET_USER_FEEDBACKQUERIES,
          params,
        );

        Response response = await get(fetchSchoolsUri);
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
            queries = responseData
                .map(
                  (item) => FeedBackQuery.fromMap(item),
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

    return queries;
  }

  Widget getFeedbackQuery() {
    if (_queries != null && _queries.length > 0)
      return Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.question_answer,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    _queries[_currentQueryNo].Query ??
                        _queries[_currentQueryNo].Query,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: _queries[_currentQueryNo].options.length,
                itemBuilder: (context, index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      for (FeedbackOption option
                          in _queries[_currentQueryNo].options) {
                        option.isSelected = false;
                      }
                      _queries[_currentQueryNo].options[index].isSelected =
                          true;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          _queries[_currentQueryNo].options[index].isSelected
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            _queries[_currentQueryNo].options[index].OptionDesc,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (_currentQueryNo > 0) _currentQueryNo--;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 8.0, top: 4.0, bottom: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.navigate_before,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          AppTranslations.of(context).text("key_previous"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _queries[_currentQueryNo] == null
                          ? "0/0"
                          : '${_currentQueryNo + 1} / ${_queries.length}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_currentQueryNo < _queries.length - 1) {
                      updateCurrentQuery();
                      setState(() {
                        _currentQueryNo++;
                      });
                    } else {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => CustomActionDialog(
                          actionName: 'Yes',
                          onActionTapped: () {
                            updateCurrentQuery();
                            submitFeedback().then((result) {
                              fetchFeedBackQueries().then((result) {
                                setState(() {
                                  _queries = result;
                                  if (_queries != null &&
                                      _queries.length > 0 &&
                                      _queries.first.OptionDesc != null &&
                                      _queries.first.OptionDesc !=
                                          StringHandlers.NotAvailable) {
                                    //List
                                    _feedbackSubmitted = true;
                                    _subtitle = 'Thanks for Feedback !';
                                  } else {
                                    //Take Feedback
                                    _feedbackSubmitted = false;
                                    _subtitle = 'Add Feedback !';
                                  }
                                });
                              });
                            });
                            Navigator.pop(context);
                          },
                          actionColor: Colors.green,
                          message: 'Do you want to submit your feedback?',
                          onCancelTapped: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _currentQueryNo == _queries.length - 1
                              ? AppTranslations.of(context).text("key_submit")
                              : AppTranslations.of(context).text("key_next"),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Icon(
                          _currentQueryNo == _queries.length - 1
                              ? Icons.check
                              : Icons.navigate_next,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CustomDataNotFound(
              description:AppTranslations.of(context).text("key_feedback_queries_not_available"),
            );
          },
        ),
      );
  }

  updateCurrentQuery() {
    if (_queries[_currentQueryNo]
            .options
            .where((item) => item.isSelected == true)
            .length ==
        0) {
      FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_select_feedback_answer"),
          MessageTypes.WARNING);
    }

    _queries[_currentQueryNo].OptionNo = _queries[_currentQueryNo]
        .options
        .where((item) => item.isSelected == true)
        .elementAt(0)
        .OptionNo;

    _queries[_currentQueryNo].OptionDesc = _queries[_currentQueryNo]
        .options
        .where((item) => item.isSelected == true)
        .elementAt(0)
        .OptionDesc;
  }

  Future<void> submitFeedback() async {
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Saving . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        User user = AppData.current.user;
        Student student = AppData.current.student;


        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.brcode: student.brcode,
          StudentFieldNames.yr_no: student.yr_no.toString(),
          'emp_no': '0',
        };


        Uri saveAttendanceUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                FeedbackOptionUrls.ADD_USER_FEEDBACKS,
            params);

        Response response = await post(
          saveAttendanceUri,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: json.encode(_queries),
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == HttpStatusCodes.CREATED) {
          _queries = [];
          FlushbarMessage.show(
            context,
            null,
            AppTranslations.of(context).text("key_feedback_success"),
            MessageTypes.INFORMATION,
          );
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body.toString(),
            MessageTypes.ERROR,
          );
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
  }
}
