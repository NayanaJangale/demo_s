import 'package:flutter/material.dart';
import 'package:student/components/custom_dark_button.dart';
import 'package:student/components/custom_light_button.dart';
import 'package:student/components/custom_password_box.dart';
import 'package:student/localization/app_translations.dart';

class ChangePasswordForm extends StatelessWidget {
  final String oldPasswordCaption,
      passwordCaption,
      confirmPasswordCaption,
      changeButtonCaption,
      cancelButtonCaption;

  final TextInputAction oldPasswordInputAction,
      passwordInputAction,
      confirmPasswordInputAction;

  final FocusNode oldPasswordFocusNode,
      passwordFocusNode,
      confirmPasswordFocusNode;

  final TextEditingController oldPasswordController,
      passwordController,
      confirmPasswordController;

  final Function onChangeButtonPressed,
      onPasswordSubmitted,
      onOldPasswordSubmitted,
      onCancelButtonPressed;

  ChangePasswordForm({
    this.oldPasswordCaption,
    this.passwordCaption,
    this.confirmPasswordCaption,
    this.changeButtonCaption,
    this.cancelButtonCaption,
    this.oldPasswordInputAction,
    this.passwordInputAction,
    this.confirmPasswordInputAction,
    this.oldPasswordFocusNode,
    this.passwordFocusNode,
    this.confirmPasswordFocusNode,
    this.oldPasswordController,
    this.passwordController,
    this.confirmPasswordController,
    this.onChangeButtonPressed,
    this.onPasswordSubmitted,
    this.onOldPasswordSubmitted,
    this.onCancelButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomPasswordBox(
            inputAction: this.oldPasswordInputAction,
            labelText: this.oldPasswordCaption,
            controller: this.oldPasswordController,
            focusNode: this.oldPasswordFocusNode,
            icon: Icons.lock_outline,
            keyboardType: TextInputType.text,
            colour: Theme.of(context).primaryColor,
            onFieldSubmitted: this.onOldPasswordSubmitted,
          ),
          SizedBox(
            height: 10.0,
          ),
          CustomPasswordBox(
            inputAction: this.passwordInputAction,
            labelText: this.passwordCaption,
            controller: this.passwordController,
            focusNode: this.passwordFocusNode,
            icon: Icons.lock_outline,
            keyboardType: TextInputType.text,
            colour: Theme.of(context).primaryColor,
            onFieldSubmitted: this.onPasswordSubmitted,
          ),
          SizedBox(
            height: 10.0,
          ),
          CustomPasswordBox(
            inputAction: this.confirmPasswordInputAction,
            labelText: this.confirmPasswordCaption,
            controller: this.confirmPasswordController,
            focusNode: this.confirmPasswordFocusNode,
            icon: Icons.lock_outline,
            keyboardType: TextInputType.text,
            colour: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomDarkButton(
                  caption: changeButtonCaption,
                  onPressed: onChangeButtonPressed,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: CustomLightButton(
                  caption: cancelButtonCaption,
                  onPressed: onCancelButtonPressed,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            AppTranslations.of(context).text("key_change_password_instruction"),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
