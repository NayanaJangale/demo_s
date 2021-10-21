import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/forms/change_password_form.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/select_ward_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isLoading;
  String _loadingText;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._isLoading = false;
    this._loadingText = 'Loading . .';
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title:AppTranslations.of(context).text("key_hi")+
                StringHandlers.capitalizeWords(
                    AppData.current.user.displayName),
            subtitle: AppTranslations.of(context).text("key_change_password"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 30,
                  top: 20,
                ),
                child: ChangePasswordForm(
                  oldPasswordCaption: AppTranslations.of(context).text("key_current_password"),
                  oldPasswordInputAction: TextInputAction.next,
                  oldPasswordFocusNode: this.oldPasswordFocusNode,
                  oldPasswordController: this.oldPasswordController,
                  onOldPasswordSubmitted: (value) {
                    this.oldPasswordFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(this.passwordFocusNode);
                  },
                  passwordCaption: AppTranslations.of(context).text("key_new_password"),
                  passwordInputAction: TextInputAction.next,
                  passwordFocusNode: this.passwordFocusNode,
                  passwordController: this.passwordController,
                  onPasswordSubmitted: (value) {
                    this.passwordFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(this.confirmPasswordFocusNode);
                  },
                  confirmPasswordCaption: AppTranslations.of(context).text("key_Confirm_password"),
                  confirmPasswordInputAction: TextInputAction.done,
                  confirmPasswordFocusNode: this.confirmPasswordFocusNode,
                  confirmPasswordController: this.confirmPasswordController,
                  changeButtonCaption: AppTranslations.of(context).text("key_Change"),
                  cancelButtonCaption:AppTranslations.of(context).text("key_Concel"),
                  onChangeButtonPressed: () {
                    String valMessage = getValidationMessage();
                    if (valMessage != '') {
                      FlushbarMessage.show(
                          context, null, valMessage, MessageTypes.WARNING);
                    } else {
                      changePassword();
                    }
                  },
                  onCancelButtonPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword() async {
    setState(() {
      _isLoading = true;
      _loadingText = AppTranslations.of(context).text("key_processing_text");
    });
    try {

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postChangePasswordUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              UserUrls.CHANGE_PARENT_PASSWORD,
          {
            UserFieldNames.OldPassword: oldPasswordController.text,
            UserFieldNames.NewPassword: confirmPasswordController.text,
            UserFieldNames.clientCode: AppData.current.user.clientCode,
            UserFieldNames.UserNo: AppData.current.user.userNo.toString(),
          },
        );

        Response response = await post(postChangePasswordUri);
        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == HttpStatusCodes.ACCEPTED) {
          // TODO: Local Password Change
          User user = AppData.current.user;
          user.IsLoggedIn = 1;
          user.remember_me = 1;
          user.clientName = user.clientName;
          user.clientCode = user.clientCode;
          user.loginPassword = confirmPasswordController.text;

          user = await DBHandler().updateUser(user);
          AppData.current.user = user;

          FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_dear") +
                  user.displayName +
                  AppTranslations.of(context).text("key_successfully_change_password"),
              MessageTypes.INFORMATION);

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
              context, null, response.body, MessageTypes.WARNING);
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
          AppTranslations.of(context).text("key_Change_password_error"),
          MessageTypes.ERROR);
    }
    setState(() {
      _isLoading = false;
    });
  }

  getValidationMessage() {
    if (this.oldPasswordController.text == null ||
        this.oldPasswordController.text == '')
      return AppTranslations.of(context).text("key_Current_pass_mandatory");

    if (this.passwordController.text == null ||
        this.passwordController.text == '') return AppTranslations.of(context).text("key_Current_new_mandatory");

    if (this.confirmPasswordController.text == null ||
        this.confirmPasswordController.text == '')
      return AppTranslations.of(context).text("key_old_pass_mandatory");

    Pattern pattern = r'^(?=.{6,}$)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?\W).*$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(passwordController.text))
      return AppTranslations.of(context).text("key_password_strength");

    if (this.oldPasswordController.text == this.passwordController.text)
      return AppTranslations.of(context).text("key_old_new_pass_diff");

    if (this.passwordController.text != this.confirmPasswordController.text)
      return AppTranslations.of(context).text("key_old_confirm_pass_diff");

    return '';
  }
}
