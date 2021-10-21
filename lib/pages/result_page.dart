import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_cupertino_action.dart';
import 'package:student/components/custom_cupertino_action_message.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/components/overlay_for_select_page.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/pdf_maker.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/assessment.dart';
import 'package:student/models/configuration.dart';
import 'package:student/models/student.dart';
import 'package:student/models/student_result.dart';
import 'package:student/models/stud_result.dart';
import 'package:student/models/user.dart';

import '../models/user.dart';

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isLoading;
  String _loadingText, _assessment;
  bool showResult;
  GlobalKey<ScaffoldState> _resultPageGK;
  List<StudentResult> _studentResult = [];
  List<Assessment> _assessments = [];
  List<StudResult> _studResult = [];
  Assessment selectedAssessment;
  List<Configuration> _configurations = [];
  Uri uri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._resultPageGK = GlobalKey<ScaffoldState>();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchConfiguration(ConfigurationGroups.Result).then((result) {
      setState(() {
        _configurations = result;
        Configuration conf = _configurations.firstWhere(
            (item) => item.confName == ConfigurationNames.forStudent);
        showResult = conf != null && conf.confValue == "Y" ? true : false;
        fetchAssessment().then((result) {
          setState(() {
            _assessments = result;
            if (showResult) {
              _assessments.insert(
                  0,
                  new Assessment(
                      term_desc: "Final Result",
                      exam_id: 0,
                      exam_desc: "Final Result",
                      term_id: 0));
              fetchStudResult().then((result) {
                setState(() {
                  _studResult = result;
                });
              });
            }
          });
        });
      });
    });
    _assessment = '';
  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
          key: _resultPageGK,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_your_result"),
            ),
            elevation: 0.0,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (selectedAssessment != null) {
                fetchStudentResult().then((result) {
                  setState(() {
                    _studentResult = result != null ? result : [];
                  });
                });
              }
            },
            child: Column(
              children: <Widget>[
                Container(
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
                        if (_assessments != null && _assessments.length > 0) {
                          showAssessments();
                        } else {
                          fetchAssessment().then((result) {
                            setState(() {
                              _assessments = result;
                            });
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Theme.of(context).primaryColorLight,
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
                                      .text("key_assessment"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                ),
                              ),
                              Text(
                                _assessment,
                                style:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Colors.white,
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
                ),
                selectedAssessment != null && selectedAssessment.exam_id == 0
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: PDF().fromUrl(
                            uri.toString(),
                            placeholder: (double progress) =>
                                Center(child: Text('$progress %')),
                            errorWidget: (dynamic error) =>
                                Center(child: Text(error.toString())),
                          ),
                        ),
                      )
                    : Expanded(
                        child: _studentResult != null &&
                                _studentResult.length > 0
                            ? ListView.separated(
                                itemCount: _studentResult.length,
                                itemBuilder: (BuildContext context, int index) {
                                  double percentage = _studentResult[index]
                                              .subject_name
                                              .toLowerCase() ==
                                          'percentage'
                                      ? _studentResult[index].grade_point / 100
                                      : calculatePercentage(index) / 100;
                                  String grade = _studentResult[index]
                                              .subject_name
                                              .toLowerCase() ==
                                          'percentage'
                                      ? _studentResult[index]
                                              .grade_point
                                              .round()
                                              .toString() +
                                          '%'
                                      : _studentResult[index].grade != null
                                          ? _studentResult[index].grade
                                          : 'n/a';
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                StringHandlers.capitalizeWords(
                                                    _studentResult[index]
                                                        .subject_name),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              _studentResult[index]
                                                          .subject_name
                                                          .toLowerCase() ==
                                                      'percentage'
                                                  ? Text(
                                                      _studentResult[index]
                                                                      .obt_marks ==
                                                                  null ||
                                                              _studentResult[
                                                                          index]
                                                                      .obt_marks ==
                                                                  ''
                                                          ? "Absent, Grade Points: n/a"
                                                          : _studentResult[
                                                                  index]
                                                              .obt_marks
                                                              .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    )
                                                  : Text(
                                                      _studentResult[index]
                                                                      .obt_marks ==
                                                                  null ||
                                                              _studentResult[
                                                                          index]
                                                                      .obt_marks ==
                                                                  ''
                                                          ? "Absent, Grade Points: n/a"
                                                          : "Grade Points: ${_studentResult[index].obt_marks} / ${_studentResult[index].total_marks}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        CircularPercentIndicator(
                                          linearGradient: LinearGradient(
                                            colors: [
                                              Theme.of(context)
                                                  .primaryColorLight,
                                              Theme.of(context).accentColor,
                                              Theme.of(context).primaryColor,
                                            ],
                                          ),
                                          radius: 40.0,
                                          lineWidth: 3.0,
                                          center: Text( grade ,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                          /*GradientText(
                                grade
                                */ /*_studentResult[index].subject_name.toLowerCase() == 'percentage'
                                    ? _studentResult[index].grade_point.round().toString() + '%'
                                    : _studentResult[index].grade != null ? _studentResult[index].grade : 'n/a'*/ /*,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),*/
                                          percent: percentage /*_studentResult[index].subject_name.toLowerCase() == 'percentage'
                                  ? _studentResult[index].grade_point / 100
                                  : calculatePercentage(index) / 100*/
                                          ,
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      top: 0.0,
                                      bottom: 0.0,
                                    ),
                                    child: Divider(
                                      height: 0.0,
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      AppTranslations.of(context)
                                          .text("key_result_not_available"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  );
                                },
                              ),
                      ),
                _studentResult != null &&
                        _studentResult.length > 0 &&
                        selectedAssessment.exam_id != 0
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Student stud = AppData.current.student;
                          bool isCreated = false;
                          PDFMaker.createPdf(
                            stud.student_name,
                            stud.class_name,
                            selectedAssessment.exam_desc,
                            _studentResult,
                          ).then((val) {
                            setState(() {
                              isCreated = val;
                            });
                          });
                        },
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_download_result"),
                                style:
                                    Theme.of(context).textTheme.bodyText1.copyWith(
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w500,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          )),
    );
  }

  double calculatePercentage(index) {
    try {
      double percentage = (_studentResult[index].obt_marks != null)
          ? _studentResult[index].obt_marks /
              _studentResult[index].total_marks *
              100
          : 0;
      return percentage;
    } catch (e) {
      return 0;
    }
  }

  Future<List<StudentResult>> fetchStudentResult() async {
    List<StudentResult> result = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          "exam_id": selectedAssessment.exam_id.toString(),
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              StudentResultUrls.GET_STUDENT_RESULT,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            result = responseData
                .map(
                  (item) => StudentResult.fromMap(item),
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

    return result;
  }

  Future<List<Assessment>> fetchAssessment() async {
    List<Assessment> assessment = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /* String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

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
              AssessmentUrls.GET_ASSESMENTS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            assessment = responseData
                .map(
                  (item) => Assessment.fromMap(item),
                )
                .toList();

            bool resultOverlay =
                AppData.current.preferences.getBool('result_overlay') ?? false;
            if (!resultOverlay) {
              AppData.current.preferences.setBool("result_overlay", true);
              _showOverlay(context);
            }
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

    return assessment;
  }

  Future<List<StudResult>> fetchStudResult() async {
    List<StudResult> studResult = [];
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
              StudResultUrl.GET_STUDENT_EXAM,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            uri = null;
            List responseData = json.decode(response.body);
            _studResult = responseData
                .map(
                  (item) => StudResult.fromMap(item),
                )
                .toList();
            setState(() {
              NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
                if (connectionServerMsg != "key_check_internet") {
                  setState(() async {
                    uri = Uri.parse(
                      connectionServerMsg +
                          ProjectSettings.rootUrl +
                          'Exam/GetResultFile',
                    ).replace(queryParameters: {
                      UserFieldNames.clientCode:
                          AppData.current.user.clientCode,
                      "brcode": _studResult[0].Brcode,
                      "DocId": _studResult[0].DocId.toString()
                    });
                    print(uri.toString());

                  });
                }
              });
            });

            bool resultOverlay =
                AppData.current.preferences.getBool('result_overlay') ?? false;
            if (!resultOverlay) {
              AppData.current.preferences.setBool("result_overlay", true);
              _showOverlay(context);
            }
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

    return _studResult;
  }

  void showAssessments() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message: AppTranslations.of(context).text("key_select_assessment"),
        ),
        actions: List<Widget>.generate(
          _assessments.length,
          (index) => CustomCupertinoActionSheetAction(
            actionIndex: index,
            actionText:
                StringHandlers.capitalizeWords(_assessments[index].exam_desc),
            onActionPressed: () {
              setState(() {
                selectedAssessment = _assessments[index];
                _assessment = selectedAssessment.exam_desc;
              });
              fetchStudentResult().then((result) {
                setState(() {
                  _studentResult = result;
                });
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      OverlayForSelectPage(
          AppTranslations.of(context).text("key_result_not_available")),
    );
  }

  Future<List<Configuration>> fetchConfiguration(String confGroup) async {
    List<Configuration> configurations = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          ConfigurationFieldNames.ConfigurationGroup: confGroup,
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode
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
