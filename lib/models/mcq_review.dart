import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/mcq_option.dart';

import 'answer.dart';

class MCQReview {
  String answerDesc;
  String answerExplaination;
  int correctAnsId;
  String explainationLink ;
  double postiveMarks;
  int questionId;
  String questionDesc;
  String questionReference;
  List<MCQAnswers> answers;
  List<MCQOption> options;


  MCQReview(this.answerDesc, this.answerExplaination, this.correctAnsId,
      this.explainationLink, this.postiveMarks, this.questionId,
      this.questionDesc, this.questionReference,this.answers,
      this.options);

  MCQReview.fromMap(Map<String, dynamic> map) {
    answerDesc = map[MCQReviewFieldNames.answerDesc] ?? '';
    answerExplaination = map[MCQReviewFieldNames.answerExplaination] ?? '';
    explainationLink = map[MCQReviewFieldNames.explainationLink] ?? '';
    postiveMarks = map[MCQReviewFieldNames.postiveMarks] ?? 0.0;
    questionId = map[MCQReviewFieldNames.questionId] ?? 0;
    questionDesc = map[MCQReviewFieldNames.questionDesc] ?? StringHandlers.NotAvailable;
    questionReference = map[MCQReviewFieldNames.questionReference] ?? '';
    answers = map[MCQReviewFieldNames.answers] != null
        ? (map[MCQReviewFieldNames.answers] as List)
        .map((item) => MCQAnswers.fromMap(item))
        .toList()
        : null;
    options = map[MCQReviewFieldNames.options] != null
        ? (map[MCQReviewFieldNames.options] as List)
        .map((item) => MCQOption.fromMap(item))
        .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    MCQReviewFieldNames.answerDesc: answerDesc,
    MCQReviewFieldNames.answerExplaination: answerExplaination,
    MCQReviewFieldNames.explainationLink: explainationLink,
    MCQReviewFieldNames.postiveMarks: postiveMarks,
    MCQReviewFieldNames.questionId: questionId,
    MCQReviewFieldNames.questionDesc: questionDesc,
    MCQReviewFieldNames.questionReference: questionReference,
  };
}

class MCQReviewFieldNames {
  static const String answerDesc = "answerDesc";
  static const String answerExplaination = "answerExplaination";
  static const String explainationImage = "explainationImage";
  static const String explainationLink = "explainationLink";
  static const String studentAnsId = "studentAnsId";
  static const String postiveMarks = "postiveMarks";
  static const String questionId = "questionId";
  static const String questionDesc = "questionDesc";
  static const String questionReference = "questionReference";
  static const String correctAns = "correctAns";
  static const String studentAns = "studentAns";
  static const String options = "options";
  static const String answers = "answers";
}

class MCQReviewUrls {
  static const String GET_MCQ_REVIEW = 'MCQ/GetMcqExamReview';
}
