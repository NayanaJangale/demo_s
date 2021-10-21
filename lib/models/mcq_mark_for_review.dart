import 'package:student/handlers/string_handlers.dart';

class MCQMarksForReview {
  int questionId;
  bool isSelected = false;

  MCQMarksForReview({
    this.questionId,
  });

  MCQMarksForReview.fromMap(Map<String, dynamic> map) {
    questionId = map[MCQMarksForReviewFieldNames.questionId] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQMarksForReviewFieldNames.questionId: questionId,
  };
}

class MCQMarksForReviewFieldNames {
  static const String questionId = "questionId";

}
