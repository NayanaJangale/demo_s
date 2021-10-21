import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/localization/app_translations_delegate.dart';
import 'package:student/localization/application.dart';
import 'package:student/pages/welcome_page.dart';
import 'package:student/themes/app_settings_change_notifier.dart';
import 'package:student/themes/theme_constants.dart';
import 'constants/notification_channel.dart';
import 'handlers/notification_handler.dart';
import 'pages/home_page.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationHandler.processMessage(message.data);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  NotificationChannel.CHANNEL_ID,
  NotificationChannel.CHANNEL_NAME,
  NotificationChannel.CHANNEL_DESCRIPTION,
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //SharedPreferences.setMockInitialValues({});
  SharedPreferences.getInstance().then((preferences) {
    runApp(SoftCampus(preferences: preferences));
  });
}

class SoftCampus extends StatefulWidget {
  final SharedPreferences preferences;

  SoftCampus({
    this.preferences,
  });

  @override
  _SoftCampusState createState() => _SoftCampusState();
}

class _SoftCampusState extends State<SoftCampus> {
  @override
  Widget build(BuildContext context) {
    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Purple);

    Locale locale =
        new Locale((widget.preferences.getString('localeLang') ?? 'en'));

    return ChangeNotifierProvider<AppSettingsChangeNotifier>(
      create: (_) => AppSettingsChangeNotifier(
          _handleThemeConfiguration(), themeName, locale),
      child: AppWithCustomTheme(
        preferences: widget.preferences,
      ),
    );
  }

  ThemeData _handleThemeConfiguration() {
    String themeName =
        (widget.preferences.getString('theme') ?? ThemeNames.Purple);
    switch (themeName) {
      case ThemeNames.Purple:
        return ThemeConfig.purpleThemeData(context);
      case ThemeNames.Blue:
        return ThemeConfig.blueThemeData(context);
      case ThemeNames.Teal:
        return ThemeConfig.tealThemeData(context);
      case ThemeNames.Amber:
        return ThemeConfig.amberThemeData(context);
    }
  }
}

class AppWithCustomTheme extends StatefulWidget {
  final SharedPreferences preferences;

  AppWithCustomTheme({@required this.preferences});

  @override
  _AppWithCustomThemeState createState() => _AppWithCustomThemeState();
}

class _AppWithCustomThemeState extends State<AppWithCustomTheme> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppSettingsChangeNotifier>(context);
    onLocaleChange(theme.getLocale());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      color: Colors.white,
      title: 'Soft Campus',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      darkTheme: theme.getTheme(),
      themeMode: ThemeMode.light,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
      },
      home: WelcomePage(
        preferences: widget.preferences,
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("mr", ""),
      ],
    );
  }
}
