import 'package:student/handlers/string_handlers.dart';

class MCQExam {
  int attemptNo;
  int examId;
  String examInstruction;
  String examTitle;
  String examType;
  String examScheduleType;
  int examTime;
  double TotalMarks;
  DateTime fromDate;
  DateTime uptoDate;
  bool ExamResultFlag =false;



  MCQExam({this.attemptNo, this.examId, this.examInstruction, this.examTitle,
      this.examType, this.examScheduleType, this.examTime,this.TotalMarks, this.fromDate,
      this.uptoDate, this.ExamResultFlag});

  MCQExam.fromMap(Map<String, dynamic> map) {
    attemptNo = map[MCQExamFieldsName.attemptNo] ?? 0;
    examId = map[MCQExamFieldsName.examId]  ?? 0;
    examInstruction = map[MCQExamFieldsName.examInstruction]  ?? StringHandlers.NotAvailable;
    examTitle = map[MCQExamFieldsName.examTitle]  ?? StringHandlers.NotAvailable;
    examType = map[MCQExamFieldsName.examType]  ?? StringHandlers.NotAvailable;
    examScheduleType = map[MCQExamFieldsName.examScheduleType]  ?? StringHandlers.NotAvailable;
    examTime = map[MCQExamFieldsName.examTime]  ?? 0;
    TotalMarks = map[MCQExamFieldsName.TotalMarks]  ?? 0.0;
    fromDate =  map[MCQExamFieldsName.fromDate ] != null &&
        map[MCQExamFieldsName.fromDate ].toString().trim() != ''
        ? DateTime.parse(map[MCQExamFieldsName.fromDate ])
        : null;
    uptoDate =  map[MCQExamFieldsName.uptoDate ] != null &&
        map[MCQExamFieldsName.uptoDate ].toString().trim() != ''
        ? DateTime.parse(map[MCQExamFieldsName.uptoDate ])
        : null;
    ExamResultFlag = map[MCQExamFieldsName.ExamResultFlag]  ?? false ;

  }
  factory MCQExam.fromJson(Map<String, dynamic> parsedJson) {
    return MCQExam(
      attemptNo: parsedJson[MCQExamFieldsName.attemptNo],
      examId: parsedJson[MCQExamFieldsName.examId],
      examInstruction: parsedJson[MCQExamFieldsName.examInstruction],
      examTitle: parsedJson[MCQExamFieldsName.examTitle],
      examType: parsedJson[MCQExamFieldsName.examType],
      examTime: parsedJson[MCQExamFieldsName.examTime],
      TotalMarks: parsedJson[MCQExamFieldsName.TotalMarks],
      examScheduleType: parsedJson[MCQExamFieldsName.examScheduleType],
      fromDate: parsedJson[MCQExamFieldsName.fromDate] != null
          ? DateTime.parse(parsedJson[MCQExamFieldsName.fromDate])
          : null,
      uptoDate: parsedJson[MCQExamFieldsName.uptoDate] != null
          ? DateTime.parse(parsedJson[MCQExamFieldsName.uptoDate])
          : null,
      ExamResultFlag: parsedJson[MCQExamFieldsName.ExamResultFlag] ?? false,

    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MCQExamFieldsName.attemptNo: attemptNo,
        MCQExamFieldsName.examId: examId,
        MCQExamFieldsName.examInstruction: examInstruction,
        MCQExamFieldsName.examTitle: examTitle,
        MCQExamFieldsName.examType: examType,
        MCQExamFieldsName.examScheduleType: examScheduleType,
        MCQExamFieldsName.examTime: examTime,
        MCQExamFieldsName.TotalMarks: TotalMarks,
    MCQExamFieldsName.fromDate :
    fromDate == null ? null : fromDate.toIso8601String(),
    MCQExamFieldsName.uptoDate :
    uptoDate == null ? null : uptoDate.toIso8601String(),
    MCQExamFieldsName.ExamResultFlag: ExamResultFlag,
  };
}

class MCQExamFieldsName {
  static const String attemptNo = "attemptNo";
  static const String examId = "examId";
  static const String examInstruction = "examInstruction";
  static const String examTitle = "examTitle";
  static const String examType = "examType";
  static const String examScheduleType = "examScheduleType";
  static const String examTime = "examTime";
  static const String TotalMarks = "TotalMarks";
  static const String fromDate = "fromDate";
  static const String uptoDate = "uptoDate";
  static const String ExamResultFlag = "ExamResultFlag";
}
class MCQExamUrls{
  static const String GetStudentMCQExam = 'MCQ/GetStudentMCQExam';

}
class MCQExamConstant{
  static const String examType = 'Uniform';
  static const String examSheduleType = 'Switch';
}


