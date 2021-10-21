import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/mcq_question.dart';

class MCQSection {
  String sectionName;
  int sectionID;
  String sectionInstruction;
  bool isSolved = false;
  int examTime;
  double TotalMarks;
  List<MCQQuestion> queries = [];
  MCQSection({
    this.sectionName,
    this.sectionID,
    this.sectionInstruction,
    this.examTime,
    this.TotalMarks
  });

  MCQSection.fromMap(Map<String, dynamic> map) {
    sectionName = map[SectionConst.sectionName]?? StringHandlers.NotAvailable;
    sectionID = map[SectionConst.sectionId]?? 0;
    sectionInstruction = map[SectionConst.sectionInstruction]??StringHandlers.NotAvailable;
    examTime = map[SectionConst.examTime]?? 0;
    TotalMarks = map[SectionConst.TotalMarks]?? 0.0;
  }
  factory MCQSection.fromJson(Map<String, dynamic> parsedJson) {
    return MCQSection(
      sectionName: parsedJson['sectionName'] as String,
      sectionID: parsedJson['sectionID'],
      sectionInstruction: parsedJson['sectionInstruction'] as String,
      examTime: parsedJson['examTime'],
      TotalMarks: parsedJson['TotalMarks'],


    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SectionConst.sectionName: sectionName,
        SectionConst.sectionId: sectionID,
        SectionConst.sectionInstruction: sectionInstruction,
        SectionConst.examTime: examTime,
        SectionConst.TotalMarks: TotalMarks,
      };
}

class SectionUrls {
  static const String GET_SECTIONS = "MCQ/GetMCQSection";
}

class SectionConst {
  static const String sectionName = "sectionName";
  static const String sectionId = "sectionID";
  static const String examTime = "examTime";
  static const String TotalMarks = "TotalMarks";
  static const String sectionInstruction = "sectionInstruction";
}
