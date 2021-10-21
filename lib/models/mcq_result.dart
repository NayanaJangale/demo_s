

class MCQResult {
  double Percetage;
  int examId;
  double obtainMarks;
  int stud_no;
  double totalMarks;

  MCQResult({
    this.Percetage,
    this.examId,
    this.obtainMarks,
    this.stud_no,
    this.totalMarks
  });

  MCQResult.fromMap(Map<String, dynamic> map) {
    Percetage = map[MCQResultFieldNames.Percetage] ?? 0.0;
    examId = map[MCQResultFieldNames.examId] ?? 0;
    obtainMarks = map[MCQResultFieldNames.obtainMarks] ?? 0.0;
    stud_no = map[MCQResultFieldNames.stud_no] ?? 0;
    totalMarks = map[MCQResultFieldNames.totalMarks] ?? 0.0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQResultFieldNames.Percetage: Percetage,
    MCQResultFieldNames.examId: examId,
    MCQResultFieldNames.obtainMarks: obtainMarks,
    MCQResultFieldNames.stud_no: stud_no,
    MCQResultFieldNames.totalMarks: totalMarks,
  };
}


class MCQResultFieldNames {
  static const String Percetage = "Percetage";
  static const String examId = "examId";
  static const String obtainMarks = "obtainMarks";
  static const String stud_no = "stud_no";
  static const String totalMarks = "totalMarks";
}

class MCQResultUrls {
  static const String GET_MCQ_RESLUT =
      'MCQ/GetMcqExamResult';
}
