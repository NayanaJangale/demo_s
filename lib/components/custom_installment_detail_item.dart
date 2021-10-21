import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/fees_detail.dart';
import 'package:student/models/fees_installment.dart';

class CustomInstallmentDetailItem extends StatelessWidget {
  final FeesInstallment installment;

  const CustomInstallmentDetailItem({this.installment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
          bottom: 5.0,
          left: 12.0,
          right: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5.0),
            Text(
              this.installment.inst_desc.toUpperCase(),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10.0),
            Table(
              columnWidths: {
                0: FractionColumnWidth(.4),
              },
              children: List.generate(
                installment.fees_details.length,
                (i) => getFeesDetailRow(context, installment.fees_details[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow getFeesDetailRow(BuildContext context, FeesDetail feesDetail) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black12,
          ),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Text(
            feesDetail.ftp_desc,
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Text(
            StringHandlers.capitalizeWords(feesDetail.fees_amt.toString()),
            style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
