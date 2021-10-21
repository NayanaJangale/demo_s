

import 'package:student/handlers/string_handlers.dart';

class Meeting {
  String agenda;
  String empName;
  DateTime end_time ;
  DateTime meetDate ;
  String meeting_for;
  String meeting_name;
  String meeting_status;
  int meeting_no;
  int meeting_taker;
  DateTime start_time;

  Meeting({
    this.agenda,
    this.empName,
    this.end_time,
    this.meetDate,
    this.meeting_for,
    this.meeting_name,
    this.meeting_status,
    this.meeting_no,
    this.meeting_taker,
    this.start_time,
  });

  Meeting.fromMap(Map<String, dynamic> map) {
    agenda = map[MeetingFieldNames.agenda] ?? StringHandlers.NotAvailable;
    empName = map[MeetingFieldNames.empName]  ?? StringHandlers.NotAvailable;
    end_time =  map[MeetingFieldNames.end_time ] != null &&
        map[MeetingFieldNames.end_time ].toString().trim() != ''
        ? DateTime.parse(map[MeetingFieldNames.end_time ])
        : null;
    meetDate =  map[MeetingFieldNames.meetDate ] != null &&
        map[MeetingFieldNames.meetDate ].toString().trim() != ''
        ? DateTime.parse(map[MeetingFieldNames.meetDate ])
        : null;
    meeting_for = map[MeetingFieldNames.meeting_for]  ?? StringHandlers.NotAvailable;
    meeting_name = map[MeetingFieldNames.meeting_name]  ?? StringHandlers.NotAvailable;
    meeting_status = map[MeetingFieldNames.meeting_status]  ?? StringHandlers.NotAvailable;
    meeting_no = map[MeetingFieldNames.meeting_no]  ?? 0;
    meeting_taker = map[MeetingFieldNames.meeting_taker]  ?? 0;
    start_time =  map[MeetingFieldNames.start_time ] != null &&
        map[MeetingFieldNames.start_time ].toString().trim() != ''
        ? DateTime.parse(map[MeetingFieldNames.start_time ])
        : null;
  }

  factory Meeting.fromJson(Map<String, dynamic> parsedJson) {
    return Meeting(
      agenda: parsedJson[MeetingFieldNames.agenda],
      empName: parsedJson[MeetingFieldNames.empName],
      end_time: parsedJson[MeetingFieldNames.end_time] != null
          ? DateTime.parse(parsedJson[MeetingFieldNames.end_time])
          : null,
      meetDate: parsedJson[MeetingFieldNames.meetDate] != null
          ? DateTime.parse(parsedJson[MeetingFieldNames.meetDate])
          : null,
      meeting_for: parsedJson[MeetingFieldNames.meeting_for],
      meeting_name: parsedJson[MeetingFieldNames.meeting_name],
      meeting_status: parsedJson[MeetingFieldNames.meeting_status],
      meeting_no: parsedJson[MeetingFieldNames.meeting_no],
      meeting_taker: parsedJson[MeetingFieldNames.meeting_taker],
      start_time: parsedJson[MeetingFieldNames.start_time] != null
          ? DateTime.parse(parsedJson[MeetingFieldNames.start_time])
          : null,
    );
  }
}

class MeetingFieldNames {
  static const String agenda = "agenda";
  static const String empName = "empName";
  static const String end_time = "end_time";
  static const String meetDate = "meetDate";
  static const String meeting_for = "meeting_for";
  static const String meeting_name = "meeting_name";
  static const String meeting_no = "meeting_no";
  static const String start_time = "start_time";
  static const String meeting_taker = "meeting_taker";
  static const String meeting_status = "meeting_status";
}

class MeetingFieldUrls {
  static const String GET_TEACHER_MEETING = 'Video/GetTeacherMeeting';
  static const String UPDATE_MEETING_STATUS = 'Video/UpdateEmpMeetingStatus';
}
