class FeesDetail {
  String aname;
  String fees_ac;
  double fees_amt;
  String ftp_desc;
  int ftp_id;
  String inst_desc;
  int inst_no;
  bool inst_taken;
  double paid_fees;
  double pending_fees;
  int yr_no;

  FeesDetail({
    this.aname,
    this.fees_ac,
    this.fees_amt,
    this.ftp_desc,
    this.ftp_id,
    this.inst_desc,
    this.inst_no,
    this.inst_taken,
    this.paid_fees,
    this.pending_fees,
    this.yr_no,
  });

  FeesDetail.fromMap(Map<String, dynamic> map) {
    aname = map[StudentFeesDetailsFieldNames.aname];
    fees_ac = map[StudentFeesDetailsFieldNames.fees_ac];
    fees_amt = map[StudentFeesDetailsFieldNames.fees_amt];
    ftp_desc = map[StudentFeesDetailsFieldNames.ftp_desc];
    ftp_id = map[StudentFeesDetailsFieldNames.ftp_id];
    inst_desc = map[StudentFeesDetailsFieldNames.inst_desc];
    inst_no = map[StudentFeesDetailsFieldNames.inst_no];
    inst_taken = map[StudentFeesDetailsFieldNames.inst_taken ];
    paid_fees = map[StudentFeesDetailsFieldNames.paid_fees];
    pending_fees = map[StudentFeesDetailsFieldNames.pending_fees];
    yr_no = map[StudentFeesDetailsFieldNames.yr_no];
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        StudentFeesDetailsFieldNames.aname: aname,
        StudentFeesDetailsFieldNames.fees_ac: fees_ac,
        StudentFeesDetailsFieldNames.fees_amt: fees_amt,
        StudentFeesDetailsFieldNames.ftp_desc: ftp_desc,
        StudentFeesDetailsFieldNames.ftp_id: ftp_id,
        StudentFeesDetailsFieldNames.inst_desc: inst_desc,
        StudentFeesDetailsFieldNames.inst_no: inst_no,
        StudentFeesDetailsFieldNames.inst_taken: inst_taken,
        StudentFeesDetailsFieldNames.paid_fees: paid_fees,
        StudentFeesDetailsFieldNames.pending_fees: pending_fees,
        StudentFeesDetailsFieldNames.yr_no: yr_no,
      };
}

class StudentFeesDetailsFieldNames {
  static const String aname = "aname";
  static const String fees_ac = "fees_ac";
  static const String fees_amt = "fees_amt";
  static const String ftp_desc = "ftp_desc";
  static const String ftp_id = "ftp_id";
  static const String inst_desc = "inst_desc";
  static const String inst_no = "inst_no";
  static const String inst_taken = "inst_taken ";
  static const String paid_fees = "paid_fees";
  static const String pending_fees = "pending_fees";
  static const String yr_no = "yr_no";
}

class StudentFeesDetailsUrls{
  static const String GET_FEES_DETAILS='Fees/GetStudentFeesDetails';
}