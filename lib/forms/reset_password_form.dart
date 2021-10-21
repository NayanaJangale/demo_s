import 'package:flutter/material.dart';
import 'package:student/components/custom_dark_button.dart';
import 'package:student/components/custom_light_button.dart';
import 'package:student/components/custom_password_box.dart';

class ResetPasswordForm extends StatelessWidget {
  final String passwordCaption,
      confirmPasswordCaption,
      confirmButtonCaption,
      backButtonCaption;
  final TextInputAction passwordInputAction, confirmPasswordInputAction;
  final FocusNode passwordFocusNode, confirmPasswordFocusNode;

  final TextEditingController passwordController, confirmPasswordController;
  final Function onConfirmButtonPressed,
      onPasswordSubmitted,
      onBackButtonPressed;

  const ResetPasswordForm({
    this.passwordCaption,
    this.confirmPasswordCaption,
    this.confirmButtonCaption,
    this.passwordInputAction,
    this.confirmPasswordInputAction,
    this.passwordFocusNode,
    this.confirmPasswordFocusNode,
    this.passwordController,
    this.confirmPasswordController,
    this.onConfirmButtonPressed,
    this.onPasswordSubmitted,
    this.backButtonCaption,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomPasswordBox(
            inputAction: passwordInputAction,
            labelText: passwordCaption,
            controller: passwordController,
            focusNode: passwordFocusNode,
            icon: Icons.lock,
            keyboardType: TextInputType.text,
            colour: Theme.of(context).primaryColor,
            onFieldSubmitted: this.onPasswordSubmitted,
          ),
          SizedBox(
            height: 10.0,
          ),
          CustomPasswordBox(
            inputAction: confirmPasswordInputAction,
            labelText: confirmPasswordCaption,
            controller: confirmPasswordController,
            focusNode: confirmPasswordFocusNode,
            icon: Icons.lock,
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
                  caption: confirmButtonCaption,
                  onPressed: onConfirmButtonPressed,
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
            'Enter the password and confirm password to reset.',
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
