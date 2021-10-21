import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/SmsAutoFill.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_list_divider.dart';
import 'package:student/components/custom_list_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/components/list_filter_bar.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/configuration.dart';
import 'package:student/models/school.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/reset_password_page.dart';
import 'package:student/pages/select_ward_page.dart';

import 'confirm_otp_page.dart';

class SelectSchoolFor {
  static const String LOGIN = "Login";
  static const String FORGOT_PASSWORD = "Forgot Password";
  static const String CREATE_ACCOUNT = "Registration";
  static const String CREATE_ACCOUNT_WITHOUT_OTP = "Registration Without OTP";
}

class SelectSchoolPage extends StatefulWidget {
  final String userId, password, select_school_for;
  String clientCode, mobileNo, display_name, clientName;
  bool isSelected;

  SelectSchoolPage({
    this.userId,
    this.password,
    this.select_school_for,
    this.mobileNo,
    this.display_name,
    this.isSelected,
  });

  @override
  _SelectSchoolPageState createState() => _SelectSchoolPageState();
}

class _SelectSchoolPageState extends State<SelectSchoolPage> {
  bool isLoading = true,Selected_Config = true;
  TextEditingController filterController;
  List<School> _schools = [];
  List<School> _filteredList;
  String filter, loadingText;
  DBHandler _dbHandler;
  String appSignature;
  List<Configuration> _configurations = [];

  @override
  void initState() {
    super.initState();
    loadingText = 'Loading . . .';

    _dbHandler = DBHandler();
    fetchSchools().then((result) {
      _schools = result;

    });
    filterController = new TextEditingController();
    filterController.addListener(() {
      setState(() {
        filter = filterController.text;
      });
    });
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature!= null? signature:"";
        print("App signature: " + appSignature);
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    _filteredList = _schools.where((item) {
      if (filter == null || filter == '')
        return true;
      else {
        return item.clientName.toLowerCase().contains(filter.toLowerCase());
      }
    }).toList();

    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_school"),
            subtitle: AppTranslations.of(context).text("key_school_subtitle"),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchSchools().then((result) {
              setState(() {
                _schools = result;
              });
            });
          },
          child: _schools != null && _schools.length > 0
              ? Column(
            children: <Widget>[
              ListFilterBar(
                searchFieldController: filterController,
                onCloseButtonTap: () {
                  setState(() {
                    filterController.text = '';
                  });
                },
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomListItem(
                      onItemTap: () {
                        widget.clientCode =
                            _filteredList[index].clientCode.toString();
                        widget.clientName =
                            _filteredList[index].clientName.toString();

                        if (widget.select_school_for ==
                            SelectSchoolFor.LOGIN) {
                          _login();
                        } else if (widget.select_school_for ==
                            SelectSchoolFor.FORGOT_PASSWORD) {
                          _sendOTP(SelectSchoolFor.FORGOT_PASSWORD);
                        } else if (widget.select_school_for == SelectSchoolFor.CREATE_ACCOUNT) {
                          fetchConfiguration(ConfigurationGroups.Registration).then((result) {
                            setState(() {
                              _configurations = result;
                              Configuration conf = _configurations.firstWhere(
                                      (item) => item.confName == ConfigurationNames.OTP);
                              Selected_Config =
                              conf != null && conf.confValue == "Y" ? true : false;
                              if(Selected_Config){
                                _sendOTP(SelectSchoolFor.CREATE_ACCOUNT);
                              }else{
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResetPasswordPage(
                                      displayName: widget.display_name.toString(),
                                      mobileNo: widget.mobileNo.toString(),
                                      smsAutoId: "0",
                                      resetFor: SelectSchoolFor.CREATE_ACCOUNT_WITHOUT_OTP,
                                      clientCode: widget.clientCode.toString(),
                                    ),
                                  ),
                                );
                              }
                            });
                          });


                        }
                      },
                      itemText: StringHandlers.capitalizeWords(
                          _filteredList[index].clientName),
                      itemIndex: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return CustomListSeparator();
                  },
                ),
              ),
            ],
          )
              : Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              AppTranslations.of(context).text("key_load_school"),

              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ), //ModalProgressHUD(child: _createBody(), inAsyncCall: isLoading), //
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      loadingText = 'Validating Online . .';
    });

    try {

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri getEmployeeDetailsUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.GET_PARENT_DETAILS,
        ).replace(
          queryParameters: {
            UserFieldNames.LoginID: widget.userId.toString(),
            UserFieldNames.LoginPassword: widget.password.toString(),
            UserFieldNames.UserNo: '1',
            UserFieldNames.clientCode : widget.clientCode.toString(),
            'UserType': 'Student',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Student',
            'AppVersion': '1.0',
          },
        );

        http.Response response = await http.get(getEmployeeDetailsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.ERROR);
        } else {
          var data = json.decode(response.body);
          User user = User.fromMap(data);
          if (user == null) {
            FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_invalid_user_id_password"),
              MessageTypes.WARNING,
            );
          } else {
            user.clientCode = widget.clientCode.toString();
            user.clientName = widget.clientName.toString();
            int rememberMe =  widget.isSelected ? 1 : 0;
            setState(() {
              user.remember_me = rememberMe;
            });
            user = await _dbHandler.saveUser(user);
            if (user != null) {
              user = await _dbHandler.login(user);
              AppData.current.user = await _dbHandler.login(user);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectWardPage(),
                ),
              );
            } else {
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_unable_to_perform_local_login"),
                MessageTypes.ERROR,
              );
            }
          }
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
        AppTranslations.of(context).text("key_Not_able_to_fetch_school"),
        MessageTypes.ERROR,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _sendOTP(String transactionType) async {
    try {
      setState(() {
        isLoading = true;
        loadingText = AppTranslations.of(context).text("key_sending_otp");
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postSendOtpUri = Uri.parse(
          connectionServerMsg + ProjectSettings.rootUrl + UserUrls.GENERATE_OTP,
        ).replace(
          queryParameters: {
            'TransactionType': transactionType,
            'RecipientMobileNo': widget.mobileNo.toString(),
            'RecipientType': 'Parent',
            'RegenerateSMS': 'false',
            'UserNo': '0',
            'UserType': 'Parent',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Parent',
            'AppVersion': '1.0',
            'clientCode': widget.clientCode.toString(),
            'appSignature': appSignature,
          },
        );
        http.Response response = await http.post(postSendOtpUri);
        if (response.statusCode == HttpStatusCodes.CREATED) {
          var sSmsAutoID = json.decode(response.body);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmOTPPage(
                display_name: widget.display_name,
                otp_for: widget.select_school_for,
                mobile_no: widget.mobileNo,
                smsAutoID: sSmsAutoID,
                clientCode: widget.clientCode,
              ),
            ),
          );
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body.toString(),
            MessageTypes.WARNING,
          );
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
  }

  @override
  void dispose() async {
    super.dispose();
  }

  //Method to get schools list from api
  Future<List<School>> fetchSchools() async {
    List<School> schools = [];
    try {
      setState(() {
        isLoading = true;
        loadingText = "Loading..";
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SchoolUrls.GET_SCHOOLS,
        ).replace(
          queryParameters: {
            'ApplicationType': 'Parent',
          },
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            schools = responseData
                .map(
                  (item) => School.fromJson(item),
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
        AppTranslations.of(context).text("key_school_instuction") +
            e.toString(),
        MessageTypes.ERROR,
      );
    }
    setState(() {
      isLoading = false;
    });

    return schools;
  }
  Future<List<Configuration>> fetchConfiguration(String confGroup) async {
    List<Configuration> configurations = [];
    try {
      setState(() {
        isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                ConfigurationUrls.GET_CONFIGURATION_BY_GROUP
        ).replace(
          queryParameters: {
            ConfigurationFieldNames.ConfigurationGroup: confGroup,
            "stud_no": "1",
            "yr_no": "4",
            "brcode": "001",
            'UserNo': '0',
            "user_no":"0",
            'UserType': 'Parent',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Parent',
            'AppVersion': '1.0',
            'clientCode': widget.clientCode.toString(),
          },
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
      isLoading = false;
    });

    return configurations;
  }
}
