class FeesReceipt {
  int receipt_no;
  int srno;
  String stud_fullname;
  int roll_no;
  String class_name;
  String division_name;
  String yr_desc;
  String ftp_desc;
  double fees_amount;
  DateTime trdate;
  String i_desc;

  FeesReceipt({
    this.receipt_no,
    this.srno,
    this.stud_fullname,
    this.roll_no,
    this.class_name,
    this.division_name,
    this.yr_desc,
    this.ftp_desc,
    this.fees_amount,
    this.trdate,
    this.i_desc,
  });

  FeesReceipt.fromMap(Map<String, dynamic> map) {
    receipt_no = map[FeesReceiptConst.receipt_noConst] ?? 0;
    srno = map[FeesReceiptConst.srnoConst] ?? 0;
    stud_fullname = map[FeesReceiptConst.stud_fullnameConst] ?? '';
    roll_no = map[FeesReceiptConst.roll_noConst] ?? 0;
    class_name = map[FeesReceiptConst.class_nameConst] ?? '';
    division_name = map[FeesReceiptConst.division_nameConst] ?? '';
    yr_desc = map[FeesReceiptConst.yr_descConst] ?? '';
    ftp_desc = map[FeesReceiptConst.ftp_descConst] ?? '';
    fees_amount = map[FeesReceiptConst.fees_amountConst] ?? 0.0;
    trdate = map[FeesReceiptConst.trdateConst] != null
        ? DateTime.parse(map[FeesReceiptConst.trdateConst])
        : null;
    i_desc = map[FeesReceiptConst.i_descConst] ?? '';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeesReceiptConst.receipt_noConst: receipt_no,
        FeesReceiptConst.srnoConst: srno,
        FeesReceiptConst.stud_fullnameConst: stud_fullname,
        FeesReceiptConst.roll_noConst: roll_no,
        FeesReceiptConst.class_nameConst: class_name,
        FeesReceiptConst.division_nameConst: division_name,
        FeesReceiptConst.yr_descConst: yr_desc,
        FeesReceiptConst.ftp_descConst: ftp_desc,
        FeesReceiptConst.fees_amountConst: fees_amount,
        FeesReceiptConst.trdateConst: trdate.toIso8601String(),
        FeesReceiptConst.i_descConst: i_desc,
      };
}

class FeesReceiptConst {
  static const String receipt_noConst = "receipt_no";

  static const String srnoConst = "srno";
  static const String stud_fullnameConst = "stud_fullname";
  static const String roll_noConst = "roll_no";
  static const String class_nameConst = "class_name";
  static const String division_nameConst = "division_name";
  static const String yr_descConst = "yr_desc";
  static const String ftp_descConst = "ftp_desc";
  static const String fees_amountConst = "fees_amount";
  static const String trdateConst = "trdate";
  static const String i_descConst = "i_desc";
}

class FeesReceiptUrls {
  static const String GET_RECEIPTS_DETAILS = 'Fees/GetFeesReceipt';
}
