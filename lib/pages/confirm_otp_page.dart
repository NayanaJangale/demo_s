import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/components/SmsAutoFill.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/forms/confirm_otp_form.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/reset_password_page.dart';

class ConfirmOTPPage extends StatefulWidget {
  final String mobile_no, smsAutoID, otp_for, clientCode, display_name;

  ConfirmOTPPage({
    this.display_name,
    this.mobile_no,
    this.smsAutoID,
    this.otp_for,
    this.clientCode,
  });

  @override
  _ConfirmOTPPageState createState() => _ConfirmOTPPageState();
}

class _ConfirmOTPPageState extends State<ConfirmOTPPage> {
  bool isLoading = false;
  String loadingText;
  String smsAutoID,otp;
  int cnt = 1;
  final GlobalKey<ScaffoldState> _confirmOTPPageGlobalKey =
  new GlobalKey<ScaffoldState>();

  TextEditingController otpController;
  FocusNode otpFocusNode;
  String appSignature;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature!=null?signature:"";
      });
    });
    otpController = TextEditingController();
    otpFocusNode = FocusNode();
    smsAutoID = widget.smsAutoID;
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        key: _confirmOTPPageGlobalKey,
        appBar: Platform.isIOS
            ? AppBar(
                title: CustomAppBar(
                  title: AppTranslations.of(context).text("key_school"),
                  subtitle: AppTranslations.of(context).text("key_Confirm_otp"),
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
                child: ConfirmOTPForm(
                  caption:  AppTranslations.of(context).text("key_otp"),
                  confirmButtonCaption:  AppTranslations.of(context).text("key_continue"),
                  resendButtonCaption: AppTranslations.of(context).text("key_resend"),
                  otpController: otpController,
                  otpFocusNode: otpFocusNode,
                  otpInputAction: TextInputAction.done,
                  onResendButtonPressed: _resendOTP,
                  onConfirmButtonPressed: () {
                    _validateOtp(otpController.text);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateOtp(String otp) async {
    try {
      if (otpController.text.length==6) {
        /*setState(() {
          isLoading = true;
          loadingText = 'Validating OTP . .';
        });*/
        String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
        if (connectionServerMsg != "key_check_internet") {
          Uri postValidateOtpUri = Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                UserUrls.VALIDATE_OTP,
          ).replace(
            queryParameters: {
              'SMSAutoID': smsAutoID,
              'OTP': otpController.text.toString(),
              'UserNo': '0',
              'UserType': 'Parent',
              'MacAddress': 'xxxxxx',
              'ApplicationType': 'Parent',
              'AppVersion': '1.0',
              'clientCode': widget.clientCode.toString(),
            },
          );

          http.Response response = await http.post(postValidateOtpUri);
          setState(() {
            isLoading = false;
            loadingText = '';
          });

          if (response.statusCode != HttpStatusCodes.CREATED) {
            FlushbarMessage.show(
              context,
              null,
              response.body.toString(),
              MessageTypes.WARNING,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(
                  displayName: widget.display_name.toString(),
                  mobileNo: widget.mobile_no.toString(),
                  smsAutoId: smsAutoID,
                  resetFor: widget.otp_for.toString(),
                  clientCode: widget.clientCode.toString(),
                ),
              ),
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
      } else {
        FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_enter_otp_instruction"),
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
  Future<void> _resendOTP() async {
    if (cnt < 3) {
      setState(() {
        isLoading = true;
        loadingText = AppTranslations.of(context).text("key_resend_otp");
        otpController.text = '';
      });

      try {


        String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
        if (connectionServerMsg != "key_check_internet") {
          Uri postGenerateOtpUri = Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                UserUrls.GENERATE_OTP,
          ).replace(
            queryParameters: {
              'TransactionType': widget.otp_for,
              'RecipientMobileNo': widget.mobile_no.toString(),
              'RecipientType': 'Parent',
              'RegenerateSMS': 'true',
              'OldSMSAutoID': smsAutoID,
              'UserNo': '0',
              'UserType': 'Parent',
              'MacAddress': 'xxxxxx',
              'ApplicationType': 'Parent',
              'AppVersion': '1.0',
              'clientCode': widget.clientCode.toString(),
              'appSignature':appSignature,
            },
          );

          http.Response response = await http.post(postGenerateOtpUri);
          if (response.statusCode != HttpStatusCodes.CREATED) {
            FlushbarMessage.show(
              context,
              null,
              response.body.toString(),
              MessageTypes.INFORMATION,
            );
          } else {
            setState(() {
              cnt++;
              smsAutoID = json.decode(response.body);
            });

            FlushbarMessage.show(
              context,
              AppTranslations.of(context).text("key_send_otp"),
              AppTranslations.of(context).text("key_enter_otp_instruction"),
              MessageTypes.INFORMATION,
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
    } else {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_can_not_send_otp"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      isLoading = false;
    });
  }
}
