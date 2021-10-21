import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/period.dart';

class Circular {
  String brcode;
  DateTime circular_date;
  String circular_desc;
  String circular_for;
  String circular_image;
  int circular_no;
  String circular_title;
  int class_id;
  int class_idupto;
  int division_id;
  String division_name;
  String divisions;
  String emp_name;
  int emp_no;
  int from_class;
  int section_id;
  String section_name;
  int to_class;
  bool docstatus ;
  List<Period> periods;

  Circular({
    this.brcode,
    this.circular_date,
    this.circular_desc,
    this.circular_for,
    this.circular_image,
    this.circular_no,
    this.circular_title,
    this.class_id,
    this.class_idupto,
    this.division_id,
    this.division_name,
    this.divisions,
    this.emp_name,
    this.emp_no,
    this.from_class,
    this.section_id,
    this.section_name,
    this.to_class,
    this.docstatus,
    this.periods,

  });

  Circular.fromMap(Map<String, dynamic> map) {
    brcode = map[CircularFieldNames.brcode] ?? '';
    circular_date = map[CircularFieldNames.circular_date] != null &&
            map[CircularFieldNames.circular_date].toString().trim() != ''
        ? DateTime.parse(map[CircularFieldNames.circular_date])
        : null;
    circular_desc = map[CircularFieldNames.circular_desc] ?? StringHandlers.NotAvailable;
    circular_for = map[CircularFieldNames.circular_for] ?? StringHandlers.NotAvailable;
    circular_image = map[CircularFieldNames.circular_image] ?? '';
    circular_no = map[CircularFieldNames.circular_no] ?? 0;
    circular_title = map[CircularFieldNames.circular_title]  ?? StringHandlers.NotAvailable;
    class_id = map[CircularFieldNames.class_id] ?? 0;
    class_idupto = map[CircularFieldNames.class_idupto] ?? 0;
    division_id = map[CircularFieldNames.division_id] ?? 0;
    division_name = map[CircularFieldNames.division_name] ?? StringHandlers.NotAvailable;
    divisions = map[CircularFieldNames.divisions] ?? StringHandlers.NotAvailable;
    emp_name = map[CircularFieldNames.emp_name] ?? StringHandlers.NotAvailable;
    emp_no = map[CircularFieldNames.emp_no] ?? 0;
    from_class = map[CircularFieldNames.from_class] ?? 0;
    section_id = map[CircularFieldNames.section_id] ?? 0;
    section_name = map[CircularFieldNames.section_name] ?? StringHandlers.NotAvailable;
    to_class = map[CircularFieldNames.to_class] ?? 0;
    docstatus = map[CircularFieldNames.docstatus] ?? false;
    periods = (map[CircularFieldNames.periods] as List)
        .map((item) => Period.fromMap(item))
        .toList();
  }

  factory Circular.fromJson(Map<String, dynamic> parsedJson) {
    return Circular(
      brcode: parsedJson['brcode'],
      circular_date: parsedJson[CircularFieldNames.circular_date] != null &&
              parsedJson[CircularFieldNames.circular_date].toString().trim() !=
                  ''
          ? DateTime.parse(parsedJson[CircularFieldNames.circular_date])
          : null,
      circular_desc: parsedJson[CircularFieldNames.circular_desc],
      circular_for: parsedJson[CircularFieldNames.circular_for],
      circular_image: parsedJson[CircularFieldNames.circular_image],
      circular_no: parsedJson[CircularFieldNames.circular_no],
      circular_title: parsedJson[CircularFieldNames.circular_title],
      class_id: parsedJson[CircularFieldNames.class_id],
      class_idupto: parsedJson[CircularFieldNames.class_idupto],
      division_id: parsedJson[CircularFieldNames.division_id],
      division_name: parsedJson[CircularFieldNames.division_name],
      divisions: parsedJson[CircularFieldNames.divisions],
      emp_name: parsedJson[CircularFieldNames.emp_name],
      emp_no: parsedJson[CircularFieldNames.emp_no],
      from_class: parsedJson[CircularFieldNames.from_class],
      section_id: parsedJson[CircularFieldNames.section_id],
      section_name: parsedJson[CircularFieldNames.section_name],
      to_class: parsedJson[CircularFieldNames.to_class],
      docstatus: parsedJson[CircularFieldNames.docstatus],
      periods: (parsedJson[CircularFieldNames.periods] as List)
          .map((item) => Period.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        CircularFieldNames.brcode: brcode,
        CircularFieldNames.circular_date:
            circular_date == null ? null : circular_date.toIso8601String(),
        CircularFieldNames.circular_desc: circular_desc,
        CircularFieldNames.circular_for: circular_for,
        CircularFieldNames.circular_image: circular_image,
        CircularFieldNames.circular_no: circular_no,
        CircularFieldNames.circular_title: circular_title,
        CircularFieldNames.class_id: class_id,
        CircularFieldNames.class_idupto: class_idupto,
        CircularFieldNames.division_id: division_id,
        CircularFieldNames.division_name: division_name,
        CircularFieldNames.divisions: divisions,
        CircularFieldNames.emp_name: emp_name,
        CircularFieldNames.emp_no: emp_no,
        CircularFieldNames.from_class: from_class,
        CircularFieldNames.section_id: section_id,
        CircularFieldNames.section_name: section_name,
        CircularFieldNames.to_class: to_class,
        CircularFieldNames.docstatus: docstatus,
      };
}

class CircularFieldNames {
  static const String brcode = "brcode";
  static const String circular_date = "circular_date";
  static const String circular_desc = "circular_desc";
  static const String circular_for = "circular_for";
  static const String circular_image = "circular_image";
  static const String circular_no = "circular_no";
  static const String circular_title = "circular_title";
  static const String class_id = "class_id";
  static const String class_idupto = "class_idupto";
  static const String division_id = "division_id";
  static const String division_name = "division_name";
  static const String divisions = "divisions";
  static const String emp_name = "emp_name";
  static const String emp_no = "emp_no";
  static const String from_class = "from_class";
  static const String section_id = "section_id";
  static const String section_name = "section_name";
  static const String to_class = "to_class";
  static const String periods = 'periods';
  static const String docstatus = 'docstatus';
}

class CircularUrls {
  static const String GET_STUDENT_CIRCULARS = 'Circular/GetStudentCirculars';
  static const String GetCircularDocuments = "Circular/GetCircularDocuments";
  static const String GetCircularDocument = "Circular/GetCircularDocument";
}
