import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/school_address.dart';
import 'package:student/models/student_result.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFMaker {
  static Future<bool> createPdf(
    String studName,
    String className,
    String examName,
    List<StudentResult> result,
  ) async {
    try {
      List<List<String>> res = [
        <String>['SUBJECT', 'MARKS OBTAINED', 'TOTAL MARKS', 'GRADE'],
      ];

      for (var r in result) {
        res.add(<String>[
          r.subject_name,
          r.obt_marks.toString() != null ? r.obt_marks.toString() : '0.0',
          r.total_marks.toString() != null ? r.total_marks.toString() : '0.0',
          r.grade != null
              ? r.subject_name == 'PERCENTAGE'
                  ? r.grade_point.round().toString() + '%'
                  : r.grade
              : 'n/a'
        ]);
      }
      Printing.layoutPdf(
        onLayout: (format) {
          final doc = pw.Document();
          doc.addPage(
            pw.MultiPage(
                header: (Context context) {

                  return Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm,
                    ),
                    padding: const EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm,
                    ),
                    child: Text(
                      'Result',
                      style: Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.grey),
                    ),
                  );
                },
                footer: (Context context) {
                  return Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                    child: Text(
                      'Page ${context.pageNumber} of ${context.pagesCount}',
                      style: Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.grey),
                    ),
                  );
                },
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                build: (pw.Context context) => <pw.Widget>[
                  Header(
                    level: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '$studName : $className',
                          textScaleFactor: 2,
                        ),
                      ],
                    ),
                  ),
                  Header(
                    level: 1,
                    text: 'Result for : $examName',
                  ),
                  Paragraph(
                      text:
                      'The PDF file format has changed several times, and continues to evolve, along with the release of new versions of Adobe Acrobat. There have been nine versions of PDF and the corresponding version of the software:'),
                  Table.fromTextArray(
                    context: context,
                    data: res,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                  ),
                  Paragraph(
                    text: 'Software generated result.',
                    textAlign: TextAlign.right,
                  ),
                ]),
          );
          return doc.save();
        },
        name: 'order_id_#',
      );
      return true;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> createReceiptPdf(
    FeesReceiptHeader feesReceiptHeader,
  ) async {
    try {
      List<List<String>> res = [
        <String>['Particulars', 'Amount'],
      ];

      double total = 0;

      for (var r in feesReceiptHeader.FeesReceipts) {
        res.add(
          <String>[
            StringHandlers.capitalizeWords(r.ftp_desc) ?? 'n/a',
            r.fees_amount.toString() ?? '0.0',
          ],
        );
        total = total + r.fees_amount;
      }

      res.add(
        <String>[
          'Total',
          total.toString(),
        ],
      );


      Printing.layoutPdf(
        onLayout: (format) {
          final doc = pw.Document();
          doc.addPage(
            pw.MultiPage(
                header: (Context context) {

                  return Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm,
                    ),
                    padding: const EdgeInsets.only(
                      bottom: 3.0 * PdfPageFormat.mm,
                    ),
                    child: Text(
                      'Receipt',
                      style: Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.grey),
                    ),
                  );
                },
                footer: (Context context) {
                  return Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                    child: Text(
                      'Page ${context.pageNumber} of ${context.pagesCount}',
                      style: Theme.of(context)
                          .defaultTextStyle
                          .copyWith(color: PdfColors.grey),
                    ),
                  );
                },
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                build: (pw.Context context) => <pw.Widget>[
                      Header(
                        level: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              StringHandlers.capitalizeWords(
                                feesReceiptHeader.schoolName,
                              ),
                              textScaleFactor: 1.6,
                              style: TextStyle(
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              feesReceiptHeader.schoolAddress,
                              textScaleFactor: 1.3,
                            ),
                            Text(
                              'Fees Receipt',
                              textScaleFactor: 1.3,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Student Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            StringHandlers.capitalizeWords(
                              feesReceiptHeader
                                  .FeesReceipts.first.stud_fullname,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Class',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 68,
                                  ),
                                  Text(
                                    feesReceiptHeader
                                        .FeesReceipts.first.class_name,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Receipt No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    feesReceiptHeader
                                        .FeesReceipts.first.receipt_no
                                        .toString(),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Roll No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    feesReceiptHeader.FeesReceipts.first.roll_no
                                        .toString(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Receipt Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    DateFormat('d-MM-yyyy').format(
                                      feesReceiptHeader
                                          .FeesReceipts.first.trdate,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Installments',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            feesReceiptHeader.FeesReceipts.first.i_desc,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Paragraph(
                          text:
                              'The PDF file format has changed several times, and continues to evolve, along with the release of new versions of Adobe Acrobat. There have been nine versions of PDF and the corresponding version of the software:'),
                      Table.fromTextArray(
                        context: context,
                        data: res,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                      ),
                      Paragraph(
                        text:
                            'Note : No need of signature as it is system generated report.',
                        textAlign: TextAlign.right,
                      ),
                    ]),
          );
          return doc.save();
        },
        name: 'order_id_#',
      );

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
