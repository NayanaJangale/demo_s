import 'package:student/handlers/string_handlers.dart';

class DownloadCategory {
  int category_id;
  String category_name;

  DownloadCategory({this.category_id, this.category_name,});

  DownloadCategory.fromMap(Map<String, dynamic> map) {
    category_id = map[DownloadCategoryFieldNames.category_id] ?? 0;
    category_name = map[DownloadCategoryFieldNames.category_name] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    DownloadCategoryFieldNames.category_id: category_id,
    DownloadCategoryFieldNames.category_name: category_name,
  };
}

class DownloadCategoryFieldNames {
  static const String category_id = "category_id";
  static const String category_name = "category_name";
}

class DownloadCategoryUrls {
  static const String GET_DOWNLOAD_CATEGORIES = 'Download/GetCategories';
}
