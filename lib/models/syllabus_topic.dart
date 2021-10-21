import 'package:student/handlers/string_handlers.dart';

class SyllabusTopic {
  static const String PENDING = "Pending";
  static const String ON_GOING = "On Going";
  static const String COMPLETED = "Completed";

  String details,
      topic_name,
      status;
  int no_of_sessions,
      topic_no,
      ent_no,
      subject_id;

  SyllabusTopic({
    this.details,
    this.no_of_sessions,
    this.topic_name,
    this.topic_no,
    this.status,
    this.ent_no,
    this.subject_id,
  });

  SyllabusTopic.fromMap(Map<dynamic, dynamic> map)
      : details = map[SyllabusTopicFieldNames.details]  ?? StringHandlers.NotAvailable,
        topic_name = map[SyllabusTopicFieldNames.topic_name] ?? StringHandlers.NotAvailable,
        no_of_sessions = map[SyllabusTopicFieldNames.no_of_sessions] ?? 0,
        topic_no = map[SyllabusTopicFieldNames.topic_no] ?? 0,
        status = map[SyllabusTopicFieldNames.status]  ?? StringHandlers.NotAvailable,
        ent_no = map[SyllabusTopicFieldNames.ent_no] ?? 0,
        subject_id = map[SyllabusTopicFieldNames.subject_id] ?? 0;

  factory SyllabusTopic.fromJson(Map<String, dynamic> map) {
    return SyllabusTopic(
        details : map[SyllabusTopicFieldNames.details]  ?? StringHandlers.NotAvailable,
        topic_name : map[SyllabusTopicFieldNames.topic_name] ?? StringHandlers.NotAvailable,
        no_of_sessions : map[SyllabusTopicFieldNames.no_of_sessions] ?? 0,
        topic_no : map[SyllabusTopicFieldNames.topic_no] ?? 0,
        status : map[SyllabusTopicFieldNames.status]  ?? StringHandlers.NotAvailable,
        ent_no : map[SyllabusTopicFieldNames.ent_no] ?? 0,
        subject_id : map[SyllabusTopicFieldNames.subject_id] ?? 0
    );
  }

  Map<dynamic, dynamic> toJson() => <String, dynamic>{
        SyllabusTopicFieldNames.details: details,
        SyllabusTopicFieldNames.topic_name: topic_name,
        SyllabusTopicFieldNames.no_of_sessions: no_of_sessions,
        SyllabusTopicFieldNames.topic_no: topic_no,
        SyllabusTopicFieldNames.status: status,
        SyllabusTopicFieldNames.ent_no: ent_no,
        SyllabusTopicFieldNames.subject_id: subject_id,
      };
}

class SyllabusTopicUrls {
  static const String GET_SUBJECT_SYLLABUS = 'Syllabus/GetSubjectSyllabus';
}

class SyllabusTopicFieldNames {
  static const String details = "details";
  static const String topic_name = "topic_name";
  static const String no_of_sessions = "no_of_sessions";
  static const String topic_no = "topic_no";
  static const String status = "status";
  static const String ent_no = "ent_no";
  static const String subject_id = "subject_id";
}
