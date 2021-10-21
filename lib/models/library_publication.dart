import 'package:student/handlers/string_handlers.dart';

class LibraryPublication {
  String bPub;
  int book_no;

  LibraryPublication({
    this.bPub,
    this.book_no,
  });

  LibraryPublication.fromMap(Map<String, dynamic> map) {
    bPub = map[LibraryPublicationFieldnames.bPub] ?? StringHandlers.NotAvailable;
    book_no = map[LibraryPublicationFieldnames.book_no] ?? 0;
  }

  factory LibraryPublication.fromJson(Map<String, dynamic> parsedJson) {
    return LibraryPublication(
        bPub: parsedJson[LibraryPublicationFieldnames.bPub] ?? StringHandlers.NotAvailable,
        book_no: parsedJson[LibraryPublicationFieldnames.book_no] ?? 0,);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        LibraryPublicationFieldnames.bPub: bPub,
        LibraryPublicationFieldnames.book_no: book_no,
      };

  @override
  String toString() {
    // TODO: implement toString
    return bPub;
  }
}

class LibraryPublicationFieldnames {
  static const String bPub = "bPub";
  static const String book_no = "book_no";
}
