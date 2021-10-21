import 'package:student/handlers/string_handlers.dart';

class SchoolCalender {
  int event_no;
  DateTime from_date;
  DateTime to_date;
  String event_name;
  String event_descr;
  int event_cat_id;
  String event_cat_name;

  SchoolCalender({
    this.event_no,
    this.from_date,
    this.to_date,
    this.event_name,
    this.event_descr,
    this.event_cat_id,
    this.event_cat_name,
  });

  SchoolCalender.fromJson(Map<String, dynamic> map) {
    event_no = map[SchoolCalenderFieldNames.event_no] ?? 0;
    from_date = map[SchoolCalenderFieldNames.from_date] != null && map[SchoolCalenderFieldNames.from_date].toString().trim() != ''?
     DateTime.parse(map[SchoolCalenderFieldNames.from_date]) : null;
    to_date = map[SchoolCalenderFieldNames.to_date] != null && map[SchoolCalenderFieldNames.to_date].toString().trim() != ''?
    DateTime.parse(map[SchoolCalenderFieldNames.to_date]) : null;
    event_name = map[SchoolCalenderFieldNames.event_name]  ?? StringHandlers.NotAvailable;
    event_descr = map[SchoolCalenderFieldNames.event_descr]  ?? StringHandlers.NotAvailable;
    event_cat_id = map[SchoolCalenderFieldNames.event_cat_id] ?? 0;
    event_cat_name = map[SchoolCalenderFieldNames.event_cat_name] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SchoolCalenderFieldNames.event_no: event_no,
        SchoolCalenderFieldNames.from_date:
            from_date == null ? null : from_date.toIso8601String(),
        SchoolCalenderFieldNames.to_date:
            to_date == null ? null : to_date.toIso8601String(),
        SchoolCalenderFieldNames.event_name: event_name,
        SchoolCalenderFieldNames.event_descr: event_descr,
        SchoolCalenderFieldNames.event_cat_id: event_cat_id,
        SchoolCalenderFieldNames.event_cat_name: event_cat_name,
      };
}

class SchoolCalenderFieldNames {
  static const String event_no = "event_no";
  static const String from_date = "from_date";
  static const String to_date = "to_date";
  static const String event_name = "event_name";
  static const String event_descr = "event_descr";
  static const String event_cat_id = "event_cat_id";
  static const String event_cat_name = "event_cat_name";
}

class SchoolCalendarUrls {
  static const String GET_SCHOOL_CALENDAR = 'Calendar/GetStudentCalendar';
}
