import 'package:flutter/material.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/forms/login_form.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/create_account_page.dart';
import 'package:student/pages/forgot_password_page.dart';
import 'package:student/pages/select_school_page.dart';
import 'package:student/pages/select_ward_page.dart';

class SelectSchoolFor {
  static const String LOGIN = "Login";
  static const String FORGOT_PASSWORD = "Forgot Password";
  static const String CREATE_ACCOUNT = "Registration";
}
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _loginPageGlobalKey;

  TextEditingController _userIDController;
  TextEditingController _userPasswordController;

  FocusNode _userIDFocusNode;
  FocusNode _passwordFocusNode;

  bool _isLoading;
  String _loadingText;

  DBHandler _dbHandler;
  bool isSelected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loginPageGlobalKey = GlobalKey<ScaffoldState>();

    _userIDController = TextEditingController();
    _userPasswordController = TextEditingController();

    _userIDFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _isLoading = false;
    _loadingText = 'Loading . . .';

    _dbHandler = DBHandler();
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _loginPageGlobalKey,
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
                child: LoginForm(
                  userIDCaption: AppTranslations.of(context).text("key_user_id"),
                  userIDController: this._userIDController,
                  passwordCaption: AppTranslations.of(context).text("key_password"),
                  userPassController: this._userPasswordController,
                  loginButtonCaption: AppTranslations.of(context).text("key_login"),
                  forgotPasswordCaption: AppTranslations.of(context).text("key_forgot_password"),
                  createAccountCaption: AppTranslations.of(context).text("key_create_account"),
                  onLoginButtonPressed: _login,
                  onForgotPassword: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    );
                  },
                  onCreateAccountPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountPage(),
                      ),
                    );
                  },
                  userIDFocusNode: this._userIDFocusNode,
                  passwordFocusNode: this._passwordFocusNode,
                  userIDInputAction: TextInputAction.next,
                  passwordInputAction: TextInputAction.done,
                  onUserIDSubmitted: (value) {
                    this._userIDFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(this._passwordFocusNode);
                  },
                  onValueChange: (val){
                    setState(() {
                      isSelected = val;
                    });
                  },
                  itemTitle: AppTranslations.of(context).text("key_Remember_me"),
                  isSelected: isSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _loadingText = 'Validating..';
    });

    try {
      String retMsg = await _validateLoginForm(
        _userIDController.text,
        _userPasswordController.text,
      );

      if (retMsg == '') {
        try {
          User user = await _dbHandler.getUser(_userIDController.text.trim(),
              _userPasswordController.text.trim());

          if (user != null && user.remember_me == 1) {
            AppData.current.user = await _dbHandler.login(user);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SelectWardPage(),
                //builder: (_) => MCQExamPage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectSchoolPage(
                  userId: _userIDController.text,
                  password: _userPasswordController.text,
                  select_school_for: SelectSchoolFor.LOGIN,
                  isSelected:isSelected,
                ),
              ),
            );
          }
        } catch (e) {
          FlushbarMessage.show(
              context,
              null,
              AppTranslations.of(context).text("key_Not_able_to_fetch_school"),
              MessageTypes.ERROR);
        }
      } else {
        FlushbarMessage.show(context, 'Warning', retMsg, MessageTypes.WARNING);
      }
    } catch (e) {
      FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_login_instuction"),
          MessageTypes.ERROR);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _validateLoginForm(String userID, String userPassword) async {
    if (userID.length == 0) {
      return  AppTranslations.of(context).text("key_enter_user_id");
    }

    if (userPassword.length == 0) {
      return  AppTranslations.of(context).text("key_enter_user_password");
    }

    if (userID.length != 10) {
      return AppTranslations.of(context).text("key_enter_mobile_number");
    }

    return "";
  }
}
