import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/forms/reset_password_form.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/select_school_page.dart';
import 'package:student/pages/select_ward_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String displayName, mobileNo, smsAutoId, resetFor, clientCode;

  ResetPasswordPage({
    this.displayName,
    this.mobileNo,
    this.smsAutoId,
    this.resetFor,
    this.clientCode,
  });

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isLoading = false;
  String loadingText;
  DBHandler _dbHandler;

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dbHandler = DBHandler();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        appBar: Platform.isIOS
            ? AppBar(
                title: CustomAppBar(
                  title: 'Soft Campus',
                  subtitle: 'Confirm Password !',
                ),
              )
            : null,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'assets/images/banner.jpg',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: ResetPasswordForm(
                  passwordCaption: AppTranslations.of(context).text("key_password"),
                  confirmPasswordCaption: AppTranslations.of(context).text("key_confirm_pasword"),
                  confirmButtonCaption: AppTranslations.of(context).text("key_confirm"),
                  backButtonCaption: AppTranslations.of(context).text("key_back"),
                  passwordInputAction: TextInputAction.next,
                  confirmPasswordInputAction: TextInputAction.done,
                  passwordFocusNode: passwordFocusNode,
                  confirmPasswordFocusNode: confirmPasswordFocusNode,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                  onConfirmButtonPressed:(){
                    String RetMsg = _isPasswordMatched();
                    if (RetMsg != '') {
                      FlushbarMessage.show(
                        context,
                        null,
                        RetMsg,
                        MessageTypes.ERROR,
                      );
                    } else {
                      if (widget.resetFor == SelectSchoolFor.CREATE_ACCOUNT) {
                        _registerUser();
                      } else  if (widget.resetFor == SelectSchoolFor.CREATE_ACCOUNT_WITHOUT_OTP) {
                        _registerUserwithoutOTP();
                      }else{
                        _resetPassword();
                      }
                    }
                  } ,
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                  },
                  onPasswordSubmitted: (value) {
                    this.passwordFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(this.confirmPasswordFocusNode);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      setState(() {
        isLoading = true;
        loadingText = 'Registering Parent . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postCreateUserUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.REGISTER_PARENT,
        ).replace(
          queryParameters: {
            'DisplayName': widget.displayName.toString(),
            'MobileNo': widget.mobileNo.toString(),
            'LoginPassword': confirmPasswordController.text.toString(),
            'SMSAutoID': widget.smsAutoId.toString(),
            'UserType': 'Parent',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Parent',
            'AppVersion': '1.0',
            'clientCode': widget.clientCode.toString(),
          },
        );
          http.Response response = await http.post(postCreateUserUri);
        if (response.statusCode == HttpStatusCodes.CREATED) {
          var data = json.decode(response.body);
          User user = User.fromMap(data);
          if (user == null) {
            FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_invalid_user_id_password"),
              MessageTypes.INFORMATION,
            );
          } else {
            user.clientCode = widget.clientCode.toString();
            int rememberMe = 1;
            setState(() {
              user.remember_me = rememberMe;
            });
            user = await _dbHandler.saveUser(user);
            if (user != null) {
              AppData.current.user = await _dbHandler.login(user);
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_dear") +
                    user.displayName +
                    AppTranslations.of(context).text("key_successfully_reg") ,
                MessageTypes.INFORMATION,
              );

              Future.delayed(Duration(seconds: 3)).then((val) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SelectWardPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            } else {
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_not_able_no_perform_local_login"),
                MessageTypes.WARNING,
              );
            }
          }
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body,
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
  Future<void> _registerUserwithoutOTP() async {
    try {
      setState(() {
        isLoading = true;
        loadingText = 'Registering Parent . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postCreateUserUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.REGISTER_PARENT_WITHOUT_OTP,
        ).replace(
          queryParameters: {
            'DisplayName': widget.displayName.toString(),
            'MobileNo': widget.mobileNo.toString(),
            'LoginPassword': confirmPasswordController.text.toString(),
            'SMSAutoID': widget.smsAutoId.toString(),
            'UserType': 'Parent',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Parent',
            'AppVersion': '1.0',
            'clientCode': widget.clientCode.toString(),
          },
        );
        http.Response response = await http.post(postCreateUserUri);
        if (response.statusCode == HttpStatusCodes.CREATED) {
          var data = json.decode(response.body);
          User user = User.fromMap(data);
          if (user == null) {
            FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_invalid_user_id_password"),
              MessageTypes.INFORMATION,
            );
          } else {
            user.clientCode = widget.clientCode.toString();
            int rememberMe = 1;
            setState(() {
              user.remember_me = rememberMe;
            });
            user = await _dbHandler.saveUser(user);
            if (user != null) {
              AppData.current.user = await _dbHandler.login(user);
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_dear") +
                    user.displayName +
                    AppTranslations.of(context).text("key_successfully_reg") ,
                MessageTypes.INFORMATION,
              );

              Future.delayed(Duration(seconds: 3)).then((val) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SelectWardPage(),
                  ),
                      (Route<dynamic> route) => false,
                );
              });
            } else {
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_not_able_no_perform_local_login"),
                MessageTypes.WARNING,
              );
            }
          }
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body,
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

  Future<void> _resetPassword() async {
    try {
      setState(() {
        isLoading = true;
        loadingText = AppTranslations.of(context).text("key_processing_password");
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postResetPasswordUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.RESET_PARENT_PASSWORD,
        ).replace(
          queryParameters: {
            'LoginID': widget.mobileNo.toString(),
            'NewPassword': confirmPasswordController.text.toString(),
            'SMSAutoID': widget.smsAutoId.toString(),
            'UserType': 'Parent',
            'MacAddress': 'xxxxxx',
            'ApplicationType': 'Parent',
            'AppVersion': '1.0',
            'clientCode': widget.clientCode.toString(),
          },
        );

        http.Response response = await http.post(postResetPasswordUri);
        if (response.statusCode == HttpStatusCodes.ACCEPTED) {
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
            int rememberMe =  1 ;
            setState(() {
              user.remember_me = rememberMe;
            });
            // user = await _dbHandler.updateUser(user);
            user = await _dbHandler.saveUser(user);
            if (user != null) {
              user = await _dbHandler.login(user);
              AppData.current.user = user;

              FlushbarMessage.show(
                  context,
                  null,
                  AppTranslations.of(context).text("key_dear") +
                      user.displayName +
                       AppTranslations.of(context).text("key_successfully_reset_password"),
                  MessageTypes.INFORMATION);

              Future.delayed(Duration(seconds: 3)).then((val) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectWardPage(),
                    // builder: (_) => SubjectsPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              });
            } else {
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_not_able_no_perform_local_login"),
                MessageTypes.ERROR,
              );
            }
          }
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
        MessageTypes.ERROR,
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  String _isPasswordMatched() {

    if (passwordController.text.length == 0 || confirmPasswordController.text.length==0){
      return  AppTranslations.of(context).text("key_password_should_be_mandatory");

    }
    Pattern pattern = r'^(?=.{6,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(passwordController.text))
      return AppTranslations.of(context).text("key_password_strength");


    if (passwordController.text != confirmPasswordController.text) {
      return AppTranslations.of(context).text("key_password_same");
    }
    return "";
  }
}
