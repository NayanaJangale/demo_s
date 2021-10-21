import 'package:student/handlers/string_handlers.dart';

class Period {
  int class_id;
  int division_id;
  int subject_id;
  String class_name, division_name, subject_name;

  Period({
    this.class_id,
    this.division_id,
    this.subject_id,
    this.class_name,
    this.division_name,
    this.subject_name,
  });

  Period.fromMap(Map<String, dynamic> map) {
    class_id = map[PeriodFieldNames.class_id] ?? 0;
    division_id = map[PeriodFieldNames.division_id] ?? 0;
    subject_id = map[PeriodFieldNames.subject_id] ?? 0;
    class_name = map[PeriodFieldNames.class_name] ?? StringHandlers.NotAvailable;
    division_name = map[PeriodFieldNames.division_name] ?? StringHandlers.NotAvailable;
    subject_name = map[PeriodFieldNames.subject_name] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    PeriodFieldNames.class_id: class_id,
    PeriodFieldNames.division_id: division_id,
    PeriodFieldNames.subject_id: subject_id,
  };
}

class PeriodFieldNames {
  static const String class_id = "class_id";
  static const String division_id = "division_id";
  static const String subject_id = "subject_id";
  static const String class_name = "class_name";
  static const String division_name = "division_name";
  static const String subject_name = "subject_name";
}
