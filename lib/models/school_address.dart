import 'package:student/models/receipt_details.dart';

class FeesReceiptHeader {
  String schoolName;
  String schoolAddress;
  List<FeesReceipt> FeesReceipts;

  FeesReceiptHeader({
    this.schoolName,
    this.schoolAddress,
    this.FeesReceipts,
  });

  FeesReceiptHeader.fromMap(Map<String, dynamic> map) {
    schoolName = map[FeesReceiptHeaderFieldNames.SchoolName];
    schoolAddress = map[FeesReceiptHeaderFieldNames.schoolAddress];
    FeesReceipts = map[FeesReceiptHeaderFieldNames.FeesReceipts] != null
        ? (map[FeesReceiptHeaderFieldNames.FeesReceipts] as List)
            .map((rec) => FeesReceipt.fromMap(rec))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeesReceiptHeaderFieldNames.SchoolName: schoolName,
        FeesReceiptHeaderFieldNames.schoolAddress: schoolAddress,
        FeesReceiptHeaderFieldNames.FeesReceipts: FeesReceipts,
      };
}

class FeesReceiptHeaderFieldNames {
  static const String SchoolName = "SchoolName";
  static const String schoolAddress = "SchoolAddress";
  static const String FeesReceipts = "FeesReceipts";
}
