import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/recipient.dart';

class Message {
  String inward_outward;
  String message;
  int message_no;
  DateTime msg_date;
  String msg_type;
  bool read_status;
  int stud_no;
  String teacher_name;
  int teacher_no;
  int yr_no;
  List<Recipient> recipients;

  Message({
    this.inward_outward,
    this.message,
    this.message_no,
    this.msg_date,
    this.msg_type,
    this.read_status,
    this.stud_no,
    this.teacher_name,
    this.teacher_no,
    this.yr_no,
    this.recipients,
  });

  Message.fromMap(Map<String, dynamic> map) {
    inward_outward =
        map[MessageFieldNames.inward_outward] ?? StringHandlers.NotAvailable;
    message = map[MessageFieldNames.message] ?? StringHandlers.NotAvailable;
    message_no = map[MessageFieldNames.message_no] ?? 0;
    msg_date = map[MessageFieldNames.msg_date] != null &&
            map[MessageFieldNames.msg_date].toString().trim() != ''
        ? DateTime.parse(map[MessageFieldNames.msg_date])
        : null;
    msg_type = map[MessageFieldNames.msg_type] ?? StringHandlers.NotAvailable;
    read_status = map[MessageFieldNames.read_status] ?? false;
    stud_no = map[MessageFieldNames.stud_no] ?? 0;
    teacher_name =
        map[MessageFieldNames.teacher_name] ?? StringHandlers.NotAvailable;
    teacher_no = map[MessageFieldNames.teacher_no] ?? 0;
    yr_no = map[MessageFieldNames.yr_no] ?? 0;
    recipients = (map[MessageFieldNames.recipients] as List)
        .map((item) => Recipient.fromMap(item))
        .toList();
  }

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      inward_outward:
          map[MessageFieldNames.inward_outward] ?? StringHandlers.NotAvailable,
      message: map[MessageFieldNames.message] ?? StringHandlers.NotAvailable,
      message_no: map[MessageFieldNames.message_no] ?? 0,
      msg_date: map[MessageFieldNames.msg_date] != null &&
              map[MessageFieldNames.msg_date].toString().trim() != ''
          ? DateTime.parse(map[MessageFieldNames.msg_date])
          : null,
      msg_type: map[MessageFieldNames.msg_type] ?? StringHandlers.NotAvailable,
      read_status: map[MessageFieldNames.read_status] ?? false,
      stud_no: map[MessageFieldNames.stud_no] ?? 0,
      teacher_name:
          map[MessageFieldNames.teacher_name] ?? StringHandlers.NotAvailable,
      teacher_no: map[MessageFieldNames.teacher_no] ?? 0,
      yr_no: map[MessageFieldNames.yr_no] ?? 0,
      recipients: (map[MessageFieldNames.recipients] as List)
          .map((item) => Recipient.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MessageFieldNames.inward_outward: inward_outward,
        MessageFieldNames.message: message,
        MessageFieldNames.message_no: message_no,
        MessageFieldNames.msg_date:
            msg_date == null ? null : msg_date.toIso8601String(),
        MessageFieldNames.msg_type: msg_type,
        MessageFieldNames.read_status: read_status,
        MessageFieldNames.stud_no: stud_no,
        MessageFieldNames.teacher_name: teacher_name,
        MessageFieldNames.teacher_no: teacher_no,
        MessageFieldNames.yr_no: yr_no,
      };
}

class MessageUrls {
  static const String GET_STUDENTS_MESSAGES = 'Message/GetStudentMessages';
  static const String GET_MESSAGE_COMMENTS = 'Message/GetMessageComments';
  static const String POST_MESSAGE_COMMENTS = 'Message/PostMessageComment';
}

class MessageFieldNames {
  static const String inward_outward = "inward_outward";
  static const String message = "message";
  static const String message_no = "message_no";
  static const String msg_date = "msg_date";
  static const String msg_type = "msg_type";
  static const String read_status = "read_status";
  static const String stud_no = "stud_no";
  static const String teacher_name = "teacher_name";
  static const String teacher_no = "teacher_no";
  static const String yr_no = "yr_no";
  static const String recipients = 'recipients';
}
