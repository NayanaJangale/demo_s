class Configuration {
  String confGroup, confName, confValue;

  Configuration({this.confGroup, this.confName, this.confValue,});

  Configuration.fromJson(Map<String, dynamic> map) {
    confGroup = map[ConfigurationFieldNames.ConfigurationGroup];
    confName = map[ConfigurationFieldNames.ConfigurationName];
    confValue = map[ConfigurationFieldNames.ConfigurationValue];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    ConfigurationFieldNames.ConfigurationGroup: confGroup,
    ConfigurationFieldNames.ConfigurationName: confName,
    ConfigurationFieldNames.ConfigurationValue: confValue,
  };
}

class ConfigurationFieldNames {
  static const String ConfigurationGroup = "ConfigurationGroup";
  static const String ConfigurationName = "ConfigurationName";
  static const String ConfigurationValue = "ConfigurationValue";
}

class ConfigurationUrls {
  static const String GET_CONFIGURATION_BY_GROUP = 'Configurations/GetConfigurationByGroup';
}

class ConfigurationGroups {
  static const String ADMISSION_FEES = 'Admission Fees';
  static const String Attendance = 'STUD_ATTENDANCE';
  static const String Result = 'Result';
  static const String Registration = 'Registration';
  static const String Profile = 'Profile';
}

class ConfigurationNames {
  static const String PAYMENT_GATEWAY = 'Payment Gateway';
  static const String SUBJECTWISE = 'SUBJECT_WISE';
  static const String forStudent = 'ForStudent';
  static const String OTP = 'OTP';
  static const String Updation = 'Updation';
}