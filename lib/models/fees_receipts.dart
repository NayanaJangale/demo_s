class FeesReceipts {
  int trno;
  DateTime trdate;
  double feesamount;
  int yr_no;

  FeesReceipts({
    this.trno,
    this.trdate,
    this.feesamount,
    this.yr_no,
  });

  FeesReceipts.fromMap(Map<String, dynamic> map) {
    trno = map[FeesReceiptsConst.trnoConst] ?? 0;
    trdate = map[FeesReceiptsConst.trdateConst] != null
        ? DateTime.parse(map[FeesReceiptsConst.trdateConst])
        : null;
    feesamount = map[FeesReceiptsConst.feesamountConst] ?? 0.0;
    yr_no = map[FeesReceiptsConst.yr_noConst] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeesReceiptsConst.trnoConst: trno,
        FeesReceiptsConst.trdateConst: trdate.toIso8601String(),
        FeesReceiptsConst.feesamountConst: feesamount,
        FeesReceiptsConst.yr_noConst: yr_no,
      };
}

class FeesReceiptsConst {
  static const String trnoConst = "trno";
  static const String trdateConst = "trdate";
  static const String feesamountConst = "feesamount";
  static const String yr_noConst = "yr_no";
}

class FeesReceiptsUrls {
  static const String GET_RECEIPTS = 'Fees/GetFeesReceipts';
}
