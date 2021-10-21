import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/period.dart';

class Homework {
  String brcode;
  String divisions;
  int emp_no;
  DateTime hw_date;
  String hw_desc;
  String hw_image;
  int hw_no;
  DateTime submission_dt;
  int yr_no;
  bool docstatus;
  List<Period> periods;

  Homework({
    this.brcode,
    this.divisions,
    this.emp_no,
    this.hw_date,
    this.hw_desc,
    this.hw_image,
    this.hw_no,
    this.submission_dt,
    this.yr_no,
    this.periods,
    this.docstatus,
  });

  Homework.fromMap(Map<String, dynamic> map) {
    brcode = map[HomeworkFieldNames.brcode ] ?? StringHandlers.NotAvailable;
    divisions = map[HomeworkFieldNames.divisions ] ?? StringHandlers.NotAvailable;
    emp_no = map[HomeworkFieldNames.emp_no ] ?? 0;
    hw_date = DateTime.parse(map[HomeworkFieldNames.hw_date ]) != null &&
        map[HomeworkFieldNames.hw_date].toString().trim() != ''
        ? DateTime.parse(map[HomeworkFieldNames.hw_date])
        : null;
    hw_desc = map[HomeworkFieldNames.hw_desc ] ?? StringHandlers.NotAvailable;
    hw_image = map[HomeworkFieldNames.hw_image ] ?? '';
    hw_no = map[HomeworkFieldNames.hw_no ] ?? 0;
    submission_dt =  map[HomeworkFieldNames.submission_date ] != null &&
        map[HomeworkFieldNames.submission_date ].toString().trim() != ''
        ? DateTime.parse(map[HomeworkFieldNames.submission_date ])
        : null;
    yr_no = map[HomeworkFieldNames.yr_no_no ] ?? 0;
    periods = (map[HomeworkFieldNames.periods] as List)
        .map((item) => Period.fromMap(item))
        .toList();
    docstatus = map[HomeworkFieldNames.docstatus ] ?? false;
  }

  factory Homework.fromJson(Map<String, dynamic> parsedJson) {
    return Homework(
      brcode: parsedJson[HomeworkFieldNames.brcode],
      divisions: parsedJson[HomeworkFieldNames.divisions],
      emp_no: parsedJson[HomeworkFieldNames.emp_no],
      hw_date: parsedJson[HomeworkFieldNames.hw_date] != null
          ? DateTime.parse(parsedJson[HomeworkFieldNames.hw_date])
          : null,
      hw_desc: parsedJson[HomeworkFieldNames.hw_desc],
      hw_image: parsedJson[HomeworkFieldNames.hw_image],
      hw_no: parsedJson[HomeworkFieldNames.hw_no],
      submission_dt: parsedJson[HomeworkFieldNames.submission_date] != null
          ? DateTime.parse(parsedJson[HomeworkFieldNames.submission_date])
          : null,
      yr_no: parsedJson['yr_no'],
      periods: (parsedJson[HomeworkFieldNames.periods] as List)
          .map((item) => Period.fromMap(item))
          .toList(),
      docstatus: parsedJson['docstatus'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        HomeworkFieldNames.brcode : brcode,
        HomeworkFieldNames.divisions : divisions,
        HomeworkFieldNames.emp_no : emp_no,
        HomeworkFieldNames.hw_date :
            hw_date == null ? null : hw_date.toIso8601String(),
        HomeworkFieldNames.hw_desc : hw_desc,
        HomeworkFieldNames.hw_image : hw_image,
        HomeworkFieldNames.hw_no : hw_no,
        HomeworkFieldNames.submission_date : submission_dt,
        HomeworkFieldNames.submission_date :
            submission_dt == null ? null : submission_dt.toIso8601String(),
        HomeworkFieldNames.yr_no_no : yr_no,
        HomeworkFieldNames.docstatus : docstatus,
      };
}

class HomeworkFieldNames {
  static const String brcode = "brcode";
  static const String class_id = "class_id";
  static const String class_name = "class_name";
  static const String division_id = "division_id";
  static const String division_name = "division_name";
  static const String divisions = "divisions";
  static const String emp_no = "emp_no";
  static const String hw_date = "hw_date";
  static const String hw_desc = "hw_desc";
  static const String hw_image = "hw_image";
  static const String hw_no = "hw_no";
  static const String subject_id = "subject_id";
  static const String subject_name = "subject_name";
  static const String submission_date = "submission_dt";
  static const String yr_no_no = "yr_no";
  static const String periods = 'periods';
  static const String docstatus = 'docstatus';
}

class HomeworkUrls {
  static const String GET_STUDENT_HOMEWORK = 'Homework/GetStudentHomework';
  static const String SUBMIT_HOMEWORK = 'Homework/AddSubmittedHomework';
  static const String GetHomeworkDocuments = 'Homework/GetHomeworkDocuments';
  static const String GetHomeworkDocument = 'Homework/GetHomeworkDocument';
}