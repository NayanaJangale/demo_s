import 'package:student/handlers/string_handlers.dart';

class ClassTest {
  double obt_marks;
  String stud_attendence;
  int subject_id;
  String subject_name;
  String test_date;
  String test_desc;
  int test_no;
  double total_marks;
  int yr_no;

  ClassTest({
    this.obt_marks,
    this.stud_attendence,
    this.subject_id,
    this.subject_name,
    this.test_date,
    this.test_desc,
    this.test_no,
    this.total_marks,
    this.yr_no,
  });

  ClassTest.fromMap(Map<String, dynamic> map) {
    obt_marks = map[ClassTestFieldNames.obt_marks] ?? 0.0;
    stud_attendence = map[ClassTestFieldNames.stud_attendence] ?? StringHandlers.NotAvailable;
    subject_id = map[ClassTestFieldNames.subject_id] ?? 0;
    subject_name = map[ClassTestFieldNames.subject_name] ?? StringHandlers.NotAvailable;
    test_date = map[ClassTestFieldNames.test_date] ?? StringHandlers.NotAvailable;
    test_desc = map[ClassTestFieldNames.test_desc] ?? StringHandlers.NotAvailable;
    test_no = map[ClassTestFieldNames.test_no] ?? 0;
    total_marks = map[ClassTestFieldNames.total_marks] ?? 0.0;
    yr_no = map[ClassTestFieldNames.yr_no] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    ClassTestFieldNames.obt_marks: obt_marks,
    ClassTestFieldNames.stud_attendence: stud_attendence,
    ClassTestFieldNames.subject_id: subject_id,
    ClassTestFieldNames.subject_name: subject_name,
    ClassTestFieldNames.test_date: test_date,
    ClassTestFieldNames.test_desc: test_desc,
    ClassTestFieldNames.test_no: test_no,
    ClassTestFieldNames.total_marks: total_marks,
    ClassTestFieldNames.yr_no: yr_no,
  };

  factory ClassTest.fromJson(Map<String, dynamic> parsedJson) {
    return ClassTest(
        obt_marks: parsedJson['obt_marks'] as double,
        stud_attendence: parsedJson['stud_attendence'],
        subject_id: parsedJson['subject_id'],
        subject_name: parsedJson['subject_name'],
        test_date: parsedJson['test_date'],
        test_desc: parsedJson['test_desc'],
        test_no: parsedJson['test_no'],
        total_marks: parsedJson['total_marks'] as double,
        yr_no: parsedJson['yr_no']);
  }
}

class ClassTestFieldNames {
  static String obt_marks = "obt_marks";
  static String stud_attendence = "stud_attendence";
  static String subject_id = "subject_id";
  static String subject_name = "subject_name";
  static String test_date = "test_date";
  static String test_desc = "test_desc";
  static String test_no = "test_no";
  static String total_marks = "total_marks";
  static String yr_no = "yr_no";
}

class ClassTestUrls {
  static const String GET_STUDENT_TESTS = 'ClassTests/GetStudentTests';
}
