import 'package:student/handlers/string_handlers.dart';

class StudResult {
  String Brcode;
  int DocId;

  StudResult({
    this.Brcode,
    this.DocId,
  });

  StudResult.fromMap(Map<String, dynamic> map) {
    Brcode = map[StudResultNames.Brcode] ??  StringHandlers.NotAvailable;
     DocId= map[StudResultNames.DocId] ?? 0;
  }

  factory StudResult.fromJson(Map<String, dynamic> parsedJson) {
    return StudResult(
      Brcode: parsedJson['Brcode'] as String,
      DocId: parsedJson['DocId'] ,

    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    StudResultNames.Brcode: Brcode,
    StudResultNames.DocId: DocId,
  };

}

class StudResultNames {
  static const String Brcode = "Brcode";
  static const String  DocId= "DocId";
}

class StudResultUrl {
  static const String GET_STUDENT_EXAM = 'Exam/GetExamResult';

}
