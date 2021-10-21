import 'package:student/handlers/string_handlers.dart';

class LibraryAuthor {
  int book_no;
  String bAuthor;

  LibraryAuthor({this.book_no, this.bAuthor});

  LibraryAuthor.fromMap(Map<String, dynamic> map) {
    book_no = map[LibraryAuthorFieldnames.book_no] ?? 0;
    bAuthor = map[LibraryAuthorFieldnames.bAuthor] ?? StringHandlers.NotAvailable;
  }

  factory LibraryAuthor.fromJson(Map<String, dynamic> parsedJson) {
    return LibraryAuthor(
      book_no: parsedJson[LibraryAuthorFieldnames.book_no] ?? 0,
      bAuthor: parsedJson[LibraryAuthorFieldnames.bAuthor] ?? StringHandlers.NotAvailable,);
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        LibraryAuthorFieldnames.book_no: book_no,
        LibraryAuthorFieldnames.bAuthor: bAuthor,
      };

  @override
  String toString() {
    // TODO: implement toString
    return bAuthor;
  }
}

class LibraryUrls {
  static const String GET_BOOK_AUTHOR = 'Library/GetBookAuthor';
  static const String GET_BOOK_PUBLICATION = 'Library/GetBookPublication';
  static const String GET_BOOK_TITLE = 'Library/GetBookTitle';
  static const String GET_BOOK_DETAILS = 'Library/GetBookDetails';
}

class LibraryAuthorFieldnames {
  static const String book_no = "book_no";
  static const String bAuthor = "bAuthor";
}