import 'package:student/handlers/string_handlers.dart';

class SoftCampusConfig {
  String ConfigurationGroup;
  String ConfigurationName;
  String ConfigurationValue;

  SoftCampusConfig({
    this.ConfigurationGroup,
    this.ConfigurationName,
    this.ConfigurationValue,
  });

  SoftCampusConfig.fromJson(Map<String, dynamic> map) {
    ConfigurationGroup = map[SoftCampusConfigFieldNames.ConfigurationGroup]  ?? StringHandlers.NotAvailable;
    ConfigurationName = map[SoftCampusConfigFieldNames.ConfigurationName]  ?? StringHandlers.NotAvailable;
    ConfigurationValue = map[SoftCampusConfigFieldNames.ConfigurationValue]  ?? StringHandlers.NotAvailable;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    SoftCampusConfigFieldNames.ConfigurationGroup: ConfigurationGroup,
    SoftCampusConfigFieldNames.ConfigurationName: ConfigurationName,
    SoftCampusConfigFieldNames.ConfigurationValue: ConfigurationValue,
  };
}

class SoftCampusConfigFieldNames {
  static const String ConfigurationValue = "ConfigurationValue";
  static const String ConfigurationName = "ConfigurationName";
  static const String ConfigurationGroup = "ConfigurationGroup";
}

class SoftCampusConfigUrls {
  static const String GET_GetConfigration = 'MIS/GetConfigration';
}

