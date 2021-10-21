import 'package:student/models/fees_detail.dart';

class FeesInstallment {
  int ent_no;
  double fees_amt;
  double fees_paid;
  String inst_desc;
  int inst_no;
  int inst_tp_no;
  bool status;
  bool isSelected = false;
  List<FeesDetail> fees_details;

  FeesInstallment({
    this.ent_no,
    this.fees_amt,
    this.fees_paid,
    this.inst_desc,
    this.inst_no,
    this.inst_tp_no,
    this.status,
    this.fees_details,
  });

  FeesInstallment.fromMap(Map<String, dynamic> map) {
    ent_no = map[FeesInstallmentFieldNames.ent_no];
    fees_amt = map[FeesInstallmentFieldNames.fees_amt];
    fees_paid = map[FeesInstallmentFieldNames.fees_paid];
    inst_desc = map[FeesInstallmentFieldNames.inst_desc];
    inst_no = map[FeesInstallmentFieldNames.inst_no];
    inst_tp_no = map[FeesInstallmentFieldNames.inst_tp_no];
    status = map[FeesInstallmentFieldNames.status];
    fees_details = map[FeesInstallmentFieldNames.fees_details] != null
        ? (map[FeesInstallmentFieldNames.fees_details] as List)
        .map((item) => FeesDetail.fromMap(item))
        .toList()
        : null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    FeesInstallmentFieldNames.ent_no: ent_no,
    FeesInstallmentFieldNames.fees_amt: fees_amt,
    FeesInstallmentFieldNames.fees_paid: fees_paid,
    FeesInstallmentFieldNames.inst_desc: inst_desc,
    FeesInstallmentFieldNames.inst_no: inst_no,
    FeesInstallmentFieldNames.inst_tp_no: inst_tp_no,
    FeesInstallmentFieldNames.status: status,
  };
}

class FeesInstallmentFieldNames {
  static const String ent_no = "ent_no";
  static const String fees_amt = "fees_amt";
  static const String fees_paid = "fees_paid";
  static const String inst_desc = "inst_desc";
  static const String inst_no = "inst_no";
  static const String inst_tp_no = "inst_tp_no";
  static const String status = "status";
  static const String fees_details = 'fees_details';
}

class FeesInstallmentUrls {
  static const String GET_INSTALLMENTS = 'Fees/GetFeesInstallments';
  static const String INITIATE_ONLINE_PAYMENT = 'Fees/InitiateOnlinePayment';
}
