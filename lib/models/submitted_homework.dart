import 'package:student/handlers/string_handlers.dart';

class SubmittedHomework {
  int seq_no;
  int hw_no;
  int stud_no;
  String hw_desc;
  DateTime submission_dt;
  String remark;

  SubmittedHomework({this.seq_no, this.hw_no, this.stud_no, this.hw_desc, this.submission_dt,this.remark});

  SubmittedHomework.fromMap(Map<String, dynamic> map) {
    seq_no = map[SubmittedHwFieldsName.seq_no] ?? 0;
    hw_no = map[SubmittedHwFieldsName.hw_no]  ?? 0;
    stud_no = map[SubmittedHwFieldsName.stud_no]  ?? 0;
    hw_desc = map[SubmittedHwFieldsName.hw_desc]  ?? StringHandlers.NotAvailable;
    submission_dt =  map[SubmittedHwFieldsName.submission_dt ] != null &&
        map[SubmittedHwFieldsName.submission_dt ].toString().trim() != ''
        ? DateTime.parse(map[SubmittedHwFieldsName.submission_dt ])
        : null;
    remark = map[SubmittedHwFieldsName.remark]  ?? StringHandlers.NotAvailable;
  }
  factory SubmittedHomework.fromJson(Map<String, dynamic> parsedJson) {
    return SubmittedHomework(
      seq_no: parsedJson[SubmittedHwFieldsName.seq_no],
      hw_no: parsedJson[SubmittedHwFieldsName.hw_no],
      stud_no: parsedJson[SubmittedHwFieldsName.stud_no],
      hw_desc: parsedJson[SubmittedHwFieldsName.hw_desc],
        submission_dt: parsedJson[SubmittedHwFieldsName.submission_dt] != null
          ? DateTime.parse(parsedJson[SubmittedHwFieldsName.submission_dt])
          : null,
      remark: parsedJson[SubmittedHwFieldsName.remark],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SubmittedHwFieldsName.seq_no: seq_no,
        SubmittedHwFieldsName.hw_no: hw_no,
        SubmittedHwFieldsName.stud_no: stud_no,
        SubmittedHwFieldsName.hw_desc: hw_desc,
    SubmittedHwFieldsName.submission_dt :
    submission_dt == null ? null : submission_dt.toIso8601String(),
    SubmittedHwFieldsName.remark: remark
      };
}

class SubmittedHwFieldsName {
  static const String seq_no = "seq_no";
  static const String hw_no = "hw_no";
  static const String stud_no = "stud_no";
  static const String hw_desc = "hw_desc";
  static const String submission_dt = "submission_dt";
  static const String remark = "remark";
}
class SubmittedHomeworkUrls{
  static const String GET_STUDENT_SUBMITTED_HOMEWORK = 'Homework/GetStudentSubmittedHomework';
}


