import 'package:student/handlers/string_handlers.dart';

class Assessment {
  String exam_desc;
  int exam_id;
  String term_desc;
  int term_id;

  Assessment({
    this.exam_desc,
    this.exam_id,
    this.term_desc,
    this.term_id,
  });

  Assessment.fromMap(Map<String, dynamic> map) {
    exam_desc = map[AssessmentFieldNames.exam_desc] ?? StringHandlers.NotAvailable;
    exam_id = map[AssessmentFieldNames.exam_id] ?? 0;
    term_desc = map[AssessmentFieldNames.term_desc] ?? StringHandlers.NotAvailable;
    term_id = map[AssessmentFieldNames.term_id] ?? 0 ;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AssessmentFieldNames.exam_desc: exam_desc,
    AssessmentFieldNames.exam_id: exam_id,
    AssessmentFieldNames.term_desc: term_desc,
    AssessmentFieldNames.term_id: term_id,
  };
}

class AssessmentFieldNames {
  static const String exam_desc = "exam_desc";
  static const String exam_id = "exam_id";
  static const String term_desc = "term_desc";
  static const String term_id = "term_id";
}

class AssessmentUrls {
  static const String GET_ASSESMENTS = 'Exam/GetAllAssessments';
}
