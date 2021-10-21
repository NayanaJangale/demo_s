import 'package:student/handlers/string_handlers.dart';

class LibraryTitle {
  int book_no;
  String bTitle;

  LibraryTitle({
    this.book_no,
    this.bTitle,
  });

  LibraryTitle.fromMap(Map<String, dynamic> map) {
    bTitle = map[LibraryTitleFieldNames.book_no] ?? 0;
    book_no = map[LibraryTitleFieldNames.bTitle] ?? StringHandlers.NotAvailable;

  }

  factory LibraryTitle.fromJson(Map<String, dynamic> parsedJson) {
    return LibraryTitle(
        bTitle: parsedJson[LibraryTitleFieldNames.bTitle] ?? StringHandlers.NotAvailable,
        book_no: parsedJson[LibraryTitleFieldNames.book_no] ?? 0);

  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        LibraryTitleFieldNames.book_no: book_no,
        LibraryTitleFieldNames.bTitle: bTitle,
      };

  @override
  String toString() {
    // TODO: implement toString
    return bTitle;
  }
}

class LibraryTitleFieldNames {
  static const String book_no = "book_no";
  static const String bTitle = "bTitle";
}
