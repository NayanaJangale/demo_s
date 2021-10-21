import 'package:student/handlers/string_handlers.dart';

class Document {
  int doc_id;
  String caption;
  String file_type;
  String file_ext;
  String content_type;
  String doc_link;

  Document({
    this.doc_id,
    this.caption,
    this.file_ext,
    this.file_type,
    this.content_type,
    this.doc_link,
  });

  Document.fromMap(Map<String, dynamic> map) {
    doc_id = map[DocumentFieldNames.doc_id] ?? 0;
    caption = map[DocumentFieldNames.caption] ?? StringHandlers.NotAvailable;
    file_type = map[DocumentFieldNames.file_type] ?? StringHandlers.NotAvailable;
    file_ext = map[DocumentFieldNames.file_ext] ?? StringHandlers.NotAvailable;
    content_type = map[DocumentFieldNames.content_type] ?? StringHandlers.NotAvailable;
    doc_link = map[DocumentFieldNames.doc_link] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        DocumentFieldNames.doc_id: doc_id,
        DocumentFieldNames.caption: caption,
        DocumentFieldNames.file_type: file_type,
        DocumentFieldNames.file_ext: file_ext,
        DocumentFieldNames.content_type: content_type,
        DocumentFieldNames.doc_link: doc_link,
      };
}

class DocumentFieldNames {
  static const String doc_id = "doc_id";
  static const String caption = "caption";
  static const String file_type = "file_type";
  static const String file_ext = "file_ext";
  static const String content_type = "content_type";
  static const String doc_link = "doc_link";
}

class DocumentUrls {
  static const String GET_DOCUMENTS = 'Download/GetDocuments';
  static const String DOWNLOAD_DOCUMENT = 'Download/GetDocument';
}
