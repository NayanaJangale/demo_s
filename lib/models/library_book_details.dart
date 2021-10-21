import 'package:student/handlers/string_handlers.dart';

class LibraryBookDetails {
  String bAuthor;
  String bEdition;
  String bPub;
  String bTitle;
  int book_no;
  int no_of_copies;
  int available;

  LibraryBookDetails({
    this.bAuthor,
    this.bEdition,
    this.bPub,
    this.bTitle,
    this.book_no,
    this.no_of_copies,
    this.available,
  });

  LibraryBookDetails.fromMap(Map<String, dynamic> map) {
    bAuthor = map[LibraryBookDetailsFieldnames.bAuthor]  ?? StringHandlers.NotAvailable;
    bEdition = map[LibraryBookDetailsFieldnames.bEdition] ?? StringHandlers.NotAvailable;
    bPub = map[LibraryBookDetailsFieldnames.bPub] ?? StringHandlers.NotAvailable;
    bTitle = map[LibraryBookDetailsFieldnames.bTitle] ?? StringHandlers.NotAvailable;
    book_no = map[LibraryBookDetailsFieldnames.book_no] ?? 0;
    no_of_copies = map[LibraryBookDetailsFieldnames.no_of_copies] ?? 0;
    available = map[LibraryBookDetailsFieldnames.available] ?? 0;
  }

  factory LibraryBookDetails.fromJson(Map<String, dynamic> parsedJson) {
    return LibraryBookDetails(
      bAuthor: parsedJson[LibraryBookDetailsFieldnames.bAuthor] ?? StringHandlers.NotAvailable,
      bEdition: parsedJson[LibraryBookDetailsFieldnames.bEdition] ?? StringHandlers.NotAvailable,
      bPub: parsedJson[LibraryBookDetailsFieldnames.bPub] ?? StringHandlers.NotAvailable,
      bTitle: parsedJson[LibraryBookDetailsFieldnames.bTitle] ?? StringHandlers.NotAvailable,
      book_no: parsedJson[LibraryBookDetailsFieldnames.book_no] ?? 0,
      no_of_copies: parsedJson[LibraryBookDetailsFieldnames.no_of_copies] ?? 0,
      available: parsedJson[LibraryBookDetailsFieldnames.available] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        LibraryBookDetailsFieldnames.bAuthor: bAuthor,
        LibraryBookDetailsFieldnames.bEdition: bEdition,
        LibraryBookDetailsFieldnames.bPub: bPub,
        LibraryBookDetailsFieldnames.bTitle: bTitle,
        LibraryBookDetailsFieldnames.book_no: book_no,
        LibraryBookDetailsFieldnames.no_of_copies: no_of_copies,
        LibraryBookDetailsFieldnames.available: available,
      };
}

class LibraryBookDetailsFieldnames {
  static const String bAuthor = "bAuthor";
  static const String bEdition = "bEdition";
  static const String bPub = "bPub";
  static const String bTitle = "bTitle";
  static const String book_no = "book_no";
  static const String no_of_copies = "no_of_copies";
  static const String available = "available";
}
