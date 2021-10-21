
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
import 'package:student/models/mcq_result.dart';
import 'package:student/models/mcq_summary.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/mcq_review_page.dart';



class McqExamSummaryPage extends StatefulWidget {
  int exam_id;

  McqExamSummaryPage({this.exam_id});

  @override
  _McqExamSummaryPage createState() => _McqExamSummaryPage();
}

class _McqExamSummaryPage extends State<McqExamSummaryPage> {
  bool isLoading = false;
  String filter, loadingText;
  List<MCQSummary> mcqSummary = [];
  List<MCQResult> mcqResult = [];

  @override
  void initState() {
    super.initState();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';

    fetchMCQSummary().then((result) {
      mcqSummary = result;
    });
    fetchMCQResult().then((result) {
      mcqResult = result;
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
              subtitle:AppTranslations.of(context).text("key_see_exam_summary"),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              fetchMCQSummary().then((result) {
                mcqSummary = result;
              });
              fetchMCQResult().then((result) {
                mcqResult = result;
              });
            },
            child: getReview(),
          ), //ModalProgressHUD(child: _createBody(), inAsyncCall: isLoading), //
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget getReview() {
    if (mcqSummary != null && mcqSummary.length > 0)
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8,top: 8),
              child: Text(
                AppTranslations.of(context).text("key_question_summary"),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color:Theme.of(context).primaryColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: ListView.separated(
                  itemCount: mcqSummary.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(.4),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(),
                                            Container(),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                AppTranslations.of(context).text("key_total_question"),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqSummary[index].totalquestions.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                AppTranslations.of(context).text("key_Answered"),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqSummary[index].attemptedquestions.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                AppTranslations.of(context).text("key_skip_que"),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqSummary[index].skipquestionscnt.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                AppTranslations.of(context).text("key_mark_for_review_ques"),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqSummary[index].markforreviewquecnt.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 2.0,
                      color: Colors.black12,
                      indent: 25.0,
                      // thickness: 1.0,
                    );
                  },
                )
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8,top: 8),
              child: Text(
                AppTranslations.of(context).text("key_result_summary"),
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color:Theme.of(context).primaryColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                child: ListView.separated(
                  itemCount: mcqResult.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Table(
                                      columnWidths: {
                                        0: FractionColumnWidth(.4),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(),
                                            Container(),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                "Total Marks",
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqResult[index].totalMarks.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                "Obtained Marks",
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqResult[index].obtainMarks.toString(),
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                          ),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                "Percetage",
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                              ),
                                              child: Text(
                                                mcqResult[index].Percetage.toString()+" % ",
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 2.0,
                      color: Colors.black12,
                      indent: 25.0,
                      // thickness: 1.0,
                    );
                  },
                )
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => McqExamReviewPage(
                    exam_id: widget.exam_id,
                  ),
                ),
              );


            },
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    AppTranslations.of(context).text("key_view_review_in_detail"),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CustomDataNotFound(
              description:  AppTranslations.of(context).text("key_summary_not_available"),
            );
          },
        ),
      );
  }
  Future<List<MCQSummary>> fetchMCQSummary() async {
    try {
      setState(() {
        isLoading = true;
        this.loadingText = "loading...";
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "exam_id": widget.exam_id.toString(),
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchClassesUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                MCQSummaryUrls.GET_REVIEW_SUMMARY,
            params);

        Response response = await get(fetchClassesUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            '',
            response.body.toString(),
            MessageTypes.WARNING,
          );
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            mcqSummary =
                responseData.map((item) => MCQSummary.fromMap(item)).toList();
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
      isLoading = false;
    });

    return mcqSummary;
  }
  Future<List<MCQResult>> fetchMCQResult() async {
    try {
      setState(() {
        isLoading = true;
        this.loadingText = "loading...";
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "exam_id": widget.exam_id.toString(),
          "stud_no": AppData.current.student.stud_no.toString(),
          "yr_no": AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchClassesUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                MCQResultUrls.GET_MCQ_RESLUT,
            params);

        Response response = await get(fetchClassesUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            '',
            response.body.toString(),
            MessageTypes.WARNING,
          );
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            mcqResult =
                responseData.map((item) => MCQResult.fromMap(item)).toList();
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
      isLoading = false;
    });

    return mcqResult;
  }


  Future<bool> _onBackPressed() {
    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  }
}