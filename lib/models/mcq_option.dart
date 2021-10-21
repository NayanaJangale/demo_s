import 'package:student/handlers/string_handlers.dart';

class MCQOption {
  bool answer;
  String optionDesc;
  int optionId;
  int questionId = 0;
  bool isSelected = false;

  MCQOption({
    this.answer,
    this.optionDesc,
    this.optionId,
    this.questionId,
  });

  MCQOption.fromMap(Map<String, dynamic> map) {
    answer = map[MCQOptionFieldNames.answer] ?? true;
    optionDesc = map[MCQOptionFieldNames.optionDesc] ?? StringHandlers.NotAvailable;
    optionId = map[MCQOptionFieldNames.optionId] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQOptionFieldNames.answer: answer,
    MCQOptionFieldNames.optionDesc: optionDesc,
    MCQOptionFieldNames.optionId: optionId,
  };
}

class MCQOptionFieldNames {
  static const String answer = "answer";
  static const String optionDesc = "optionDesc";
  static const String optionId = "optionId";
}

class MCQOptionUrls {
  static const String GET_USER_FEEDBACKQUERIES_OPTIONS =
      'Feedback/GetFeedbackQueryOptions';
  static const String ADD_USER_FEEDBACKS = 'Feedback/AddUserFeedbacks';
}
