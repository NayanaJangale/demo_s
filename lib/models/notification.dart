class SoftCampusNotification {
  String Title;
  String Content;
  String StudNo;
  String BranchCode;
  String ClientCode;
  String NotificationFor;
  String Topic;
  DateTime NotificationDateTime;
  String isRead;

  SoftCampusNotification({
    this.Title,
    this.Content,
    this.StudNo,
    this.BranchCode,
    this.ClientCode,
    this.NotificationFor,
    this.Topic,
    this.NotificationDateTime,
  });

  SoftCampusNotification.fromMap(Map<String, dynamic> map) {
    NotificationDateTime = DateTime.parse(
        map[SoftCampusNotificationFieldNames.NotificationDateTime]);
    Title = map[SoftCampusNotificationFieldNames.Title];
    Content = map[SoftCampusNotificationFieldNames.Content];
    StudNo = map[SoftCampusNotificationFieldNames.StudNo];
    BranchCode = map[SoftCampusNotificationFieldNames.BranchCode];
    ClientCode = map[SoftCampusNotificationFieldNames.ClientCode];
    NotificationFor = map[SoftCampusNotificationFieldNames.NotificationFor];
    Topic = map[SoftCampusNotificationFieldNames.Topic];
    isRead = map[SoftCampusNotificationFieldNames.isRead];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    SoftCampusNotificationFieldNames.NotificationDateTime:
    NotificationDateTime == null
        ? null
        : NotificationDateTime.toIso8601String(),
    SoftCampusNotificationFieldNames.Title: Title,
    SoftCampusNotificationFieldNames.Content: Content,
    SoftCampusNotificationFieldNames.StudNo: StudNo,
    SoftCampusNotificationFieldNames.BranchCode: BranchCode,
    SoftCampusNotificationFieldNames.ClientCode: ClientCode,
    SoftCampusNotificationFieldNames.Topic: Topic,
    SoftCampusNotificationFieldNames.NotificationFor: NotificationFor,
    SoftCampusNotificationFieldNames.isRead: isRead,
  };
}

class SoftCampusNotificationFieldNames {
  static const String NotificationID = "NotificationID";
  static const String Title = "Title";
  static const String Body = "Body";
  static const String Topic = "Topic";
  static const String NotificationFor = "NotificationFor";
  static const String SectionID = "SectionID";
  static const String ClassID = "ClassID";
  static const String DivisionID = "DivisionID";
  static const String SenderID = "SenderID";
  static const String ClientCode = "ClientCode";
  static const String BranchCode = "BranchCode";
  static const String Content = "Content";
  static const String StudNo = "StudNo";
  static const String NotificationDateTime = "NotificationDateTime";
  static const String isRead = "isRead";

}

class SoftCampusNotificationUrls {
  static const String GET_SAVEUSERTOKEN = 'Users/SaveUserToken';
}
