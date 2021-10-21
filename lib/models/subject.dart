import 'package:student/handlers/string_handlers.dart';

class Subject {
  int subject_id;
  String subject_name;

  Subject({
    this.subject_id,
    this.subject_name,
  });

  Subject.fromMap(Map<String, dynamic> map) {
    subject_id = map[SubjectFieldNames.subject_id] ?? 0;
    subject_name = map[SubjectFieldNames.subject_name] ?? StringHandlers.NotAvailable;
  }

  factory Subject.fromJson(Map<String, dynamic> parsedJson) {
    return Subject(
      subject_id: parsedJson['subject_id'],
      subject_name: parsedJson['subject_name'] as String,

    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        SubjectFieldNames.subject_id: subject_id,
        SubjectFieldNames.subject_name: subject_name,
      };

}

class SubjectFieldNames {
  static const String subject_id = "subject_id";
  static const String subject_name = "subject_name";
}

class SubjectUrls {
  static const String GET_STUDENT_SUBJECTS = 'Students/GetStudentSubjects';
  static const String GET_COURSE_SUBJECTS = 'MCQ/GetSubjects';

}