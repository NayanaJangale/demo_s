import 'package:flutter/material.dart';
import 'package:student/components/SmsAutoFill.dart';
import 'package:student/components/custom_dark_button.dart';
import 'package:student/components/custom_light_button.dart';
import 'package:student/localization/app_translations.dart';

class ForgotPasswordForm extends StatelessWidget {
  final String mobNoCaption, continueButtonCaption, backButtonCaption;
  final TextEditingController mobNoController;
  final FocusNode mobNoFOcusNode;

  final TextInputAction mobNoInputAction;

  final Function onContinueButtonPressed, onBackButtonPressed;

  const ForgotPasswordForm({
    this.mobNoCaption,
    this.continueButtonCaption,
    this.backButtonCaption,
    this.mobNoController,
    this.onContinueButtonPressed,
    this.onBackButtonPressed,
    this.mobNoFOcusNode,
    this.mobNoInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PhoneFieldHint(
            child: TextField(
              keyboardType: TextInputType.number,
              maxLength: 13,
              decoration: InputDecoration(
                prefixIcon: new Icon(
                  Icons.phone_iphone,
                  color: Theme.of(context).primaryColor,
                ),
                labelText: mobNoCaption,
                labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16),
              ),
              controller: mobNoController,
              focusNode: mobNoFOcusNode,
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
            AppTranslations.of(context).text("key_password_instruction"),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
