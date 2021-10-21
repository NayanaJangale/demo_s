import 'package:student/handlers/string_handlers.dart';

class User {
  String displayName;
  String loginID;
  String loginPassword;
  String mobileNo;
  int userNo;
  String userStatus;
  String clientCode;
  String clientName;
  int IsLoggedIn;
  int remember_me;

  User({
    this.displayName,
    this.loginID,
    this.loginPassword,
    this.mobileNo,
    this.userNo,
    this.userStatus,
    this.clientCode,
    this.IsLoggedIn,
    this.clientName,
    this.remember_me,
  });

  User.fromMap(Map<String, dynamic> map) {
    displayName =
        map[UserFieldNames.DisplayName] ?? StringHandlers.NotAvailable;
    loginID = map[UserFieldNames.LoginID] ?? '';
    loginPassword = map[UserFieldNames.LoginPassword] ?? '';
    mobileNo = map[UserFieldNames.MobileNo] ?? StringHandlers.NotAvailable;
    userNo = map[UserFieldNames.UserNo] ?? 0;
    userStatus = map[UserFieldNames.UserStatus] ?? '';
    clientCode = map[UserFieldNames.clientCode] ?? StringHandlers.NotAvailable;
    IsLoggedIn = map[UserFieldNames.IsLoggedIn] ?? 0;
    clientName = map[UserFieldNames.clientName] ?? '';
    remember_me = map[UserFieldNames.remember_me] ?? 0;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        UserFieldNames.DisplayName: displayName,
        UserFieldNames.LoginID: loginID,
        UserFieldNames.LoginPassword: loginPassword,
        UserFieldNames.MobileNo: mobileNo,
        UserFieldNames.UserNo: userNo,
        UserFieldNames.UserStatus: userStatus,
        UserFieldNames.clientCode: clientCode,
        UserFieldNames.IsLoggedIn: IsLoggedIn,
        UserFieldNames.clientName: clientName,
        UserFieldNames.remember_me: remember_me,
      };
}

class UserFieldNames {
  static const String DisplayName = "DisplayName";
  static const String LoginID = "LoginID";
  static const String LoginPassword = "LoginPassword";
  static const String MobileNo = "MobileNo";
  static const String UserNo = "UserNo";
  static const String UserStatus = "UserStatus";
  static const String IsLoggedIn = "IsLoggedIn";
  static const String clientCode = 'clientCode';
  static const String clientName = 'clientName';
  static const String user_no = 'user_no';

  static const String OldPassword = "OldPassword";
  static const String NewPassword = "NewPassword";
  static const String remember_me = "remember_me";
}

class UserUrls {
  static const String GET_PARENT_DETAILS = 'Users/GetParentDetails';
  static const String GENERATE_OTP = 'SMS/GenerateOTP';
  static const String VALIDATE_OTP = 'SMS/ValidateOTP';
  static const String REGISTER_PARENT = 'Users/RegisterParent';
  static const String REGISTER_PARENT_WITHOUT_OTP = 'Users/RegisterParentWithoutOTP';
  static const String RESET_PARENT_PASSWORD = 'Users/ResetParentPassword';
  static const String CHANGE_PARENT_PASSWORD = 'Users/ChangeParentPassword';

}
