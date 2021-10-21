import 'package:student/handlers/string_handlers.dart';

class MessageComment {
  int MessageNo, FromEmpNo, FromStudentNo;
  String Comment;
  String ReplyFrom;
  DateTime ReplySentOn;

  MessageComment({
    this.Comment,
    this.ReplyFrom,
    this.ReplySentOn,
  });

  MessageComment.fromMap(Map<String, dynamic> map) {
    Comment = map[MessageCommentFieldNames.Comment] ?? StringHandlers.NotAvailable;
    ReplyFrom = map[MessageCommentFieldNames.ReplyFrom]  ?? StringHandlers.NotAvailable;
    ReplySentOn = map[MessageCommentFieldNames.ReplySentOn] != null
        ? DateTime.parse(map[MessageCommentFieldNames.ReplySentOn])
        : null;
  }

  factory MessageComment.fromJson(Map<String, dynamic> parsedJson) {
    return MessageComment(
      Comment: parsedJson[MessageCommentFieldNames.Comment]  ?? StringHandlers.NotAvailable,
      ReplyFrom: parsedJson[MessageCommentFieldNames.ReplyFrom] ?? StringHandlers.NotAvailable,
      ReplySentOn: parsedJson[MessageCommentFieldNames.ReplySentOn] != null
          ? DateTime.parse(parsedJson[MessageCommentFieldNames.ReplySentOn])
          : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        MessageCommentFieldNames.MessageNo: MessageNo,
        MessageCommentFieldNames.FromEmpNo: FromEmpNo,
        MessageCommentFieldNames.FromStudentNo: FromStudentNo,
        MessageCommentFieldNames.Comment: Comment,
        MessageCommentFieldNames.ReplyFrom: ReplyFrom,
        MessageCommentFieldNames.ReplySentOn:
            ReplySentOn == null ? null : ReplySentOn.toIso8601String(),
      };
}

class MessageCommentFieldNames {
  static const String FromStudentNo = "FromStudentNo";
  static const String FromEmpNo = "FromEmpNo";
  static const String MessageNo = "MessageNo";
  static const String Comment = "Comment";
  static const String ReplyFrom = "ReplyFrom";
  static const String ReplySentOn = "ReplySentOn";
}
