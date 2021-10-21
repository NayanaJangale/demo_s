import 'package:student/handlers/string_handlers.dart';

class MCQAnswers {
  int questionId ;
  String studentAns;
  int studentAnsId;


  MCQAnswers({
    this.questionId,
    this.studentAns,
    this.studentAnsId,

  });

  MCQAnswers.fromMap(Map<String, dynamic> map) {
    questionId = map[MCQOptionFieldNames.questionId] ?? 0;
    studentAns = map[MCQOptionFieldNames.studentAns] ?? StringHandlers.NotAvailable;
    studentAnsId = map[MCQOptionFieldNames.studentAnsId] ?? 0;


  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQOptionFieldNames.questionId: questionId,
    MCQOptionFieldNames.studentAns: studentAns,
    MCQOptionFieldNames.studentAnsId: studentAnsId,

  };
}

class MCQOptionFieldNames {
  static const String questionId = "questionId";
  static const String studentAnsId = "studentAnsId";
  static const String studentAns = "studentAns";
}


