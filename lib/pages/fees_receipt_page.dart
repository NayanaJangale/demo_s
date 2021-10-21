import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/pdf_maker.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/fees_receipts.dart';
import 'package:student/models/receipt_details.dart';
import 'package:student/models/school_address.dart';
import 'package:student/models/student.dart';

class FeesReceiptPage extends StatefulWidget {
  @override
  _FeesReceiptPageState createState() => _FeesReceiptPageState();
}

class _FeesReceiptPageState extends State<FeesReceiptPage> {
  bool isLoading;
  String loadingText;
  List<FeesReceipts> receipts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.isLoading = false;
    this.loadingText = 'Loading . .';

    fetchReceipts().then((result) {
      setState(() {
        receipts = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_receipts"),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchReceipts().then((result) {
              setState(() {
                receipts = result;
              });
            });
          },
          child: receipts != null && receipts.length > 0
              ? ListView.builder(
            itemCount: receipts.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(3.0),
                      bottomRight: Radius.circular(3.0),
                      bottomLeft: Radius.circular(3.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_receipts_date") +
                                    ' : ${DateFormat('d-MM-yyyy').format(receipts[index].trdate)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 5.0,
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  fetchReceiptsDetails(
                                    receipts[index].trno.toString(),
                                    receipts[index].yr_no.toString(),
                                  ).then((result) {
                                    bool isCreated;
                                    PDFMaker.createReceiptPdf(result)
                                        .then((val) {
                                      isCreated = val;
                                    });
                                  });
                                },
                                child: Icon(
                                  Icons.file_download,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 5,
                          ),
                          child: Divider(
                            height: 0,
                            color: Colors.black12,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppTranslations.of(context)
                                  .text("key_receipts_no") +
                                  ': ${receipts[index].trno}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              AppTranslations.of(context)
                                  .text("key_receipts_amount") +
                                  ': ${receipts[index].feesamount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return CustomDataNotFound(
                  description:AppTranslations.of(context).text("key_receipts_not_available"),

                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<FeesReceipts>> fetchReceipts() async {
    List<FeesReceipts> receipt = [];

    try {
      setState(() {
        isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchStudentAlbumsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              FeesReceiptsUrls.GET_RECEIPTS,
          params,
        );

        Response response = await get(fetchStudentAlbumsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          receipt = responseData
              .map(
                (item) => FeesReceipts.fromMap(item),
              )
              .toList();
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      isLoading = false;
    });

    return receipt;
  }

  Future<FeesReceiptHeader> fetchReceiptsDetails(
      String receipt_no, String yr_no) async {
      FeesReceiptHeader receiptDetail = FeesReceiptHeader();

    try {
      setState(() {
        isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "receipt_no": receipt_no,
          StudentFieldNames.yr_no: yr_no,
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri fetchStudentAlbumsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              FeesReceiptUrls.GET_RECEIPTS_DETAILS,
          params,
        );

        Response response = await get(fetchStudentAlbumsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body.toString(),
            MessageTypes.WARNING,
          );
        } else {
          var responseData = json.decode(response.body);
          receiptDetail = FeesReceiptHeader.fromMap(responseData);
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      isLoading = false;
    });

    return receiptDetail;
  }
}
