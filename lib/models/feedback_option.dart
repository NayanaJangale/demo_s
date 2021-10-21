import 'package:student/handlers/string_handlers.dart';

class FeedbackOption {
  int QueryNo;
  String OptionDesc;
  int OptionNo;
  bool isSelected = false;

  FeedbackOption({
    this.QueryNo,
    this.OptionDesc,
    this.OptionNo,
  });

  FeedbackOption.fromMap(Map<String, dynamic> map) {
    QueryNo = map[FeedbackOptionFieldNames.QueryNo] ?? 0;
    OptionDesc =
        map[FeedbackOptionFieldNames.OptionDesc] ?? StringHandlers.NotAvailable;
    OptionNo = map[FeedbackOptionFieldNames.OptionNo] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeedbackOptionFieldNames.QueryNo: QueryNo,
        FeedbackOptionFieldNames.OptionDesc: OptionDesc,
        FeedbackOptionFieldNames.OptionNo: OptionNo,
      };
}

class FeedbackOptionFieldNames {
  static const String QueryNo = "QueryNo";
  static const String OptionDesc = "OptionDesc";
  static const String OptionNo = "OptionNo";
}

class FeedbackOptionUrls {
  static const String GET_USER_FEEDBACKQUERIES_OPTIONS =
      'Feedback/GetFeedbackQueryOptions';
  static const String ADD_USER_FEEDBACKS = 'Feedback/AddUserFeedbacks';
}
