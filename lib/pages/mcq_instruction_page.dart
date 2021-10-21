import 'package:flutter/material.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_clipshape.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/mcq_exam.dart';
import 'package:student/pages/mcq_exam_page.dart';
import 'package:student/pages/select_section_page.dart';
class MCQInstructionPage extends StatefulWidget {
  String instruction, examType, examScheduleType ;
  int exam_id, exam_time;
  bool resultFlag;
  MCQInstructionPage({this.instruction,this.exam_id, this.examType,this.examScheduleType,this.exam_time,this.resultFlag});

  @override
  _MCQInstructionPageState createState() => _MCQInstructionPageState();
}

class _MCQInstructionPageState extends State<MCQInstructionPage> {
  bool isLoading = false;
  String filter, loadingText;
  @override
  void initState() {
    super.initState();
    loadingText = 'Loading . . .';
  }
  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                CustomClipShape(),
                Padding(
                  padding: const EdgeInsets.only(right: 40,top: 90),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      AppTranslations.of(context).text("key_exam_instruction"),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          letterSpacing: 1.2),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4,right: 4,bottom: 4),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(3.0),
                          bottomRight: Radius.circular(3.0),
                          bottomLeft: Radius.circular(3.0),
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.instruction!= null? widget.instruction :"",
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              AppTranslations.of(context).text("key_key_best_luck_instruction"),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if(widget.examType == MCQExamConstant.examType){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MCQExamPage(
                        resultFlag :widget.resultFlag,
                        section_id: 0,
                        exam_time:widget.exam_time,
                        exam_id: widget.exam_id,
                        examScheduleType: widget.examScheduleType,
                        exam_type : widget.examType,
                      ),
                    ),
                  );
                }else{
                  AppData.current.mcqsection.clear();
                  AppData.current.exam_time = widget.exam_time *60;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectSectionPage(
                          exam_time:widget.exam_time,
                          exam_id: widget.exam_id,
                          examScheduleType: widget.examScheduleType,
                          exam_type : widget.examType,
                          resultFlag :widget.resultFlag
                      ),
                    ),
                  );
                }
              },
              child: widget.examType == MCQExamConstant.examType ? Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      AppTranslations.of(context).text("key_start_exam"),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ):Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      AppTranslations.of(context).text("key_start_proceed"),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ) ,
            ),
          ],
        ), //ModalProgressHUD(child: _createBody(), inAsyncCall: isLoading), //
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}