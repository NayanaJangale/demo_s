import 'package:flutter/material.dart';
import 'package:student/themes/colors.dart';
import 'package:student/themes/text_styles.dart';

class ThemeColor {
  Color color;
  String caption;

  ThemeColor({
    this.color,
    this.caption,
  });
}

List<ThemeColor> themeColors = [
  ThemeColor(
    color: Colors.deepPurple,
    caption: ThemeNames.Purple,
  ),
  ThemeColor(
    color: Colors.blue,
    caption: ThemeNames.Blue,
  ),
  ThemeColor(
    color: Colors.teal,
    caption: ThemeNames.Teal,
  ),
  ThemeColor(
    color: Colors.amber,
    caption: ThemeNames.Amber,
  ),
];

class ThemeConfig {
  static purpleThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: PurpleTheme.primary,
      primaryColorDark: PurpleTheme.primaryDark,
      accentColor: PurpleTheme.primaryLight,
      primaryColorLight: PurpleTheme.primaryExtraLight1,
      scaffoldBackgroundColor: PurpleTheme.spacer,
      secondaryHeaderColor: PurpleTheme.primaryExtraLight2,
      backgroundColor: PurpleTheme.spacer,
      bottomAppBarColor: PurpleTheme.primary,
      textTheme: TextTheme(
        headline5: TextStyles.display3,
        headline4: TextStyles.display2,
        headline3: TextStyles.display1,
        headline1: TextStyles.headline,
        subtitle2: TextStyles.title,
        subtitle1: TextStyles.subtitle,
        bodyText1: TextStyles.bodyText1,
        bodyText2: TextStyles.bodyText2,
        button: TextStyles.button,
        caption: TextStyles.caption,
        overline: TextStyles.overline,
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        elevation: 0.0,
        color: PurpleTheme.primary,
        textTheme: TextTheme(
          headline5: TextStyles.display3,
          headline4: TextStyles.display2,
          headline3: TextStyles.display1,
          headline1: TextStyles.headline,
          subtitle2: TextStyles.title,
          subtitle1: TextStyles.subtitle,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          caption: TextStyles.caption,
          overline: TextStyles.overline,
        ),
      ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
        labelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static blueThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: BlueTheme.primary,
      primaryColorDark: BlueTheme.primaryDark,
      accentColor: BlueTheme.primaryLight,
      primaryColorLight: BlueTheme.primaryExtraLight1,
      scaffoldBackgroundColor: BlueTheme.spacer,
      secondaryHeaderColor: BlueTheme.primaryExtraLight2,
      textTheme: TextTheme(
        headline5: TextStyles.display3,
        headline4: TextStyles.display2,
        headline3: TextStyles.display1,
        headline1: TextStyles.headline,
        subtitle2: TextStyles.title,
        subtitle1: TextStyles.subtitle,
        bodyText1: TextStyles.bodyText1,
        bodyText2: TextStyles.bodyText2,
        button: TextStyles.button,
        caption: TextStyles.caption,
        overline: TextStyles.overline,
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        elevation: 0.0,
        color: BlueTheme.primary,
        textTheme: TextTheme(
          headline5: TextStyles.display3,
          headline4: TextStyles.display2,
          headline3: TextStyles.display1,
          headline1: TextStyles.headline,
          subtitle2: TextStyles.title,
          subtitle1: TextStyles.subtitle,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          caption: TextStyles.caption,
          overline: TextStyles.overline,
        ),
      ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
        labelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: BlueTheme.backgroundColor,
      focusColor: BlueTheme.primary,
      dividerColor: BlueTheme.spacer,
    );
  }

  static tealThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: TealTheme.primary,
      primaryColorDark: TealTheme.primaryDark,
      accentColor: TealTheme.primaryLight,
      primaryColorLight: TealTheme.primaryExtraLight1,
      scaffoldBackgroundColor: TealTheme.spacer,
      secondaryHeaderColor: TealTheme.primaryExtraLight2,
      textTheme: TextTheme(
        headline5: TextStyles.display3,
        headline4: TextStyles.display2,
        headline3: TextStyles.display1,
        headline1: TextStyles.headline,
        subtitle2: TextStyles.title,
        subtitle1: TextStyles.subtitle,
        bodyText1: TextStyles.bodyText1,
        bodyText2: TextStyles.bodyText2,
        button: TextStyles.button,
        caption: TextStyles.caption,
        overline: TextStyles.overline,
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        elevation: 0.0,
        color: TealTheme.primary,
        textTheme: TextTheme(
          headline5: TextStyles.display3,
          headline4: TextStyles.display2,
          headline3: TextStyles.display1,
          headline1: TextStyles.headline,
          subtitle2: TextStyles.title,
          subtitle1: TextStyles.subtitle,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          caption: TextStyles.caption,
          overline: TextStyles.overline,
        ),
      ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
        labelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: TealTheme.backgroundColor,
      focusColor: TealTheme.primary,
      dividerColor: TealTheme.spacer,
    );
  }

  static amberThemeData(BuildContext context) {
    return Theme.of(context).copyWith(
      brightness: Brightness.light,
      primaryColor: AmberTheme.primary,
      primaryColorDark: AmberTheme.primaryDark,
      accentColor: AmberTheme.primaryLight,
      primaryColorLight: AmberTheme.primaryExtraLight1,
      scaffoldBackgroundColor: AmberTheme.spacer,
      secondaryHeaderColor: AmberTheme.primaryExtraLight2,
      backgroundColor: AmberTheme.backgroundColor,
      focusColor: AmberTheme.primary,
      dividerColor: AmberTheme.spacer,
      textTheme: TextTheme(
        headline5: TextStyles.display3,
        headline4: TextStyles.display2,
        headline3: TextStyles.display1,
        headline1: TextStyles.headline,
        subtitle2: TextStyles.title,
        subtitle1: TextStyles.subtitle,
        bodyText1: TextStyles.bodyText1,
        bodyText2: TextStyles.bodyText2,
        button: TextStyles.button,
        caption: TextStyles.caption,
        overline: TextStyles.overline,
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        elevation: 0.0,
        color: AmberTheme.primary,
        textTheme: TextTheme(
          headline5: TextStyles.display3,
          headline4: TextStyles.display2,
          headline3: TextStyles.display1,
          headline1: TextStyles.headline,
          subtitle2: TextStyles.title,
          subtitle1: TextStyles.subtitle,
          bodyText1: TextStyles.bodyText1,
          bodyText2: TextStyles.bodyText2,
          button: TextStyles.button,
          caption: TextStyles.caption,
          overline: TextStyles.overline,
        ),
      ),
      tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
        labelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyles.bodyText2.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ThemeConstants {
  static const String currentTheme = 'currentTheme';
  static const String isActive = 'isActive';
}

class ThemeNames {
  static const String Purple = 'Purple';
  static const String Blue = 'Blue';
  static const String Teal = 'Teal';
  static const String Amber = 'Amber';
}
