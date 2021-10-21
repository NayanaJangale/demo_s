import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/mcq_option.dart';

class MCQQuestion {
  int answerType;
  String groupContent;
  String groupInstruction;
  int levelId;
  double postiveMarks;
  String questionDesc;
  int questionGroupNo;
  String questionGroupTitle;
  int questionId;
  int sequenceNo;
  String qStatus = "N";
  bool isMarkForReview = false;
  List<MCQOption> options;
//add
  String answersDesc="";
  String answersOptions="";

  MCQQuestion({this.answerType, this.groupContent,
      this.groupInstruction, this.levelId, this.postiveMarks, this.questionDesc,
      this.questionGroupNo, this.questionGroupTitle, this.questionId,
  this.sequenceNo, this.options});

  MCQQuestion.fromMap(Map<String, dynamic> map) {
    answerType = map[MCQExamFieldsName.answerType] ?? 0;
    groupContent = map[MCQExamFieldsName.groupContent]  ?? StringHandlers.NotAvailable;
    groupInstruction = map[MCQExamFieldsName.groupInstruction]  ?? StringHandlers.NotAvailable;
    levelId = map[MCQExamFieldsName.levelId]  ?? 0;
    postiveMarks = map[MCQExamFieldsName.postiveMarks]  ?? 0.0;
    questionDesc = map[MCQExamFieldsName.questionDesc]  ??  StringHandlers.NotAvailable;
    questionGroupNo = map[MCQExamFieldsName.questionGroupNo]  ?? 0.0;
    questionGroupTitle = map[MCQExamFieldsName.questionGroupTitle]  ?? StringHandlers.NotAvailable;
    questionId = map[MCQExamFieldsName.questionId]  ??0;
    sequenceNo = map[MCQExamFieldsName.sequenceNo]  ??0;
    options = map[MCQExamFieldsName.options] != null
        ? (map[MCQExamFieldsName.options] as List)
        .map((item) => MCQOption.fromMap(item))
        .toList()
        : null;

  }
  /*factory MCQQuestion.fromJson(Map<String, dynamic> parsedJson) {
    return MCQQuestion(
      answerType: parsedJson[MCQExamFieldsName.answerType],
      groupContent: parsedJson[MCQExamFieldsName.groupContent],
      groupImage: parsedJson[MCQExamFieldsName.groupImage],
      groupInstruction: parsedJson[MCQExamFieldsName.groupInstruction],
      levelId: parsedJson[MCQExamFieldsName.levelId],
      postiveMarks: parsedJson[MCQExamFieldsName.postiveMarks],
      questionDesc: parsedJson[MCQExamFieldsName.questionDesc],
      questionGroupNo: parsedJson[MCQExamFieldsName.questionGroupNo],
      questionGroupTitle: parsedJson[MCQExamFieldsName.questionGroupTitle],
      questionId: parsedJson[MCQExamFieldsName.questionId],
      questionImage: parsedJson[MCQExamFieldsName.questionImage],
      sequenceNo: parsedJson[MCQExamFieldsName.sequenceNo],


    );
  }*/


  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQExamFieldsName.answerType: answerType,
    MCQExamFieldsName.groupContent: groupContent,
    MCQExamFieldsName.groupInstruction: groupInstruction,
    MCQExamFieldsName.levelId: levelId,
    MCQExamFieldsName.postiveMarks: postiveMarks,
    MCQExamFieldsName.questionDesc: questionDesc,
    MCQExamFieldsName.questionGroupNo: questionGroupNo,
    MCQExamFieldsName.questionGroupTitle: questionGroupTitle,
    MCQExamFieldsName.questionId: questionId,
    MCQExamFieldsName.sequenceNo: sequenceNo,

  };
}

class MCQExamFieldsName {
  static const String answerType = "answerType";
  static const String groupContent = "groupContent";
  static const String groupImage = "groupImage";
  static const String groupInstruction = "groupInstruction";
  static const String levelId = "levelId";
  static const String postiveMarks = "postiveMarks";
  static const String questionGroupNo = "questionGroupNo";
  static const String questionDesc = "questionDesc";
  static const String questionGroupTitle = "questionGroupTitle";
  static const String questionId = "questionId";
  static const String questionImage = "questionImage";
  static const String sequenceNo = "sequenceNo";
  static const String options = "options";
  static const String SingleChoice = "1";
  static const String MultiChoice = "2";
  static const String Discriptive = "3";
}


class MCQQuestionUrls {
  static const String GET_MCQQuestion = 'MCQ/GetMCQQuestion';
}


