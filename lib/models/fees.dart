import 'package:student/handlers/string_handlers.dart';

class Fees {
  String academic_yr;
  double total_school_fees;
  double paid_school_fees;
  double pending_school_fees;
  double total_bus_fees;
  double paid_bus_fees;
  double pending_bus_fees;

  Fees({
    this.academic_yr,
    this.total_school_fees,
    this.paid_school_fees,
    this.pending_school_fees,
    this.total_bus_fees,
    this.paid_bus_fees,
    this.pending_bus_fees,
  });

  Fees.fromMap(Map<String, dynamic> map) {
    academic_yr = map[FeesFieldNames.academic_yr]  ?? StringHandlers.NotAvailable;
    total_school_fees = map[FeesFieldNames.total_school_fees] ?? 0.0;
    paid_school_fees = map[FeesFieldNames.paid_school_fees] ?? 0.0;
    pending_school_fees = map[FeesFieldNames.pending_school_fees] ?? 0.0;
    total_bus_fees = map[FeesFieldNames.total_bus_fees] ?? 0.0 ;
    paid_bus_fees = map[FeesFieldNames.paid_bus_fees] ?? 0.0;
    pending_bus_fees = map[FeesFieldNames.pending_bus_fees] ?? 0.0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        FeesFieldNames.academic_yr: academic_yr,
        FeesFieldNames.total_school_fees: total_school_fees,
        FeesFieldNames.paid_school_fees: paid_school_fees,
        FeesFieldNames.pending_school_fees: pending_school_fees,
        FeesFieldNames.total_bus_fees: total_bus_fees,
        FeesFieldNames.paid_bus_fees: paid_bus_fees,
        FeesFieldNames.pending_bus_fees: pending_bus_fees,
      };
}

class FeesFieldNames {
  static const String academic_yr = "academic_yr";
  static const String total_school_fees = "total_school_fees";
  static const String paid_school_fees = "paid_school_fees";
  static const String pending_school_fees = "pending_school_fees";
  static const String total_bus_fees = "total_bus_fees";
  static const String paid_bus_fees = "paid_bus_fees";
  static const String pending_bus_fees = "pending_bus_fees";
}

class FeesUrls {
  static const String GET_FEES = 'Fees/GetStudentFees';
}
