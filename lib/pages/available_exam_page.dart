import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_exam_card.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/mcq_exam.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/home_page.dart';
import 'package:student/pages/mcq_exam_summary_page.dart';
import 'package:student/pages/mcq_instruction_page.dart';
import 'package:http/http.dart' as http;


class AvailableExamPage extends StatefulWidget {
  @override
  _AvailableExamPageState createState() => _AvailableExamPageState();
}

class _AvailableExamPageState extends State<AvailableExamPage> {
  bool isLoading = false;
  String filter, loadingText;
  List<MCQExam> _mcqexam = [];

  @override
  void initState() {
    super.initState();
    loadingText = 'Loading . . .';
    fetchStudentAvailableExam().then((result) {
      setState(() {
        _mcqexam = result;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: CustomProgressHandler(
        isLoading: this.isLoading,
        loadingText: this.loadingText,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0.0,
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_see_your_available_exam"),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              fetchStudentAvailableExam().then((result) {
                setState(() {
                  _mcqexam = result;
                });
              });
            },
            child: _mcqexam != null && _mcqexam.length > 0
                ? ListView.builder(
              itemCount: _mcqexam.length,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<String>(
                    future: getImageUrl(_mcqexam[index]),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return CustomExamcard(
                        networkPath: snapshot.data.toString(),
                        title:_mcqexam[index].examTitle,
                        fromDate:DateFormat('dd MMM')
                            .format(_mcqexam[index].fromDate) ,
                        toDate:DateFormat('dd MMM')
                            .format(_mcqexam[index].uptoDate),
                        totalMark: _mcqexam[index].TotalMarks,
                        totaltime: _mcqexam[index].examTime,
                        exam: _mcqexam[index],
                        onPressed: (){
                          if(_mcqexam[index].attemptNo == 1){
                            if(_mcqexam[index].ExamResultFlag == true){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => McqExamSummaryPage(
                                      exam_id: _mcqexam[index].examId,
                                    )),
                              );
                            }else{
                              FlushbarMessage.show(
                                context,
                                AppTranslations.of(context).text("key_instruction"),
                                AppTranslations.of(context).text("key_exam_done"),
                                MessageTypes.INFORMATION,
                              );
                            }
                          }else{
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MCQInstructionPage(
                                          instruction: _mcqexam[index].examInstruction ,
                                          exam_id:_mcqexam[index].examId ,
                                          examType:_mcqexam[index].examType ,
                                          examScheduleType:_mcqexam[index].examScheduleType,
                                          exam_time: _mcqexam[index].examTime,
                                          resultFlag:_mcqexam[index].ExamResultFlag ?? false
                                      )),
                            );
                          }
                        },
                      );
                    });
              },
            ) : Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return CustomDataNotFound(
                    description:AppTranslations.of(context).text("key_exam_not_available"),
                  );
                },
              ),
            ),
          ),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
  Future<List<MCQExam>> fetchStudentAvailableExam() async {
    List<MCQExam> calendar = [];
    try {
      setState(() {
        this.isLoading = true;
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
              MCQExamUrls.GetStudentMCQExam,
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
              .map((item) => MCQExam.fromJson(item))
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
      this.isLoading = false;
    });

    return calendar;
  }
  Future<String> getImageUrl(MCQExam mcqExam) => NetworkHandler.getServerWorkingUrl()
      .then((connectionServerMsg) {
    if (connectionServerMsg != "key_check_internet") {
      return Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            'MCQ/GetMCQExamImage',
      ).replace(queryParameters: {
        "exam_id":
        mcqExam.examId.toString(),
        StudentFieldNames.brcode:
        AppData.current.student.brcode,
        "clientCode":
        AppData.current.user.clientCode
      }).toString();
    }
  });
  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

}