import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_installment_detail_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/fees_detail.dart';
import 'package:student/models/fees_installment.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/payment_gateway_page.dart';

class InstallmentDetailsPage extends StatefulWidget {
  String inst_nos;

  InstallmentDetailsPage({
    this.inst_nos,
  });

  @override
  _InstallmentDetailsPageState createState() => _InstallmentDetailsPageState();
}

class _InstallmentDetailsPageState extends State<InstallmentDetailsPage> {
  bool _isLoading;
  String _loadingText;
  List<FeesInstallment> _fees_installments = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._isLoading = false;
    this._loadingText = 'Loading . .';

    fetchFeesInstallments().then((result) {
      setState(() {
        this._fees_installments = result != null ? result : [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(
            title: 'Hi, ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: 'Confirm Fees Payment !',
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _fees_installments.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomInstallmentDetailItem(
                    installment: _fees_installments[index],
                  );
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                double fees_amt = 0.0;
                for (FeesInstallment installment in _fees_installments) {
                  for (FeesDetail feesDetail in installment.fees_details)
                    fees_amt = fees_amt + feesDetail.pending_fees;
                }

                initiateOnlinePayment(fees_amt);
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      'CONFIRM',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List<FeesInstallment>> fetchFeesInstallments() async {
    List<FeesInstallment> fees_installments;
    try {
      setState(() {
        this._isLoading = true;
        this._loadingText = 'Loading . .';
      });

      Student student = AppData.current.student;

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        DateTime dt = DateTime.now();
        String tdt = DateFormat('dd-MMM-yyyy').format(dt);

        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          'inst_no': widget.inst_nos,
          'mlatefee': "0",
          'bankcharges': "0",
          'tdt': tdt,
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              StudentFeesDetailsUrls.GET_FEES_DETAILS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          fees_installments = responseData
              .map(
                (item) => FeesInstallment.fromMap(item),
              )
              .toList();
        }
      } else {
        FlushbarMessage.show(
            context,
            AppTranslations.of(context).text("key_no_internet"),
            AppTranslations.of(context).text("key_check_internet"),
            MessageTypes.WARNING);
      }
    } catch (e) {
      FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_api_error"),
          MessageTypes.WARNING);
    }

    setState(() {
      _isLoading = false;
    });

    return fees_installments;
  }

  initiateOnlinePayment(double fees_amt) async {
    setState(() {
      _isLoading = true;
      _loadingText = 'Initiating Online Fees . .';
    });

    try {
      Student student = AppData.current.student;
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.brcode: student.brcode,
          'inst_nos': widget.inst_nos,
          'fees_amt': fees_amt.toString(),
          'phone_no': AppData.current.user.mobileNo,
          'url': connectionServerMsg + ProjectSettings.webUrl,
        };

        Uri initiateOnlinePaymentUri = NetworkHandler.getUri(
              connectionServerMsg +
              ProjectSettings.rootUrl +
              FeesInstallmentUrls.INITIATE_ONLINE_PAYMENT,
          params,
        );

        http.Response response = await http.post(initiateOnlinePaymentUri);
        if (response.statusCode != HttpStatusCodes.CREATED) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            _isLoading = false;
          });

          String redirectUrl = response.body.toString();
          redirectUrl = redirectUrl.replaceAll('"', '');

          String sURL = connectionServerMsg +
              ProjectSettings.webUrl +
              redirectUrl.toString() +
              '&' +
              UserFieldNames.clientCode +
              '=' +
              AppData.current.user.clientCode;

          print(sURL);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentGatewayPage(
                url: sURL,
              ),
            ),
          );
        }
      } else {
        FlushbarMessage.show(
            context,
            AppTranslations.of(context).text("key_no_internet"),
            AppTranslations.of(context).text("key_check_internet"),
            MessageTypes.WARNING);
      }
    } catch (e) {
      FlushbarMessage.show(
          context,
          null,
          'Not able to initiate online fees payment, please contact Software Provider!',
          MessageTypes.WARNING);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
