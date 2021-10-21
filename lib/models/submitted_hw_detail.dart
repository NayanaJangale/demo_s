

class SubmittesHWDetail {
  int ent_no;
  int seq_no;

  SubmittesHWDetail({
    this.ent_no,
    this.seq_no,
  });

  SubmittesHWDetail.fromJson(Map<String, dynamic> map) {
    ent_no = map[SubmittesHWDetailFieldNames.ent_no] ?? 0;
    seq_no =
        map[SubmittesHWDetailFieldNames.seq_no]?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    SubmittesHWDetailFieldNames.ent_no: ent_no,
    SubmittesHWDetailFieldNames.seq_no: seq_no,
  };
}

class SubmittesHWDetailFieldNames {
  static const String ent_no = "ent_no";
  static const String seq_no = "seq_no";
  static const String remark = "remark";
}

class SubmittesHWDetailUrls {
  static const String GET_SubmittedHWPhotos = 'Homework/GetSubmittedHomeworkPhotos';
  static const String GET_SubmittedHWPhoto = 'Homework/GetSubmittedHomeworkPhoto';
}
