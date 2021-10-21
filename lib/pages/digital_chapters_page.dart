import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/chapter_card_view.dart';
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
import 'package:student/models/digital_chapter.dart';
import 'package:student/models/student.dart';
import 'package:student/models/subject.dart';

class DigitalChaptersPage extends StatefulWidget {
  @override
  _DigitalChaptersPageState createState() => _DigitalChaptersPageState();
}

class _DigitalChaptersPageState extends State<DigitalChaptersPage> {
  bool _isLoading;
  String _loadingText, _subjectName, _subjectID;
  List<Subject> _subjects = [];
  Subject selectedSubject;
  List<DigitalChapter> _digitalChapters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._isLoading = false;
    this._loadingText = 'Loading . .';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle:
                AppTranslations.of(context).text("key_your_digital_chapters"),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                              AppTranslations.of(context).text("key_subject"),
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Text(
                            _subjectName,
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
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
            ),
            _digitalChapters != null && _digitalChapters.length > 0
                ? getChaptersView()
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      AppTranslations.of(context)
                          .text("key_select_view_digi_chaps"),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
          ],
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
          "MenuName" : "Digital Chapter"
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
          bool digitalsubjectOverlay = AppData.current.preferences.getBool('digitalsubject_Overlay') ?? false;
          if(!digitalsubjectOverlay){
            AppData.current.preferences.setBool("digitalsubject_Overlay", true);
            _showOverlay(context);
          }
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
              fetchDigitalChapters().then((result) {
                setState(() {
                  _digitalChapters = result;
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

  Future<List<DigitalChapter>> fetchDigitalChapters() async {
    List<DigitalChapter> digitalChapters = [];
    try {
      setState(() {
        _isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          SubjectFieldNames.subject_id: _subjectID,
          StudentFieldNames.brcode: AppData.current.student.brcode
        };
        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              DigitalChapterUrls.GET_DIGITAL_CHAPTERS,
          params,
        );
        Response response = await get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            digitalChapters = responseData
                .map(
                  (item) => DigitalChapter.fromMap(item),
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
    return digitalChapters;
  }

  Widget getChaptersView() {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 0.0,
        ),
        itemCount: _digitalChapters.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 3.0,
                    bottom: 3.0,
                  ),
                  child: Text(
                    _digitalChapters[index].chapter_name,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _digitalChapters[index].videos.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, rowIndex) {
                      return ChapterCardView(
                        video: _digitalChapters[index].videos[rowIndex],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      OverlayForSelectPage(AppTranslations.of(context).text("key_select_view_digi_chaps")),
    );
  }
}
