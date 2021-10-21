

import 'package:student/handlers/string_handlers.dart';

class AcademicYear {
  int yr_no;
  String yr_desc;

  AcademicYear({
    this.yr_no,
    this.yr_desc,
  });

  AcademicYear.fromJson(Map<String, dynamic> map) {
    yr_no = map[AcademicYearFieldNames.yr_no] ?? 0;
    yr_desc = map[AcademicYearFieldNames.yr_desc] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    AcademicYearFieldNames.yr_no: yr_no,
    AcademicYearFieldNames.yr_desc: yr_desc,
  };
}

class AcademicYearFieldNames {
  static const String yr_no = "yr_no";
  static const String yr_desc = "yr_desc";
}

class AcademicYearUrls {
  static const String GET_ACADEMIC_YEARS = 'Teacher/GetAcademicYears';
}
