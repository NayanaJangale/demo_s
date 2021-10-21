import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSettingsChangeNotifier with ChangeNotifier {
  ThemeData _themeData;
  String _themeName;
  Locale _locale;

  AppSettingsChangeNotifier(this._themeData, this._themeName, this._locale);

  getLocale() => _locale;
  getTheme() => _themeData;
  getThemeName() => _themeName;

  setTheme(String themeName, ThemeData theme) {
    _themeData = theme;
    _themeName = themeName;

    notifyListeners();
  }

  setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  static AppSettingsChangeNotifier of(BuildContext context, {bool allowNull = false}) {
    try {
      return Provider.of<AppSettingsChangeNotifier>(context, listen: false);
    } catch (error) {
      if (!allowNull) throw error;
      return null;
    }
  }
}
