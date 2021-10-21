import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_alert_dialog.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/custom_question_group.dart';
import 'package:student/components/custom_question_number.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/mcq_mark_for_review.dart';
import 'package:student/models/mcq_option.dart';
import 'package:student/models/mcq_question.dart';
import 'package:student/models/mcq_submit_exam.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/full_screen_image_page.dart';
import 'package:student/pages/home_page.dart';
import 'package:student/pages/mcq_exam_summary_page.dart';
import 'package:student/pages/select_section_page.dart';

class MCQExamPage extends StatefulWidget {
  int exam_id, exam_time, section_id;
  bool resultFlag;
  String examScheduleType, exam_type;

  MCQExamPage(
      {this.section_id,
        this.exam_time,
        this.exam_id,
        this.examScheduleType,
        this.exam_type,
        this.resultFlag
      });

  @override
  _MCQExamPageState createState() => _MCQExamPageState();
}

class _MCQExamPageState extends State<MCQExamPage> {
  bool _isLoading, isSubmitExam = false;
  PageController pageController = PageController();
  TextEditingController answersController = TextEditingController();
  String _loadingText, _subtitle;
  List<MCQQuestion> _queries = [];
  List<MCQQuestion> _tempqueries = [];
  List<MCQSubmitExam> submitExam = [];
  List<MCQMarksForReview> marksForReview = [];
  int _currentQueryNo = 0;
  int currentSection = 0;

  bool canceltimer = false;
  bool isSwitchSectionVisibility = false, isFixedExamEnd = false;
  String showtimer,QuestionType="";
  int timer, attempNo = 1;

  @override
  void initState() {
    print("section ${widget.section_id.toString()}");
    // TODO: implement initState
    super.initState();
    isSwitchSectionVisibility = widget.examScheduleType.toLowerCase() ==
        MCQExamConstant.examSheduleType.toLowerCase()
        ? true
        : false;
    showtimer = widget.exam_time.toString();

    if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
      for (int i = 0; i < AppData.current.mcqsection.length; i++) {
        if (AppData.current.mcqsection[i].sectionID == widget.section_id) {
          if (AppData.current.mcqsection[i].queries == null ||
              AppData.current.mcqsection[i].queries.length == 0) {
            getQuieries();
          } else {
            _queries = AppData.current.mcqsection[i].queries;
            for (int j = 0; j < _queries.length; j++) {
              if (_queries[j].qStatus == "A" || _queries[j].isMarkForReview) {
                if (_currentQueryNo < _queries.length - 1) _currentQueryNo++;
              }
            }
            starttimer();
          }
        }
      }
      timer = AppData.current.exam_time;
    } else {
      timer = widget.exam_time * 60;
      getQuieries();
    }

    this._isLoading = false;
    this._loadingText = 'Loading . .';
    this._subtitle =  'Your Exam is Start now';
  }

  @override
  Widget build(BuildContext context) {
    this._subtitle =  AppTranslations.of(context).text("key_exam_start_instruction");
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
        body: getQuestion(),
      ),
    );
  }

  void getQuieries() {
    fetchMCQQuestion().then((result) {
      setState(() {
        _queries = result;
        if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
          for (int i = 0; i < AppData.current.mcqsection.length; i++) {
            if (AppData.current.mcqsection != null) {
              if (AppData.current.mcqsection[i].sectionID ==
                  widget.section_id) {
                AppData.current.mcqsection[i].queries = _queries;
              }
            }
          }
        }
        starttimer();
      });
    });
  }

  Future<List<MCQQuestion>> fetchMCQQuestion() async {
    List<MCQQuestion> queries = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;

        Map<String, dynamic> params = {
          "exam_id": widget.exam_id.toString(),
          "section_id": widget.section_id.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              MCQQuestionUrls.GET_MCQQuestion,
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
                  (item) => MCQQuestion.fromMap(item),
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

  Widget getQuestion() {
    if (_queries != null && _queries.length > 0&&_queries[_currentQueryNo]
        .answerType
        .toString() ==
        MCQExamFieldsName.MultiChoice){
      setState(() {
        QuestionType = " Multi Choice";
      });
    }else if(_queries != null && _queries.length > 0 &&_queries[_currentQueryNo]
        .answerType
        .toString() ==
        MCQExamFieldsName.SingleChoice){
      setState(() {
        QuestionType = " Single Choice";
      });

    }else{
      setState(() {
        QuestionType = "Descriptive";
      });
    }
    if (_queries != null && _queries.length > 0)
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2, right: 2, bottom: 2, top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                AppTranslations.of(context).text("key_total_time")+" : ${showtimer}",
                                style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isSwitchSectionVisibility,
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.examScheduleType ==
                                      MCQExamConstant.examSheduleType) {
                                    AppData.current.exam_time = 0;
                                    AppData.current.exam_time = timer;
                                    for (int i = 0;
                                    i < AppData.current.mcqsection.length;
                                    i++) {
                                      if (AppData.current.mcqsection != null) {
                                        if (AppData.current.mcqsection[i]
                                            .sectionID ==
                                            widget.section_id) {
                                          AppData.current.mcqsection[i]
                                              .queries = _queries;
                                          break;
                                        }
                                      }
                                    }
                                  }

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SelectSectionPage(
                                          exam_type: widget.exam_type,
                                          exam_time: widget.exam_time,
                                          exam_id: widget.exam_id,
                                          examScheduleType:
                                          widget.examScheduleType,
                                        )),
                                  );
                                },
                                child: Container(
                                  child: Text(
                                    AppTranslations.of(context).text("key_switch_section"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Color(0xffbf4040),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: PageIndicator(
                                _currentQueryNo,
                                _queries.length,
                                onClickPageIndicatorItem,
                                _queries),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2, right: 2, top: 8, bottom: 4),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    AppTranslations.of(context).text("key_Answered"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12.0),
                                    color: Colors.green,
                                    width: 15,
                                    height: 15,
                                    child: Text(''),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    AppTranslations.of(context).text("key_review"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 12.0),
                                    color: Colors.orange,
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2, right: 2, bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 25,
                              child: RaisedButton(
                                onPressed: () {
                                  _queries[_currentQueryNo].isMarkForReview =
                                  true;
                                  //_queries[_currentQueryNo].qStatus = "A";
                                },
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 0, bottom: 0),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                elevation: 6,
                                child: Text(
                                  AppTranslations.of(context).text("key_mark_for_review"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              child: RaisedButton(
                                onPressed: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomActionDialog(
                                          actionName: AppTranslations.of(context).text("key_yes"),
                                          onActionTapped: () {
                                            Navigator.pop(context);
                                            if (widget.examScheduleType ==
                                                MCQExamConstant.examSheduleType) {
                                              submitSwitchExam();
                                            } else if (widget.exam_type ==
                                                MCQExamConstant.examType) {
                                              submitMcqExam();
                                            } else {
                                              setState(() {
                                                isFixedExamEnd = true;
                                                timer=0;
                                              });

                                              // fixedSection();
                                            }
                                          },
                                          actionColor: Colors.green,
                                          message: widget.exam_type ==
                                              MCQExamConstant.examType
                                              ? AppTranslations.of(context).text("key_exam_submit_instruction")
                                              : AppTranslations.of(context).text("key_section_exam_submit_instruction"),
                                          onCancelTapped: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                  );
                                },
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 0, bottom: 0),
                                materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                elevation: 6,
                                child: Text(
                                  AppTranslations.of(context).text("key_submit_exam"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 2,
                        color: Colors.red,
                      ),
                      Visibility(
                          visible:
                          _queries[_currentQueryNo].questionGroupNo != 0
                              ? true
                              : false,
                          child: Container(
                              child: FutureBuilder<String>(
                                  future:
                                  getImageUrl(_queries[_currentQueryNo]),
                                  builder: (context,
                                      AsyncSnapshot<String> snapshot) {
                                    return CustomQuestionGroup(
                                      instruction: _queries[_currentQueryNo]
                                          .groupInstruction,
                                      groupDescription:
                                      _queries[_currentQueryNo]
                                          .groupContent,
                                      groupTitle: _queries[_currentQueryNo]
                                          .questionGroupTitle,
                                      networkPath: snapshot.data != null
                                          ? snapshot.data.toString()
                                          : '',
                                      question: _queries[_currentQueryNo],
                                    );
                                  }))),
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
                                _queries[_currentQueryNo].questionDesc + " ( "+ "Marks"+" " + _queries[_currentQueryNo].postiveMarks.toString()+"-"+QuestionType+" )"??
                                    _queries[_currentQueryNo].questionDesc+ " ( "+"Marks"+" "  + _queries[_currentQueryNo].postiveMarks.toString()+"-"+QuestionType+" )",
                                style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),

                          ],
                        ),
                      ),
                      FutureBuilder<String>(
                          future:
                          getquestionImageUrl(_queries[_currentQueryNo]),
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            _tempqueries.clear();
                            _tempqueries.add(_queries[_currentQueryNo]);
                            return Visibility(
                                visible: snapshot.data != null &&
                                    snapshot.data != '',
                                child: Card(
                                  elevation: 3.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FullScreenImagePage(
                                            dynamicObjects: _tempqueries,
                                            imageType: 'MCQuestion',
                                            photoIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                          }),
                      SizedBox(
                        height: 5,
                      ),
                      _queries[_currentQueryNo].options != null &&
                          _queries[_currentQueryNo].options.length > 0
                          ? ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(),
                        itemCount:
                        _queries[_currentQueryNo].options.length,
                        itemBuilder: (context, index) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              if (_queries[_currentQueryNo]
                                  .answerType
                                  .toString() ==
                                  MCQExamFieldsName.SingleChoice) {
                                for (MCQOption mcqoptions
                                in _queries[_currentQueryNo]
                                    .options) {
                                  mcqoptions.isSelected = false;
                                }
                                _queries[_currentQueryNo]
                                    .options[index]
                                    .isSelected = true;
                                _queries[_currentQueryNo].qStatus = "A";
                              } else {
                                _queries[_currentQueryNo].qStatus = "A";
                                _queries[_currentQueryNo]
                                    .options[index]
                                    .isSelected =
                                !_queries[_currentQueryNo]
                                    .options[index]
                                    .isSelected;

                                /*for (int i = 0; i < _queries[_currentQueryNo].options.length; i++) {
                                        if (_queries[_currentQueryNo].options[i].isSelected) {}
                                      }*/
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                _queries[_currentQueryNo]
                                    .options[index]
                                    .isSelected
                                    ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                                    : Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    _queries[_currentQueryNo]
                                        .options[index]
                                        .optionDesc,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FutureBuilder<String>(
                                    future: getquestionOptionImageUrl(
                                        _queries[_currentQueryNo]
                                            .options[index],
                                        _queries[_currentQueryNo]
                                            .questionId),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      return Visibility(
                                        visible: snapshot.data != null &&
                                            snapshot.data != '',
                                        child: GestureDetector(
                                          behavior:
                                          HitTestBehavior.translucent,
                                          onTap: () {
                                            List<MCQOption> tempOptions =
                                            [];
                                            tempOptions.clear();
                                            MCQOption mcqOption = new MCQOption(
                                                answer: _queries[
                                                _currentQueryNo]
                                                    .options[index]
                                                    .answer,
                                                optionDesc: _queries[
                                                _currentQueryNo]
                                                    .options[index]
                                                    .optionDesc,
                                                optionId: _queries[
                                                _currentQueryNo]
                                                    .options[index]
                                                    .optionId,
                                                questionId: _queries[
                                                _currentQueryNo]
                                                    .questionId);
                                            tempOptions.add(mcqOption);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    FullScreenImagePage(
                                                      dynamicObjects:
                                                      tempOptions,
                                                      imageType: 'MCQOption',
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
                                                    const EdgeInsets.all(
                                                        8.0),
                                                    child: AspectRatio(
                                                      aspectRatio: 16 / 9,
                                                      child: Image.network(
                                                        snapshot.data == null
                                                            ? ""
                                                            : snapshot.data
                                                            .toString(),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              placeholder:
                                                  (context, url) =>
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 50.0,
                                                        right: 60.0,
                                                        top: 60.0,
                                                        bottom: 60.0),
                                                    child:
                                                    CircularProgressIndicator(
                                                      backgroundColor: Theme
                                                          .of(context)
                                                          .secondaryHeaderColor,
                                                    ),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
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
                          : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: answersController,
                          style:
                          Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          decoration: InputDecoration(
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              hintMaxLines: 10,
                              hintText: AppTranslations.of(context).text("key_ans_desc")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (_currentQueryNo > 0) _currentQueryNo--;

                      submitExam.removeLast();
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (_currentQueryNo < _queries.length - 1) {
                        _currentQueryNo++;
                      }
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.skip_next,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          AppTranslations.of(context).text("key_skip"),
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
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_currentQueryNo < _queries.length) {
                      if (_queries[_currentQueryNo].answerType.toString() ==
                          MCQExamFieldsName.Discriptive) {
                        if (answersController.text == null ||
                            answersController.text == "") {
                          FlushbarMessage.show(
                              context,
                              null,
                              AppTranslations.of(context).text("key_enter_question_desc"),
                              MessageTypes.WARNING);
                        } else {
                          setState(() {
                            _queries[_currentQueryNo].qStatus = "A";
                            _queries[_currentQueryNo].answersDesc =
                                answersController.text.toString();
                            submitExam.add(new MCQSubmitExam(
                                _queries[_currentQueryNo].questionId,
                                widget.section_id,
                                attempNo,
                                _queries[_currentQueryNo].isMarkForReview
                                    ? 1
                                    : 0,
                                answersController.text.toString(),
                                ""));

                            answersController.clear();

                            if (_currentQueryNo < _queries.length - 1) {
                              _currentQueryNo++;
                            } else {
                              if (widget.examScheduleType ==
                                  MCQExamConstant.examSheduleType) {
                                for (int i = 0;
                                i < AppData.current.mcqsection.length;
                                i++) {
                                  if (AppData.current.mcqsection[i].sectionID ==
                                      widget.section_id) {
                                    AppData.current.mcqsection[i].queries =
                                        _queries;
                                    break;
                                  }
                                }
                                switchSection();
                              } else if (widget.exam_type ==
                                  MCQExamConstant.examType) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomActionDialog(
                                        actionName: AppTranslations.of(context).text("key_yes"),
                                        onActionTapped: () {
                                          Navigator.pop(context);
                                          for (int i = 0;
                                          i < AppData.current.mcqsection.length;
                                          i++) {
                                            if (AppData.current.mcqsection[i]
                                                .sectionID ==
                                                widget.section_id) {
                                              AppData.current.mcqsection[i]
                                                  .queries = _queries;
                                              AppData.current.mcqsection[i]
                                                  .isSolved = true;
                                              break;
                                            }
                                          }
                                          submitMcqExam();
                                        },
                                        actionColor: Colors.green,
                                        message: widget.exam_type ==
                                            MCQExamConstant.examType
                                            ? AppTranslations.of(context).text("key_exam_submit_instruction")
                                            : AppTranslations.of(context).text("key_section_exam_submit_instruction"),
                                        onCancelTapped: () {
                                          setState(() {
                                            submitExam.removeLast();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                );
                              } else {
                                setState(() {
                                  isFixedExamEnd = false;
                                });
                                if(widget.section_id != AppData.current.mcqsection[(AppData.current.mcqsection.length-1)].sectionID){
                                  FlushbarMessage.show(
                                      context,
                                      null,
                                      AppTranslations.of(context).text("key_next_section_instruction"),
                                      MessageTypes.INFORMATION);
                                  fixedSection();
                                }else{
                                  fixedSection();
                                }
                              }
                            }
                          });
                        }
                      } else {
                        if (_queries[_currentQueryNo].qStatus != "A") {
                          FlushbarMessage.show(
                              context,
                              null,
                              AppTranslations.of(context).text("key_select_answers_instruction"),
                              MessageTypes.WARNING);
                        } else {
                          String options = "";

                          setState(() {
                            _queries[_currentQueryNo].qStatus = "A";
                            _queries[_currentQueryNo].answersOptions = options;

                            if (_queries != null || _queries.length > 0) {
                              for (int i = 0;
                              i < _queries[_currentQueryNo].options.length;
                              i++) {
                                if (_queries[_currentQueryNo]
                                    .options[i]
                                    .isSelected) {
                                  submitExam.add(new MCQSubmitExam(
                                      _queries[_currentQueryNo].questionId,
                                      widget.section_id,
                                      attempNo,
                                      _queries[_currentQueryNo].isMarkForReview
                                          ? 1
                                          : 0,
                                      answersController.text.toString(),
                                      _queries[_currentQueryNo]
                                          .options[i]
                                          .optionId
                                          .toString()));
                                }
                              }
                            }

                            answersController.clear();

                            if (_currentQueryNo < _queries.length - 1) {
                              _currentQueryNo++;
                            } else {
                              if (widget.examScheduleType ==
                                  MCQExamConstant.examSheduleType) {
                                for (int i = 0;
                                i < AppData.current.mcqsection.length;
                                i++) {
                                  if (AppData.current.mcqsection[i].sectionID ==
                                      widget.section_id) {
                                    AppData.current.mcqsection[i].queries =
                                        _queries;
                                    break;
                                  }
                                }
                                switchSection();
                              } else if (widget.exam_type ==
                                  MCQExamConstant.examType) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomActionDialog(
                                        actionName: AppTranslations.of(context).text("key_yes"),
                                        onActionTapped: () {
                                          Navigator.pop(context);
                                          for (int i = 0;
                                          i < AppData.current.mcqsection.length;
                                          i++) {
                                            if (AppData.current.mcqsection[i]
                                                .sectionID ==
                                                widget.section_id) {
                                              AppData.current.mcqsection[i]
                                                  .queries = _queries;
                                              AppData.current.mcqsection[i]
                                                  .isSolved = true;
                                              break;
                                            }
                                          }
                                          submitMcqExam();
                                        },
                                        actionColor: Colors.green,
                                        message: widget.exam_type ==
                                            MCQExamConstant.examType
                                            ? AppTranslations.of(context).text("key_exam_submit_instruction")
                                            : AppTranslations.of(context).text("key_section_exam_submit_instruction"),
                                        onCancelTapped: () {
                                          setState(() {
                                            submitExam.removeLast();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                );
                              } else {
                                setState(() {
                                  isFixedExamEnd = false;
                                });
                                if(widget.section_id != AppData.current.mcqsection[(AppData.current.mcqsection.length-1)].sectionID){
                                  fixedSection();
                                }else{
                                  fixedSection();
                                }
                              }
                            }
                          });
                        }
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding:
                      EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
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
              description: AppTranslations.of(context).text("key_question_not_available"),
            );
          },
        ),
      );
  }

  onClickPageIndicatorItem(int index) {

    if (widget.examScheduleType != MCQExamConstant.examType) {
      setState(() {
        _currentQueryNo = index;
      });

      pageController.animateToPage(index,
          duration: Duration(seconds: 1), curve: ElasticOutCurve(1));
    }

  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (isFixedExamEnd) {
          t.cancel();
        }
        if (timer < 1) {

          t.cancel();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        if (timer <= 1) {
          t.cancel();
          if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
            submitSwitchExam();
          } else if (widget.exam_type == MCQExamConstant.examType) {
            submitMcqExam();
          } else {
            setState(() {
              isFixedExamEnd = true;
            });
            fixedSection();
          }
        }

        showtimer = formatTime(timer);
      });
    });
  }

  void submitSwitchExam() {
    submitExam.clear();
    for (int i = 0; i < AppData.current.mcqsection.length; i++) {
      if (AppData.current.mcqsection != null) {
        if (AppData.current.mcqsection[i].sectionID == widget.section_id) {
          AppData.current.mcqsection[i].queries = _queries;
        }
      }
    }
    //Add Solved and marked in to Submittexam
    for (int i = 0; i < AppData.current.mcqsection.length; i++) {
      if (AppData.current.mcqsection != null) {
        for (int j = 0; j < AppData.current.mcqsection[i].queries.length; j++) {
          String options = "";
          if (AppData.current.mcqsection[i].queries != null || AppData.current.mcqsection[i].queries.length > 0) {
            for (int l = 0; l < AppData.current.mcqsection[i].queries[j].options.length; l++) {
              if (AppData.current.mcqsection[i].queries[j].options[l].isSelected) {
                if (options != "") options += ",";
                options += AppData.current.mcqsection[i].queries[j]
                    .options[l]
                    .optionId
                    .toString();

                print(options);
              }
            }
          }
          // AppData.current.mcqsection[i].queries[j].qStatus = "A";
          AppData.current.mcqsection[i].queries[j].answersOptions = options;

          if (AppData.current.mcqsection[i].queries[j].qStatus == "A" ||
              AppData.current.mcqsection[i].queries[j].isMarkForReview) {
            if (AppData.current.mcqsection[i].queries[j].answerType
                .toString() ==
                MCQExamFieldsName.MultiChoice) {
              for (int l = 0;
              l < AppData.current.mcqsection[i].queries[j].options.length;
              l++) {
                if (AppData
                    .current.mcqsection[i].queries[j].options[l].isSelected) {
                  submitExam.add(new MCQSubmitExam(
                      AppData.current.mcqsection[i].queries[j].questionId,
                      AppData.current.mcqsection[i].sectionID,
                      attempNo,
                      AppData.current.mcqsection[i].queries[j].isMarkForReview
                          ? 1
                          : 0,
                      AppData.current.mcqsection[i].queries[j].answersDesc,
                      AppData
                          .current.mcqsection[i].queries[j].options[l].optionId
                          .toString()));
                }
              }
            } else {
              submitExam.add(new MCQSubmitExam(
                  AppData.current.mcqsection[i].queries[j].questionId,
                  AppData.current.mcqsection[i].sectionID,
                  attempNo,
                  AppData.current.mcqsection[i].queries[j].isMarkForReview
                      ? 1
                      : 0,
                  AppData.current.mcqsection[i].queries[j].answersDesc,
                  AppData.current.mcqsection[i].queries[j].answersOptions));
            }
          }
        }
      }
    }
    submitMcqExam();
  }

  String formatTime(int time) {
    Duration duration = Duration(seconds: time);
    String sDuration =
        "${duration.inHours.toString().padLeft(2, "0")}:${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${(duration.inSeconds.remainder(60).toString().padLeft(2, "0"))}";

    return sDuration;
  }

  Future<void> submitMcqExam() async {
    try {
      setState(() {
        isSubmitExam = true;
        _isLoading = true;
        _loadingText = 'Saving . .';
      });

      if (submitExam == null || submitExam.length == 0) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      } else {
        String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
        if (connectionServerMsg != "key_check_internet") {
          User user = AppData.current.user;
          Student student = AppData.current.student;

          Map<String, dynamic> params = {
            StudentFieldNames.stud_no: student.stud_no.toString(),
            "examId": widget.exam_id.toString(),
            StudentFieldNames.brcode: student.brcode,
            StudentFieldNames.yr_no: student.yr_no.toString(),
          };

          Uri saveAttendanceUri = NetworkHandler.getUri(
              connectionServerMsg +
                  ProjectSettings.rootUrl +
                  MCQExamUrls.SubmitStudentMCQExam,
              params);
          String data = json.encode(submitExam);
          print(data);
          Response response = await post(
            saveAttendanceUri,
            headers: {
              "Accept": "application/json",
              "content-type": "application/json"
            },
            body: data,
            encoding: Encoding.getByName("utf-8"),
          );

          if (response.statusCode == HttpStatusCodes.CREATED) {
            FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_exam_submitted_successfully"),
              MessageTypes.INFORMATION,
            );
            AppData.current.clear();
            submitExam.clear();
            AppData.current.mcqsection.clear();

            if(widget.resultFlag == true){
              Navigator.pushReplacement(
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

            /* if (widget.exam_type == MCQExamConstant.examType) {
              submitExam.clear();
              AppData.current.mcqsection.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => McqExamSummaryPage(
                      exam_id: widget.exam_id,
                    )),
              );
            } else {
              submitExam.clear();
              AppData.current.mcqsection.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => McqExamSummaryPage(
                      exam_id: widget.exam_id,
                    )),
              );
              // fixedSection();
            }*/
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

  Future<bool> _onBackPressed() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CustomActionDialog(
        actionName: AppTranslations.of(context).text("key_yes"),
        onActionTapped: () {
          Navigator.pop(context);
          if (widget.examScheduleType == MCQExamConstant.examSheduleType) {
            submitSwitchExam();
            //Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          } else if (widget.exam_type == MCQExamConstant.examType) {
            submitMcqExam();
          } else {
            setState(() {
              isFixedExamEnd = true;
              timer = 0;
            });
            //fixedSection();
          }
          //Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        },
        actionColor: Colors.green,
        message: AppTranslations.of(context).text("key_exit_submit_exam_intruction"),
        onCancelTapped: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<String> getImageUrl(MCQQuestion mcqQuestion) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'MCQ/GetQuestionGroupImage',
          ).replace(queryParameters: {
            "questionGroupNo": mcqQuestion.questionGroupNo.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.user.clientCode
          }).toString();
        }
      });

  Future<String> getquestionImageUrl(MCQQuestion mcqQuestion) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'MCQ/GetQuestionImage',
          ).replace(queryParameters: {
            "questionId": mcqQuestion.questionId.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.user.clientCode
          }).toString();
        }
      });

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

  void fixedSection() {
    int tempQno = 0;
    List<MCQQuestion> tempQueries = [];
    setState(() {
      for (int i = 0; i < AppData.current.mcqsection.length; i++) {
        if (AppData.current.mcqsection[i].sectionID == widget.section_id) {
          AppData.current.mcqsection[i].queries = _queries;
          AppData.current.mcqsection[i].isSolved = true;
          break;
        }
      }

      if (!isFixedExamEnd) {
        for (int i = 0; i <= AppData.current.mcqsection.length; i++) {
          if (!AppData.current.mcqsection[i].isSolved) {
            currentSection = AppData.current.mcqsection[i].sectionID;
            widget.section_id = AppData.current.mcqsection[i].sectionID;
            fetchMCQQuestion().then((result) {
              setState(() {
                tempQueries = result;
                _queries = result;
                AppData.current.mcqsection[i].queries = tempQueries;
                tempQno = 0;

                for (int j = 0; j < tempQueries.length; j++) {
                  if (tempQueries[j].qStatus == "A" ||
                      tempQueries[j].isMarkForReview) {
                    if (tempQno < tempQueries.length - 1) tempQno++;
                  } else {
                    tempQueries = AppData.current.mcqsection[i].queries;
                    _queries = tempQueries;
                    _currentQueryNo = tempQno;
                  }
                }
              });
            });
            break;
          }
          if (i == AppData.current.mcqsection.length - 1) {
            if (AppData.current.mcqsection[i].isSolved) {
              isFixedExamEnd = true;
              if (timer > 2) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CustomActionDialog(
                    actionName: AppTranslations.of(context).text("key_yes"),
                    onActionTapped: () {
                      Navigator.pop(context);
                      submitSwitchExam();
                    },
                    actionColor: Colors.green,
                    message: widget.exam_type == MCQExamConstant.examType
                        ? AppTranslations.of(context).text("key_exam_submit_instruction")
                        : AppTranslations.of(context).text("key_section_exam_submit_instruction"),

                    onCancelTapped: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              } else {
                if (isFixedExamEnd) submitSwitchExam();
              }
            }
          }
        }
      } else {
        isFixedExamEnd = true;
        if (timer > 2) {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CustomActionDialog(
              actionName: AppTranslations.of(context).text("key_yes"),
              onActionTapped: () {
                Navigator.pop(context);
                submitSwitchExam();
              },
              actionColor: Colors.green,
              message: widget.exam_type == MCQExamConstant.examType
                  ? AppTranslations.of(context).text("key_exam_submit_instruction")
                  : AppTranslations.of(context).text("key_section_exam_submit_instruction"),

              onCancelTapped: () {
                Navigator.pop(context);
              },
            ),
          );
        } else {
          if (isFixedExamEnd) submitSwitchExam();
        }
      }
    });
  }
  void switchSection() {
    int tempQno = 0;
    bool isEndExam = true;
    List<MCQQuestion> tempQueries = [];
    int len = AppData.current.mcqsection.length;
    for (int i = 0; i < AppData.current.mcqsection.length; i++) {
      setState(() {
        //_queries = AppData.current.mcqsection[i].queries;
        if (AppData.current.mcqsection[i].queries == null ||
            AppData.current.mcqsection[i].queries.length == 0) {
          setState(() {
            widget.section_id = AppData.current.mcqsection[i].sectionID;
            isEndExam = false;
          });

          fetchMCQQuestion().then((result) {
            setState(() {
              tempQueries = result;
              _queries = result;
              AppData.current.mcqsection[i].queries = tempQueries;
              tempQno = 0;

              for (int j = 0; j < tempQueries.length; j++) {
                if (tempQueries[j].qStatus == "A" ||
                    tempQueries[j].isMarkForReview) {
                  if (tempQno < tempQueries.length - 1) tempQno++;
                } else {
                  tempQueries = AppData.current.mcqsection[i].queries;
                  isEndExam = false;
                  _queries = tempQueries;
                  _currentQueryNo = tempQno;
                  break;
                }
              }
            });
          });
        } else {
          for (int j = 0;
          j < AppData.current.mcqsection[i].queries.length;
          j++) {
            if (AppData.current.mcqsection[i].queries[j].qStatus == "A" ||
                AppData.current.mcqsection[i].queries[j].isMarkForReview) {
              if (tempQno < AppData.current.mcqsection[i].queries.length - 1)
                tempQno++;
            } else {
              tempQueries = AppData.current.mcqsection[i].queries;
              isEndExam = false;

              widget.section_id = AppData.current.mcqsection[i].sectionID;

              _queries = tempQueries;
              _currentQueryNo = tempQno;
            }
          }
        }

        if (i == (len - 1)) {
          if (isEndExam) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CustomActionDialog(
                actionName: AppTranslations.of(context).text("key_yes"),
                onActionTapped: () {
                  Navigator.pop(context);
                  submitSwitchExam();
                },
                actionColor: Colors.green,
                message: widget.exam_type == MCQExamConstant.examType
                    ? AppTranslations.of(context).text("key_exam_submit_instruction")
                    : AppTranslations.of(context).text("key_section_exam_submit_instruction"),

                onCancelTapped: () {
                  Navigator.pop(context);
                },
              ),
            );
          }
        }
      });
    }
  }
}