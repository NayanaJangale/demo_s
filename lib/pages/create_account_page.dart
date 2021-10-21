import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/forms/create_account_form.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/pages/select_school_page.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool isLoading = false;
  String loadingText;

  TextEditingController displayNameController = new TextEditingController();
  TextEditingController mobileNoController = new TextEditingController();
  FocusNode displayNameFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  @override
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
            subtitle: 'Create Account !',
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
                child: CreateAccountForm(
                  displayNameCaption:
                  AppTranslations.of(context).text("key_your_name"),
                  mobileNoCaption:
                  AppTranslations.of(context).text("key_mobile_no"),
                  continueButtonCaption:
                  AppTranslations.of(context).text("key_continue"),
                  backButtonCaption:
                  AppTranslations.of(context).text("key_back"),
                  displayNameFocusNode: this.displayNameFocusNode,
                  mobileNoFocusNode: this.mobileNoFocusNode,
                  displayNameInputAction: TextInputAction.next,
                  mobileNoInputAction: TextInputAction.done,
                  displayNameController: this.displayNameController,
                  mobileNoController: this.mobileNoController,
                  onContinueButtonPressed: () {
                    String RetMsg = _validateRegistrationForm(
                        displayNameController.text, mobileNoController.text);
                    if (RetMsg != '') {
                      FlushbarMessage.show(
                        context,
                        null,
                        RetMsg,
                        MessageTypes.INFORMATION,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SelectSchoolPage(
                            display_name: displayNameController.text,
                            mobileNo: mobileNoController.text
                                .toString()
                                .replaceAll("+91", ''),
                            select_school_for: SelectSchoolFor.CREATE_ACCOUNT,
                          ),
                        ),
                      );
                    }
                  },
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                  },
                  onDisplayNameSubmitted: (value) {
                    this.displayNameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(this.mobileNoFocusNode);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validateRegistrationForm(String userID, String mobNo) {
    if (userID.length == 0) {
      return AppTranslations.of(context).text("key_enter_user_name");
    }
    if (mobileNoController.text.contains("+91")) {
      if (mobNo.length != 13) {
        return AppTranslations.of(context).text("key_enter_mobile_number");
      }
    }
    if (!mobileNoController.text.contains("+91")) {
      if (mobNo.length != 10) {
        return AppTranslations.of(context).text("key_enter_mobile_number");
      }
    }
    return "";
  }
}
