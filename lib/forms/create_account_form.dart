import 'package:flutter/material.dart';
import 'package:student/components/SmsAutoFill.dart';
import 'package:student/components/custom_dark_button.dart';
import 'package:student/components/custom_light_button.dart';
import 'package:student/components/custom_text_box.dart';
import 'package:student/localization/app_translations.dart';

class CreateAccountForm extends StatelessWidget {
  final String displayNameCaption,
      mobileNoCaption,
      continueButtonCaption,
      backButtonCaption;
  final FocusNode displayNameFocusNode, mobileNoFocusNode;
  final TextInputAction displayNameInputAction, mobileNoInputAction;

  final TextEditingController displayNameController, mobileNoController;
  final Function onContinueButtonPressed,
      onDisplayNameSubmitted,
      onMobileNoSubmitted,
      onBackButtonPressed;

  CreateAccountForm({
    this.displayNameCaption,
    this.mobileNoCaption,
    this.continueButtonCaption,
    this.displayNameFocusNode,
    this.mobileNoFocusNode,
    this.displayNameInputAction,
    this.mobileNoInputAction,
    this.displayNameController,
    this.mobileNoController,
    this.onContinueButtonPressed,
    this.onDisplayNameSubmitted,
    this.onMobileNoSubmitted,
    this.backButtonCaption,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextBox(
            inputAction: displayNameInputAction,
            focusNode: displayNameFocusNode,
            onFieldSubmitted: onDisplayNameSubmitted,
            labelText: displayNameCaption,
            controller: displayNameController,
            icon: Icons.person,
            keyboardType: TextInputType.text,
            colour: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10.0,
          ),
          PhoneFieldHint(
            child: TextField(
              keyboardType: TextInputType.number,
              maxLength: 13,
              decoration: InputDecoration(
                prefixIcon: new Icon(
                  Icons.phone_iphone,
                  color: Theme.of(context).primaryColor,
                ),
                labelText: mobileNoCaption,
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              controller: mobileNoController,
              focusNode: mobileNoFocusNode,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomDarkButton(
                  caption: continueButtonCaption,
                  onPressed: onContinueButtonPressed,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: CustomLightButton(
                  caption: backButtonCaption,
                  onPressed: onBackButtonPressed,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            AppTranslations.of(context).text("key_create_account_intruction"),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
