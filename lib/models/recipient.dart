import 'package:student/handlers/string_handlers.dart';

class Recipient {
  int recipientNo;
  String recipientName;

  Recipient({
    this.recipientNo,
    this.recipientName,
  });

  Recipient.fromMap(Map<String, dynamic> map) {
    recipientNo = map[RecipientFieldNames.recipientNo] ?? 0;
    recipientName = map[RecipientFieldNames.recipientName] ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    RecipientFieldNames.recipientNo: recipientNo,
    RecipientFieldNames.recipientName: recipientName
  };
}

class RecipientFieldNames {
  static const String recipientNo = "recipientNo";
  static const String recipientName = "recipientName";
}