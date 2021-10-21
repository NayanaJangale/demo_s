import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_list_divider.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/fees_installment.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/installment_details_page.dart';

class FeesInstallmentPage extends StatefulWidget {
  @override
  _FeesInstallmentPageState createState() => _FeesInstallmentPageState();
}

class _FeesInstallmentPageState extends State<FeesInstallmentPage> {
  bool _isLoading;
  String _loadingText;
  List<FeesInstallment> _installments = [];
  double payable = 0.0;
  List<String> inst_nos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._isLoading = false;
    this._loadingText = 'Loading . .';

    fetchInstalments().then((result) {
      setState(() {
        this._installments = result;
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
            subtitle: 'Select Installment to Pay !',
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                itemCount: _installments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _installments[index].isSelected =
                              !_installments[index].isSelected;

                          payable = 0.0;
                          List<FeesInstallment> selectedFees = _installments
                              .where((item) => item.isSelected == true)
                              .toList();
                          for (FeesInstallment inst in selectedFees) {
                            payable += inst.fees_amt;
                          }
                        });
                      },
                      leading: Icon(
                        Icons.check_box,
                        color: _installments[index].isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).secondaryHeaderColor,
                      ),
                      title: Text(
                        _installments[index].inst_desc,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _installments[index].fees_paid.toString(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return CustomListSeparator();
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_installments
                        .where((item) => item.isSelected == true)
                        .toList()
                        .length <=
                    0) {
                  FlushbarMessage.show(
                      context,
                      null,
                      'Please select atleast one fees installment to pay.',
                      MessageTypes.WARNING);
                } else {
                  List<FeesInstallment> selectedInstallments = _installments
                      .where((item) => item.isSelected == true)
                      .toList();

                  String inst_nos = '';
                  for (int i = 0; i < selectedInstallments.length; i++) {
                    if (inst_nos != '') inst_nos = inst_nos + ',';
                    inst_nos += selectedInstallments[i].inst_no.toString();
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstallmentDetailsPage(
                        inst_nos: inst_nos,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      'Proceed to Pay Rs. $payable',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<FeesInstallment>> fetchInstalments() async {
    List<FeesInstallment> installments = [];
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Loading..';
      });

      Student student = AppData.current.student;


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              FeesInstallmentUrls.GET_INSTALLMENTS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          installments = responseData
              .map(
                (item) => FeesInstallment.fromMap(item),
              )
              .toList();
        }
      } else {
        FlushbarMessage.show(
            context,
            'Internet not available',
            'Please check your wifi or mobile data is active.',
            MessageTypes.WARNING);
      }
    } catch (e) {
      FlushbarMessage.show(
          context,
          null,
          'Not able to fetch data, please contact Software Provider!',
          MessageTypes.WARNING);
    }
    setState(() {
      _isLoading = false;
    });

    return installments;
  }
}
