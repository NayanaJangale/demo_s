import 'package:student/handlers/string_handlers.dart';

class TimeTable {
  int tt_no;
  int period_no;
  String period_desc;
  String Monday;
  String Tuesday;
  String Wednesday;
  String Thursday;
  String Friday;
  String Saturday;
  String Sunday;

  TimeTable({
    this.tt_no,
    this.period_no,
    this.period_desc,
    this.Monday,
    this.Tuesday,
    this.Wednesday,
    this.Thursday,
    this.Friday,
    this.Saturday,
    this.Sunday,
  });

  TimeTable.fromJson(Map<String, dynamic> map) {
    tt_no = map[TeacherTimeTableFieldNames.tt_no] ?? 0;
    period_no = map[TeacherTimeTableFieldNames.period_no] ?? 0;
    period_desc = map[TeacherTimeTableFieldNames.period_desc] ?? StringHandlers.NotAvailable;
    Monday = map[TeacherTimeTableFieldNames.Monday] ?? StringHandlers.NotAvailable;
    Tuesday = map[TeacherTimeTableFieldNames.Tuesday] ?? StringHandlers.NotAvailable;
    Wednesday = map[TeacherTimeTableFieldNames.Wednesday] ?? StringHandlers.NotAvailable;
    Thursday = map[TeacherTimeTableFieldNames.Thursday] ?? StringHandlers.NotAvailable;
    Friday = map[TeacherTimeTableFieldNames.Friday] ?? StringHandlers.NotAvailable;
    Saturday = map[TeacherTimeTableFieldNames.Saturday] ?? StringHandlers.NotAvailable;
    Sunday = map[TeacherTimeTableFieldNames.Sunday] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        TeacherTimeTableFieldNames.tt_no: tt_no,
        TeacherTimeTableFieldNames.period_no: period_no,
        TeacherTimeTableFieldNames.period_desc: period_desc,
        TeacherTimeTableFieldNames.Monday: Monday,
        TeacherTimeTableFieldNames.Tuesday: Tuesday,
        TeacherTimeTableFieldNames.Wednesday: Wednesday,
        TeacherTimeTableFieldNames.Thursday: Thursday,
        TeacherTimeTableFieldNames.Friday: Friday,
        TeacherTimeTableFieldNames.Saturday: Saturday,
        TeacherTimeTableFieldNames.Sunday: Sunday,
      };
}

class TeacherTimeTableFieldNames {
  static String tt_no = "tt_no";
  static String period_no = "period_no";
  static String period_desc = "period_desc";
  static String Monday = "d1";
  static String Tuesday = "d2";
  static String Wednesday = "d3";
  static String Thursday = "d4";
  static String Friday = "d5";
  static String Saturday = "d6";
  static String Sunday = "d7";
}

class TimeTableUrls {
  static const String GET_STUDENT_TIMETABLE = 'TimeTable/GetStudentTimeTable';
}
