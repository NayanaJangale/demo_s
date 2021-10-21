import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/mcq_option.dart';

class MCQSubmitExam {
  int questionId;
  int sectionId;
  int attemptNo;
  int marksforReview;
  String answerDesc;
  String options;



  MCQSubmitExam(this.questionId,this.sectionId,this.attemptNo, this.marksforReview,
      this.answerDesc, this.options);

  MCQSubmitExam.fromMap(Map<String, dynamic> map) {
    questionId = map[MCQSubmitExamFieldsName.questionId]  ?? 0;
    sectionId = map[MCQSubmitExamFieldsName.sectionId]  ?? 0;
    attemptNo = map[MCQSubmitExamFieldsName.attemptNo] ?? 0;
    marksforReview = map[MCQSubmitExamFieldsName.marksforReview] ?? 0;
    answerDesc = map[MCQSubmitExamFieldsName.answerDesc] ?? 0;
    options = map[MCQSubmitExamFieldsName.options] ?? StringHandlers.NotAvailable;
   
  }
 /* factory MCQSubmitExam.fromJson(Map<String, dynamic> parsedJson) {
    return MCQSubmitExam(
      questionId: parsedJson[MCQSubmitExamFieldsName.questionId],
      attemptNo: parsedJson[MCQSubmitExamFieldsName.attemptNo],
      marksforReview: parsedJson[MCQSubmitExamFieldsName.marksforReview]


    );
  }*/

  Map<String, dynamic> toJson() => <String, dynamic>{
        MCQSubmitExamFieldsName.questionId: questionId,
        MCQSubmitExamFieldsName.sectionId: sectionId,
        MCQSubmitExamFieldsName.attemptNo: attemptNo,
        MCQSubmitExamFieldsName.marksforReview: marksforReview,
        MCQSubmitExamFieldsName.answerDesc: answerDesc,
        MCQSubmitExamFieldsName.options: options


  };
}

class MCQSubmitExamFieldsName {
  static const String attemptNo = "attemptNo";
  static const String questionId = "questionId";
  static const String sectionId = "sectionId";
  static const String examInstruction = "examInstruction";
  static const String marksforReview = "marksforReview";
  static const String answerDesc = "answerDesc";
  static const String options = "options";

}
class MCQExamUrls{
  static const String GetStudentMCQExam = 'MCQ/GetStudentMCQExam';
  static const String SubmitStudentMCQExam = 'MCQ/SubmitStudentMCQExam';
}
class MCQExamConstant{
  static const String examType = 'Uniform';
  static const String examSheduleType = 'Switch';
}


