import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_fees_card.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/configuration.dart';
import 'package:student/models/fees.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/fees_installment_page.dart';

class FeesPage extends StatefulWidget {
  @override
  _FeesPageState createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  bool _isLoading;
  String _loadigText;
  List<Fees> _fees = [];
  List<Configuration> _configurations = [];
  bool online_payment = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._isLoading = false;
    this._loadigText = 'Loading . .';

    fetchFees().then((result) {
      setState(() {
        _fees = result;
      });
    });

    fetchConfiguration(ConfigurationGroups.ADMISSION_FEES).then((result) {
      setState(() {
        _configurations = result;
        Configuration conf = _configurations.firstWhere(
            (item) => item.confName == ConfigurationNames.PAYMENT_GATEWAY);
        online_payment = conf != null && conf.confValue == "Y" ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this._loadigText = AppTranslations.of(context).text("key_loading");

    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadigText,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_fees"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchFees().then((result) {
              setState(() {
                _fees = result;
              });
            });

            fetchConfiguration(ConfigurationGroups.ADMISSION_FEES)
                .then((result) {
              setState(() {
                _configurations = result;
                Configuration conf = _configurations.firstWhere((item) =>
                    item.confName == ConfigurationNames.PAYMENT_GATEWAY);
                online_payment =
                    conf != null && conf.confValue == "Y" ? true : false;
              });
            });
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: _fees != null && _fees.length > 0
                      ? ListView.builder(
                          itemCount: _fees.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 3.0,
                                ),
                                Card(
                                  color: Theme.of(context).accentColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                      top: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        AppTranslations.of(context)
                                                .text("key_academic_year") +
                                            ': ' +
                                            _fees[index].academic_yr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FeesCard(
                                        headerText: AppTranslations.of(context)
                                            .text("key_academic_fee"),
                                        totalFee: _fees[index]
                                            .total_school_fees
                                            .toString(),
                                        paidFee: _fees[index]
                                            .paid_school_fees
                                            .toString(),
                                        pendingFee: _fees[index]
                                            .pending_school_fees
                                            .toString(),
                                      ),
                                      FeesCard(
                                        headerText: AppTranslations.of(context)
                                            .text("key_bus_fee"),
                                        totalFee: _fees[index]
                                            .total_bus_fees
                                            .toString(),
                                        paidFee: _fees[index]
                                            .paid_bus_fees
                                            .toString(),
                                        pendingFee: _fees[index]
                                            .pending_bus_fees
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            );
                          },
                        )
                      : Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return CustomDataNotFound(
                          description:AppTranslations.of(context).text("key_fee_not_available"),

                        );
                      },
                    ),
                  ),
                ),
              ),
              online_payment
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FeesInstallmentPage(),
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Text(
                              AppTranslations.of(context)
                                  .text("key_pay_online_fees"),
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
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Fees>> fetchFees() async {
    List<Fees> fees = [];
    try {
      setState(() {
        _isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg + ProjectSettings.rootUrl + FeesUrls.GET_FEES,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            fees = responseData
                .map(
                  (item) => Fees.fromMap(item),
                )
                .toList();
          });
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
      _isLoading = false;
    });

    return fees;
  }

  Future<List<Configuration>> fetchConfiguration(String confGroup) async {
    List<Configuration> configurations = [];
    try {
      setState(() {
        _isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          ConfigurationFieldNames.ConfigurationGroup: confGroup,
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              ConfigurationUrls.GET_CONFIGURATION_BY_GROUP,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          configurations = responseData
              .map(
                (item) => Configuration.fromJson(item),
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
      _isLoading = false;
    });

    return configurations;
  }
}
