import 'package:student/handlers/string_handlers.dart';

class Attendance {
  int at_day;
  int at_month;
  int at_year;
  String at_status;
  String at_date;
  int at_dayofweek;

  Attendance({
    this.at_day,
    this.at_month,
    this.at_year,
    this.at_status,
    this.at_date,
    this.at_dayofweek,
  });

  Attendance.fromJson(Map<String, dynamic> map) {
    at_day = map[AttendanceFieldNames.at_day] ?? 0;
    at_month = map[AttendanceFieldNames.at_month] ?? 0;
    at_year = map[AttendanceFieldNames.at_year] ?? 0;
    at_status = map[AttendanceFieldNames.at_status] ?? StringHandlers.NotAvailable;
    at_date = map[AttendanceFieldNames.at_date] ?? '';
    at_dayofweek = map[AttendanceFieldNames.at_dayofweek] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AttendanceFieldNames.at_day: at_day,
    AttendanceFieldNames.at_month: at_month,
    AttendanceFieldNames.at_year: at_year,
    AttendanceFieldNames.at_status: at_status,
    AttendanceFieldNames.at_date: at_date,
    AttendanceFieldNames.at_dayofweek: at_dayofweek,
  };
}

class AttendanceFieldNames {
  static const String at_day = "at_day";
  static const String at_month = "at_month";
  static const String at_year = "at_year";
  static const String at_status = "at_status";
  static const String at_date = "at_date";
  static const String at_dayofweek = "at_dayofweek";
}

class AttendanceUrls {
  static const String GET_MONTH_ATTENDANCE = 'Attendance/GetMonthAttendance';
}
class AttendanceConfigurationNames {
  static const String Classwise = "Classwise";
  static const String Subjectwise = "Subjectwise";
}