import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/student.dart';
import 'package:student/models/subject.dart';
import 'package:student/models/syllabus_topic.dart';

class SyllabusPage extends StatefulWidget {
  @override
  _SyllabusPageState createState() => _SyllabusPageState();
}

class _SyllabusPageState extends State<SyllabusPage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _syllabusPageGK;

  String _subjectName;

  List<Subject> _subjects = [];
  Subject selectedSubject;

  List<SyllabusTopic> _syllabus = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._syllabusPageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    this._subjectName = '';

    fetchSubjects().then((result) {
      setState(() {
        this._subjects = result;
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
        key: _syllabusPageGK,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_syllabus"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (selectedSubject != null) {
              fetchSyllabus().then((result) {
                setState(() {
                  _syllabus = result;
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
                      if (_subjects != null && _subjects.length > 0) {
                        showSubjects();
                      } else {
                        fetchSubjects().then((result) {
                          setState(() {
                            _subjects = result;
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
                                AppTranslations.of(context).text("key_subject"),
                                style:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                              ),
                            ),
                            Text(
                              _subjectName,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
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
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: _syllabus != null && _syllabus.length > 0
                    ? ListView.builder(
                        itemCount: _syllabus.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              right: 5.0,
                            ),
                            child: Card(
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
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            StringHandlers.capitalizeWords(
                                              _syllabus[index].topic_name,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                        _syllabus[index].status ==
                                                SyllabusTopic.PENDING
                                            ? Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red,
                                              )
                                            : (_syllabus[index].status ==
                                                    SyllabusTopic.ON_GOING
                                                ? Icon(
                                                    Icons.pause_circle_outline,
                                                    color: Colors.amber,
                                                  )
                                                : Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.green,
                                                  )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    _syllabus[index].details != null &&
                                            _syllabus[index].details != ''
                                        ? Text(
                                            StringHandlers.capitalizeWords(
                                              _syllabus[index].details,
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 5,
                                        right: 14,
                                      ),
                                      child: Divider(
                                        height: 0,
                                        color: Colors.black12,
                                      ),
                                    ),
                                    Text(
                                      'Sessions: ' +
                                          _syllabus[index]
                                              .no_of_sessions
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          AppTranslations.of(context)
                              .text("key_select_to_see_syllabus"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
              ),
            ],
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
          'MenuName': "Syllabus"
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SubjectUrls.GET_STUDENT_SUBJECTS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
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
          bool subsyllabusOverlay = AppData.current.preferences.getBool('subsyllabus_Overlay') ?? false;
          if(!subsyllabusOverlay){
            AppData.current.preferences.setBool("subsyllabus_Overlay", true);
            _showOverlay(context);
          }
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

    return subjects;
  }

  Future<List<SyllabusTopic>> fetchSyllabus() async {
    List<SyllabusTopic> syllabus = [];
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Loading . . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.class_id: student.class_id.toString(),
          "subject_id": selectedSubject.subject_id.toString(),
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SyllabusTopicUrls.GET_SUBJECT_SYLLABUS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            syllabus = responseData
                .map(
                  (item) => SyllabusTopic.fromMap(item),
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

    return syllabus;
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
              });
              fetchSyllabus().then((result) {
                setState(() {
                  _syllabus = result;
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
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      OverlayForSelectPage(AppTranslations.of(context).text("key_select_to_see_syllabus")),
    );
  }

}
