import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/forms/forgot_password_form.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/pages/select_school_page.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isLoading = false;
  String loadingText;

  final GlobalKey<ScaffoldState> _forgetPasswordPageGlobalKey =
  new GlobalKey<ScaffoldState>();

  TextEditingController mobNoController = new TextEditingController();

  FocusNode mobNoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        appBar: Platform.isIOS ? AppBar(
          title: CustomAppBar(
            title: 'Soft Campus',
            subtitle: 'Forgot Password ?',
          ),
        ) : null,
        key: _forgetPasswordPageGlobalKey,
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
                child: ForgotPasswordForm(
                    mobNoFOcusNode: mobNoFocusNode,
                    mobNoInputAction: TextInputAction.done,
                    backButtonCaption:  AppTranslations.of(context).text("key_back"),
                    continueButtonCaption:  AppTranslations.of(context).text("key_continue"),
                    mobNoCaption: AppTranslations.of(context).text("key_mobile_no"),
                    mobNoController: mobNoController,
                    onBackButtonPressed: () {
                      Navigator.pop(context);
                    },
                    onContinueButtonPressed: _selectSchForForgetPassword
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectSchForForgetPassword() async {
    if (mobNoController.text.contains("+91")) {
      if (mobNoController.text.length != 13) {
        FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_enter_mobile_number"),
          MessageTypes.INFORMATION,
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SelectSchoolPage(
                  mobileNo: mobNoController.text.toString().replaceAll("+91", ''),
                  select_school_for: SelectSchoolFor.FORGOT_PASSWORD,
                ),
          ),
        );
      }
    } else {
      if (mobNoController.text.length != 10) {
        FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_enter_mobile_number"),
          MessageTypes.INFORMATION,
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SelectSchoolPage(
                  mobileNo: mobNoController.text.toString().replaceAll("+91", ''),
                  select_school_for: SelectSchoolFor.FORGOT_PASSWORD,
                ),
          ),
        );
      }
    }
  }
}