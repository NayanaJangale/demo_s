import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/components/custom_alert_dialog.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/custom_section_view.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/mcq_exam.dart';
import 'package:student/models/section.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/available_exam_page.dart';
import 'package:student/pages/home_page.dart';
import 'package:student/pages/mcq_exam_page.dart';
import 'package:student/pages/mcq_exam_summary_page.dart';

import '../app_data.dart';

class SelectSectionPage extends StatefulWidget {
  int exam_id, exam_time;

  String examScheduleType, exam_type;
  bool resultFlag;

  SelectSectionPage(
      {this.exam_time,
      this.exam_id,
      this.examScheduleType,
      this.exam_type,
      this.resultFlag});

  @override
  _SelectSectionPageState createState() => _SelectSectionPageState();
}

class _SelectSectionPageState extends State<SelectSectionPage> {
  bool isLoading = false;
  int currentSection = 0;
  String filter, loadingText, subtitle;
  List<MCQSection> _mcqsection = [];

  @override
  void initState() {
    super.initState();
    if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
      subtitle = "You can Switch between the Sections during Exam.";
    } else {
      subtitle =
          "During exam, You can't switch to another section until completing the current section.";
    }

    loadingText = 'Loading . . .';

    AppData.current.mcqsection != null && AppData.current.mcqsection.length == 0
        ? fetchExamSections().then((result) {
            AppData.current.mcqsection = result;
            _mcqsection = result;
            if (widget.examScheduleType != MCQExamConstant.examSheduleType)
              checkSectionSolved();
          })
        : loadSection();
  }

  loadSection() {
    _mcqsection = AppData.current.mcqsection;
    if (widget.examScheduleType != MCQExamConstant.examSheduleType)
      checkSectionSolved();
  }

  checkSectionSolved() {
    setState(() {
      for (int i = 0; i <= _mcqsection.length; i++) {
        if (!_mcqsection[i].isSolved) {
          currentSection = i;
          break;
        }
        if (i == _mcqsection.length - 1) {
          if (_mcqsection[i].isSolved) {
            if(widget.resultFlag == true){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => McqExamSummaryPage(
                      exam_id: widget.exam_id,
                    )),
              );
            }else{
              FlushbarMessage.show(
                context,
                AppTranslations.of(context).text("key_instruction"),
                AppTranslations.of(context).text("key_exam_done"),
                MessageTypes.INFORMATION,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage()),
              );
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
      subtitle =
          AppTranslations.of(context).text("key_section_subtitle_switch");
    } else {
      subtitle = AppTranslations.of(context).text("key_section_subtitle_fixed");
    }
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_exam_section"),
            ),
          ),
          body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      fetchExamSections().then((result) {
                        setState(() {
                          _mcqsection = result;
                        });
                      });
                    },
                    child: _mcqsection != null && _mcqsection.length > 0
                        ? ListView.builder(
                            itemCount: _mcqsection.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CustomSectionView(
                                sectionTitle: _mcqsection[index].sectionName,
                                instruction:
                                    _mcqsection[index].sectionInstruction,
                                examTime: _mcqsection[index].examTime,
                                examMarks: _mcqsection[index].TotalMarks,
                                isSolved: _mcqsection[index].isSolved,
                                onItemTap: () {
                                  if (widget.examScheduleType ==
                                      MCQExamConstant.examSheduleType) {
                                    _mcqsection[index].isSolved = true;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MCQExamPage(
                                                exam_type: widget.exam_type,
                                                exam_id: widget.exam_id,
                                                examScheduleType:
                                                    widget.examScheduleType,
                                                section_id: _mcqsection[index]
                                                    .sectionID,
                                                exam_time:
                                                    AppData.current.exam_time,
                                              )),
                                    );
                                  }
                                },
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
                                      .text("key_exam_section_not_avalialble"),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _mcqsection[currentSection].isSolved = true;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MCQExamPage(
                                exam_type: widget.exam_type,
                                exam_id: widget.exam_id,
                                examScheduleType: widget.examScheduleType,
                                section_id:
                                    _mcqsection[currentSection].sectionID,
                                exam_time: widget.examScheduleType ==
                                        MCQExamConstant.examSheduleType
                                    ? AppData.current.exam_time
                                    : _mcqsection[currentSection].examTime,
                              )),
                    );
                  },
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          // "START EXAM ",
                          AppTranslations.of(context).text("key_start_exam") +
                              " : ${_mcqsection.length != 0 ? _mcqsection[currentSection].sectionName : ""}",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<List<MCQSection>> fetchExamSections() async {
    List<MCQSection> mcqsection = [];
    try {
      setState(() {
        this.isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "exam_id": widget.exam_id.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchClassesUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SectionUrls.GET_SECTIONS,
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
          mcqsection =
              responseData.map((item) => MCQSection.fromJson(item)).toList();
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
      this.isLoading = false;
    });

    return mcqsection;
  }

  Future<bool> _onBackPressed() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CustomActionDialog(
        actionName: AppTranslations.of(context).text("key_yes"),
        onActionTapped: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AvailableExamPage()),
          );
        },
        actionColor: Colors.green,
        message: AppTranslations.of(context).text("key_exam_exist_instruction"),
        onCancelTapped: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
