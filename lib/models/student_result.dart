import 'package:student/handlers/string_handlers.dart';

class StudentResult {
  int ent_no;
  String grade;
  double grade_point;
  double obt_marks;
  String subject_name;
  int total_marks;

  StudentResult({
    this.ent_no,
    this.grade,
    this.grade_point,
    this.obt_marks,
    this.subject_name,
    this.total_marks,
  });

  StudentResult.fromMap(Map<String, dynamic> map) {
    ent_no = map[StudentResultFieldNames.ent_no] ?? 0;
    grade = map[StudentResultFieldNames.grade] ?? StringHandlers.NotAvailable;
    grade_point = map[StudentResultFieldNames.grade_point] ?? 0.0;
    obt_marks = map[StudentResultFieldNames.obt_marks] ?? 0.0;
    subject_name = map[StudentResultFieldNames.subject_name]  ?? StringHandlers.NotAvailable;
    total_marks = map[StudentResultFieldNames.total_marks] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    StudentResultFieldNames.ent_no: ent_no,
    StudentResultFieldNames.grade: grade,
    StudentResultFieldNames.grade_point: grade_point,
    StudentResultFieldNames.obt_marks: obt_marks,
    StudentResultFieldNames.subject_name: subject_name,
    StudentResultFieldNames.total_marks: total_marks,
  };
}

class StudentResultFieldNames {
  static const String ent_no = "ent_no";
  static const String grade = "grade";
  static const String grade_point = "grade_point";
  static const String obt_marks = "obt_marks";
  static const String subject_name = "subject_name";
  static const String total_marks = "total_marks";
}

class StudentResultUrls {
  static const String GET_STUDENT_RESULT = 'Exam/GetStudentResult';
}
