import 'package:student/handlers/string_handlers.dart';

class MCQSummary {
  int totalquestions ;
  int attemptedquestions ;
  int rightquestionscnt  ;
  int wrongquestionscnt  ;
  int markforreviewquecnt  ;
  int skipquestionscnt   ;



  MCQSummary({
    this.totalquestions,
    this.attemptedquestions,
    this.rightquestionscnt,
    this.wrongquestionscnt,
    this.markforreviewquecnt,
    this.skipquestionscnt,
  });

  MCQSummary.fromMap(Map<String, dynamic> map) {
    totalquestions = map[MCQSUMMARYFieldNames.totalquestions] ?? 0;
    attemptedquestions = map[MCQSUMMARYFieldNames.attemptedquestions] ?? 0;
    rightquestionscnt = map[MCQSUMMARYFieldNames.rightquestionscnt] ?? 0;
    wrongquestionscnt = map[MCQSUMMARYFieldNames.wrongquestionscnt] ?? 0;
    markforreviewquecnt = map[MCQSUMMARYFieldNames.markforreviewquecnt] ?? 0;
    skipquestionscnt = map[MCQSUMMARYFieldNames.skipquestionscnt] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQSUMMARYFieldNames.totalquestions: totalquestions,
    MCQSUMMARYFieldNames.attemptedquestions: attemptedquestions,
    MCQSUMMARYFieldNames.rightquestionscnt: rightquestionscnt,
    MCQSUMMARYFieldNames.wrongquestionscnt: wrongquestionscnt,
    MCQSUMMARYFieldNames.markforreviewquecnt: markforreviewquecnt,
    MCQSUMMARYFieldNames.skipquestionscnt: skipquestionscnt,
  };
}

class MCQSUMMARYFieldNames {
  static const String totalquestions = "totalquestions";
  static const String attemptedquestions = "attemptedquestions";
  static const String rightquestionscnt = "rightquestionscnt";
  static const String wrongquestionscnt = "wrongquestionscnt";
  static const String markforreviewquecnt = "markforreviewquecnt";
  static const String skipquestionscnt = "skipquestionscnt";
}

class MCQSummaryUrls {
  static const String GET_REVIEW_SUMMARY = 'MCQ/GetMcqExamSummary';
}
