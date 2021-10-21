import 'package:flutter/material.dart';
import 'package:student/components/SmsAutoFill.dart';
import 'package:student/components/custom_dark_button.dart';
import 'package:student/components/custom_light_button.dart';
import 'package:student/localization/app_translations.dart';

class ConfirmOTPForm extends StatefulWidget {
  final String caption, confirmButtonCaption, resendButtonCaption;
  final TextEditingController otpController;

  final FocusNode otpFocusNode;

  final TextInputAction otpInputAction;

  final Function onConfirmButtonPressed, onResendButtonPressed;

  const ConfirmOTPForm({
    this.caption,
    this.confirmButtonCaption,
    this.resendButtonCaption,
    this.otpController,
    this.otpFocusNode,
    this.otpInputAction,
    this.onConfirmButtonPressed,
    this.onResendButtonPressed,
  });

  @override
  _ConfirmOTPFormState createState() => _ConfirmOTPFormState();
}

class _ConfirmOTPFormState extends State<ConfirmOTPForm> with CodeAutoFill  {
  String otpCode = " ";

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

   listenForCode();
    listning();
  }
   Future<void> listning() async {
    await SmsAutoFill().listenForCode;
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PinFieldAutoFill(
            autofocus: true,
            decoration: UnderlineDecoration(
              textStyle: TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: PinListenColorBuilder(Colors.deepPurple, Colors.green),
              // color: Theme.of(context).primaryColor
            ),
            currentCode: otpCode.replaceAll(' ', ''),
            otpController: widget.otpController,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CustomDarkButton(
                  caption: widget.confirmButtonCaption,
                  onPressed: widget.onConfirmButtonPressed,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: CustomLightButton(
                  caption: widget.resendButtonCaption,
                  onPressed: widget.onResendButtonPressed,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            AppTranslations.of(context).text("key_enter_otp_instruction"),
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
