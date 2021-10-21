import 'package:student/handlers/string_handlers.dart';

import 'feedback_option.dart';

class FeedBackQuery {
  String QueryType;
  int QueryNo;
  double RatingScale;
  String Query;
  int RatingFrom;
  int RatingUpto;
  String OptionType;
  String OptionDesc;
  int OptionNo;
  List<FeedbackOption> options;

  FeedBackQuery({
    this.QueryType,
    this.QueryNo,
    this.RatingScale,
    this.Query,
    this.RatingFrom,
    this.RatingUpto,
    this.OptionType,
    this.OptionDesc,
    this.OptionNo,
    this.options,
  });

  FeedBackQuery.fromMap(Map<String, dynamic> map) {
    QueryType =
        map[FeedBackQueryFieldNames.QueryType] ?? StringHandlers.NotAvailable;
    QueryNo = map[FeedBackQueryFieldNames.QueryNo] ?? 0;
    RatingScale = map[FeedBackQueryFieldNames.RatingScale] ?? 0;
    RatingFrom = map[FeedBackQueryFieldNames.RatingFrom] ?? 0;
    Query = map[FeedBackQueryFieldNames.Query] ?? StringHandlers.NotAvailable;
    RatingUpto = map[FeedBackQueryFieldNames.RatingUpto] ?? 0;
    OptionType =
        map[FeedBackQueryFieldNames.OptionType] ?? StringHandlers.NotAvailable;
    OptionDesc =
        map[FeedBackQueryFieldNames.OptionDesc] ?? StringHandlers.NotAvailable;
    OptionNo = map[FeedBackQueryFieldNames.OptionNo] ?? 0;
    options = map[FeedBackQueryFieldNames.options] != null
        ? (map[FeedBackQueryFieldNames.options] as List)
            .map((item) => FeedbackOption.fromMap(item))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeedBackQueryFieldNames.QueryType: QueryType,
        FeedBackQueryFieldNames.QueryNo: QueryNo,
        FeedBackQueryFieldNames.RatingScale: RatingScale,
        FeedBackQueryFieldNames.RatingFrom: RatingFrom,
        FeedBackQueryFieldNames.RatingUpto: RatingUpto,
        FeedBackQueryFieldNames.OptionType: OptionType,
        FeedBackQueryFieldNames.OptionDesc: OptionDesc,
        FeedBackQueryFieldNames.OptionNo: OptionNo,
        FeedBackQueryFieldNames.Query: Query,
      };
}

class FeedBackQueryFieldNames {
  static const String QueryType = "QueryType";
  static const String circular_no = "circular_no";
  static const String QueryNo = "QueryNo";
  static const String RatingScale = "RatingScale";
  static const String RatingFrom = "RatingFrom";
  static const String RatingUpto = "RatingUpto";
  static const String OptionType = "OptionType";
  static const String OptionDesc = "OptionDesc";
  static const String Query = "Query";
  static const String OptionNo = "OptionNo";
  static const String options = 'options';
}

class FeedBackQueryUrls {
  static const String GET_USER_FEEDBACKQUERIES =
      'Feedback/GetUserTypewiseFeedbackQueries';
  static const String GENERATE_OTP = 'SMS/GenerateOTP';
}
