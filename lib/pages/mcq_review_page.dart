
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
import 'package:student/models/mcq_option.dart';
import 'package:student/models/mcq_review.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/full_screen_image_page.dart';
import 'package:url_launcher/url_launcher.dart';

class McqExamReviewPage extends StatefulWidget {
  int exam_id;

  McqExamReviewPage({this.exam_id});

  @override
  _McqExamReviewPage createState() => _McqExamReviewPage();
}

class _McqExamReviewPage extends State<McqExamReviewPage> {
  bool isLoading = false;
  String filter, loadingText;
  List<MCQReview> mcqReview = [];
  int studAns;

  @override
  void initState() {
    super.initState();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';

    fetchMCQReview().then((result) {
      mcqReview = result;
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
              subtitle:  AppTranslations.of(context).text("key_see_your_exam_review"),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              fetchMCQReview().then((result) {
                mcqReview = result;
              });
            },
            child: getReview(),
          ),
          //ModalProgressHUD(child: _createBody(), inAsyncCall: isLoading), //
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget getReview() {
    if (mcqReview != null && mcqReview.length > 0)
      return Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: ListView.separated(
                itemCount: mcqReview.length,
                itemBuilder: (context, index) {
                  //studAns = mcqReview[index].studentAnsId;
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
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
                                  mcqReview[index].questionDesc+" ( " +"Marks"+" " + mcqReview[index].postiveMarks.toString() +" ) "??
                                      mcqReview[index].questionDesc+" ( "+ "Marks"+" "+  mcqReview[index].postiveMarks.toString()+" ) ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        mcqReview[index].options != null &&
                            mcqReview[index].options.length > 0
                            ? Wrap(
                          children: <Widget>[
                            ListView.separated(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              separatorBuilder: (context, index) => Divider(
                                height: 2.0,
                                color: Colors.black12,
                                indent: 25.0,
                                // thickness: 1.0,
                              ),
                              itemCount: mcqReview[index].options.length,
                              itemBuilder: (context, rowIndex) =>
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 0.0,
                                        bottom: 3.0,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              '${rowIndex + 1}.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              mcqReview[index]
                                                  .options[rowIndex]
                                                  .optionDesc,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                color: getColor(
                                                    mcqReview[index]
                                                        .options[rowIndex],
                                                    index),
                                                //color: mcqReview[index].correctAnsId == mcqReview[index].studentAnsId && mcqReview[index].studentAnsId == mcqReview[index].options[rowIndex].optionId ?
                                                // Colors.green:
                                                //mcqReview[index].studentAnsId == mcqReview[index].options[rowIndex].optionId ? Colors.red:  mcqReview[index].correctAnsId == mcqReview[index].options[rowIndex].optionId ? Colors.green :Colors.black54,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          FutureBuilder<String>(
                                              future: getquestionOptionImageUrl(
                                                  mcqReview[index]
                                                      .options[rowIndex],
                                                  mcqReview[index].questionId),
                                              builder: (context,
                                                  AsyncSnapshot<String>
                                                  snapshot) {
                                                return Visibility(
                                                  visible:
                                                  snapshot.data != null &&
                                                      snapshot.data != '',
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      List<MCQOption>
                                                      tempOptions = [];
                                                      tempOptions.clear();
                                                      MCQOption mcqOption =
                                                      new MCQOption(
                                                          answer: mcqReview[
                                                          index]
                                                              .options[
                                                          rowIndex]
                                                              .answer,
                                                          optionDesc:
                                                          mcqReview[index]
                                                              .options[
                                                          rowIndex]
                                                              .optionDesc,
                                                          optionId: mcqReview[
                                                          index]
                                                              .options[
                                                          rowIndex]
                                                              .optionId,
                                                          questionId:
                                                          mcqReview[index]
                                                              .questionId);
                                                      tempOptions.add(mcqOption);

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              FullScreenImagePage(
                                                                dynamicObjects:
                                                                tempOptions,
                                                                imageType:
                                                                'MCQOption',
                                                                photoIndex: 0,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 70,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                        snapshot.data == null
                                                            ? ""
                                                            : snapshot.data
                                                            .toString(),
                                                        imageBuilder: (context,
                                                            imageProvider) =>
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
                                                              child: AspectRatio(
                                                                aspectRatio: 16 / 9,
                                                                child: Image.network(
                                                                  snapshot.data ==
                                                                      null
                                                                      ? ""
                                                                      : snapshot.data
                                                                      .toString(),
                                                                  fit:
                                                                  BoxFit.fitWidth,
                                                                ),
                                                              ),
                                                            ),
                                                        placeholder:
                                                            (context, url) =>
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 50.0,
                                                                  right: 60.0,
                                                                  top: 0.0,
                                                                  bottom: 0.0),
                                                              child:
                                                              CircularProgressIndicator(
                                                                backgroundColor: Theme
                                                                    .of(context)
                                                                    .secondaryHeaderColor,
                                                              ),
                                                            ),
                                                        errorWidget: (context,
                                                            url, error) =>
                                                            Container(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                            )
                          ],
                        )
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Student Answer : ",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${mcqReview[index].answerDesc}',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ), //here and description
                        ),
                        Visibility(
                          visible: mcqReview[index].answerExplaination != "" &&
                              mcqReview[index].answerExplaination != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Explaination",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              Text(
                                '${mcqReview[index].answerExplaination}',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        FutureBuilder<String>(
                            future: getExplanationImageUrl(
                                mcqReview[index].questionId),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              return Visibility(
                                visible: snapshot.data != null &&
                                    snapshot.data != '',
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImagePage(
                                          dynamicObjects: mcqReview,
                                          imageType: 'MCQReview',
                                          photoIndex: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data == null
                                        ? ""
                                        : snapshot.data,
                                    imageBuilder: (context, imageProvider) =>
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Image.network(
                                              snapshot.data == null
                                                  ? ""
                                                  : snapshot.data,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4),
                                      child: LinearProgressIndicator(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  ),
                                ),
                              );
                            }),
                        Visibility(
                          visible: mcqReview[index].explainationLink != "" &&
                              mcqReview[index].explainationLink != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Explaination Link",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  '${mcqReview[index].explainationLink}',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 16),
                                ),
                                onTap: () {
                                  _launchURL(mcqReview[index].explainationLink);
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: mcqReview[index].questionReference != "" &&
                              mcqReview[index].questionReference != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text(
                                  "Question Reference : ",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                  child:  Text(
                                    '${mcqReview[index].questionReference}',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16),
                                  )
                              ),
                            ],
                          ),
                        ),
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
              )),
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CustomDataNotFound(
              description:  AppTranslations.of(context).text("key_review_summary_not_available"),
            );
          },
        ),
      );
  }

  Future<List<MCQReview>> fetchMCQReview() async {
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
                MCQReviewUrls.GET_MCQ_REVIEW,
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
            mcqReview =
                responseData.map((item) => MCQReview.fromMap(item)).toList();
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

    return mcqReview;
  }

  Future<bool> _onBackPressed() {
    Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
  }

  Future<String> getExplanationImageUrl(int questionId) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'MCQ/GetExplainationImage',
          ).replace(queryParameters: {
            "questionId": questionId.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.user.clientCode
          }).toString();
        }
      });

  _launchURL(String url) async {
    //const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> getquestionOptionImageUrl(
      MCQOption mcqOption, int questionid) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'MCQ/GetQuestionOptionImage',
          ).replace(queryParameters: {
            "optionId": mcqOption.optionId.toString(),
            "questionId": questionid.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.user.clientCode
          }).toString();
        }
      });

  Color getColor(MCQOption mcqOption, int index) {
    Color tempColor = Colors.black54;
    for (int i = 0; i < mcqReview[index].answers.length; i++) {
      if (mcqReview[index].answers[i].studentAnsId == mcqOption.optionId &&
          !mcqOption.answer) {
        tempColor = Colors.red;
      } else if (mcqOption.answer) {
        tempColor = Colors.green;
      }
    }

    return tempColor;
  }
}

