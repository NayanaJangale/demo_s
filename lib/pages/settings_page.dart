import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_alert_dialog.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_cupertino_action.dart';
import 'package:student/components/custom_cupertino_action_message.dart';
import 'package:student/components/custom_cupertino_icon_action.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/internet_connection.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_locales.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/localization/application.dart';
import 'package:student/models/academic_year.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/change_password_page.dart';
import 'package:student/pages/login_page.dart';
import 'package:student/themes/menu_type.dart';
import 'package:student/themes/app_settings_change_notifier.dart';
import 'package:student/themes/theme_constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading;
  String _loadingText;

  String selectedThemeName,
      selectedMenuType,
      selectedLocale = 'en',
      selectedAcademicYear;

  AppSettingsChangeNotifier _appSettingsChangeNotifier;

  List<AcademicYear> academicYears = [];
  Student student;
  DBHandler _dbHandler;

  @override
  void initState() {
    // TODO: implement initState
    application.onLocaleChanged = onLocaleChange;
    _isLoading = false;
    _loadingText = 'Applying changes . .';
    _dbHandler = DBHandler();

    fetchAcademicYear().then((res) {
      setState(() {
        academicYears = res;
      });
    });

    if (AppData.current.preferences != null) {
      selectedThemeName =
          AppData.current.preferences.getString('theme') ?? ThemeNames.Purple;

      AppData.current.preferences.getString('menuType') == MenuTitles.List
          ? selectedMenuType = MenuTitles.List
          : selectedMenuType = MenuTitles.Grid;

      selectedLocale =
          AppData.current.preferences.getString('localeLang') ?? 'en';
      student = AppData.current.student;
      selectedAcademicYear = AppData.current.student.academic_year;
    } else {
      selectedThemeName = ThemeNames.Purple;
      selectedMenuType = MenuTitles.List;
      selectedLocale = 'en';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appSettingsChangeNotifier =
        Provider.of<AppSettingsChangeNotifier>(context);

    AppData.current.preferences.getString('menuType') == MenuTitles.List
        ? selectedMenuType = AppTranslations.of(context).text("key_list")
        : selectedMenuType = AppTranslations.of(context).text("key_grid");

    return CustomProgressHandler(
      isLoading: _isLoading,
      loadingText: _loadingText,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.user.displayName),
            subtitle: AppTranslations.of(context).text("key_app_settings"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey.withOpacity(0.2),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppTranslations.of(context).text("key_appearance"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppTranslations.of(context).text("key_theme"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    themeColors.length,
                        (index) =>
                        getThemeColor(
                          themeColors[index],
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showLocaleList();
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context).text("key_language"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            selectedLocale == 'en' ? 'English' : 'मराठी',
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showMenuTypeList();
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context).text("key_menu_type"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            selectedMenuType,
                            textAlign: TextAlign.right,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              Container(
                color: Colors.grey.withOpacity(0.2),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    AppTranslations.of(context).text("key_account"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showAcademicYearList();
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context).text("key_academic_year"),
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            selectedAcademicYear ?? "",
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),

             /* GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SwitchAccountPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context)
                                .text("key_switch_account"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
              /*Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),*/
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context)
                                .text("key_change_password"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _logout();
                },
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            AppTranslations.of(context).text("key_logout"),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Divider(
                  height: 0.0,
                  color: Colors.black12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getThemeColor(ThemeColor themeColor) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectedThemeName = themeColor.caption;

          ThemeData themeData;
          switch (selectedThemeName) {
            case ThemeNames.Purple:
              themeData = ThemeConfig.purpleThemeData(context);
              break;
            case ThemeNames.Blue:
              themeData = ThemeConfig.blueThemeData(context);
              break;
            case ThemeNames.Teal:
              themeData = ThemeConfig.tealThemeData(context);
              break;
            case ThemeNames.Amber:
              themeData = ThemeConfig.amberThemeData(context);
              break;
          }
          _appSettingsChangeNotifier.setTheme(selectedThemeName, themeData);

          AppData.current.preferences.setString('theme', selectedThemeName);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: themeColor.color,
              radius: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                themeColor.caption == selectedThemeName
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: themeColor.caption == selectedThemeName
                    ? Theme
                    .of(context)
                    .primaryColor
                    : Theme
                    .of(context)
                    .secondaryHeaderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMenuTypeList() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            message: CustomCupertinoActionMessage(
              message: AppTranslations.of(context).text("key_select_menu_type"),
            ),
            actions: List<Widget>.generate(
              menuTypes.length,
                  (index) =>
                  CustomCupertinoIconAction(
                    isImage: false,
                    iconData: menuTypes[index].icon,
                    actionText: AppTranslations.of(context)
                        .text("key_${menuTypes[index].typeTitle}"),
                    actionIndex: index,
                    onActionPressed: () {
                      setState(() {
                        selectedMenuType = menuTypes[index].typeTitle;

                        AppData.current.preferences
                            .setString('menuType', selectedMenuType);

                        selectedMenuType = AppTranslations.of(context)
                            .text("key_$selectedMenuType");
                      });
                      Navigator.pop(context);
                    },
                  ),
            ),
          ),
    );
  }

  void showLocaleList() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            message: CustomCupertinoActionMessage(
              message: AppTranslations.of(context).text(
                  "key_select_app_language"),
            ),
            actions: List<Widget>.generate(
              projectLocales.length,
                  (index) =>
                  CustomCupertinoIconAction(
                    isImage: true,
                    imagePath: projectLocales[index].image,
                    actionText: projectLocales[index].title,
                    actionIndex: index,
                    onActionPressed: () {
                      setState(() {
                        _isLoading = true;
                        _loadingText = 'Applying Changes . .';

                        selectedLocale = projectLocales[index].lanaguageCode;
                        _appSettingsChangeNotifier
                            .setLocale(
                            new Locale(projectLocales[index].lanaguageCode));

                        AppData.current.preferences
                            .setString('localeLang', selectedLocale)
                            .then((result) {
                          _isLoading = false;
                        });
                      });

                      Navigator.pop(context);
                    },
                  ),
            ),
          ),
    );
  }

  void onLocaleChange(Locale locale) async {
    setState(() {
      AppTranslations.load(locale);
    });
  }

  List<Widget> getThemeMenuTypeList(BuildContext context) {
    List<Widget> menuItems = [];

    for (int i = 0; i < menuTypes.length; i++) {
      menuItems.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            showMenuTypeList();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(menuTypes[i].typeTitle),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    menuTypes[i].icon,
                    color: Theme
                        .of(context)
                        .primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return menuItems;
  }

  void _logout() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CustomActionDialog(
            actionName: AppTranslations.of(context).text("key_yes"),
            onActionTapped: () {
              DBHandler().logout(AppData.current.user);
              AppData.current.user = null;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                    (Route<dynamic> route) => false,
              );
            },
            actionColor: Colors.red,
            message: AppTranslations.of(context).text(
                "key_logout_confirmation"),
            onCancelTapped: () {
              Navigator.pop(context);
            },
          ),
    );
  }
  void showAcademicYearList() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            message: CustomCupertinoActionMessage(
              message: AppTranslations.of(context).text(
                  "key_select_academic_year"),
            ),
            actions: List<Widget>.generate(
              academicYears.length,
                  (index) =>
                  CustomCupertinoActionSheetAction(
                    actionIndex: index,
                    actionText: academicYears[index].yr_desc,
                    onActionPressed: () async {
                      setState(() {

                        selectedAcademicYear = academicYears[index].yr_desc;
                        student.yr_no = academicYears[index].yr_no;
                        student.academic_year = academicYears[index].yr_desc;
                      });
                      student = await _dbHandler.updateStudent(student);
                      if (student != null) {
                      /*  FlushbarMessage.show(
                          context,
                          null,
                          AppTranslations.of(context).text(
                              "key_change_academic_year"),
                          MessageTypes.ERROR,
                        );*/
                        AppData
                            .current
                            .student = student;
                        Navigator.pop(context);
                      } else {
                        FlushbarMessage.show(
                          context,
                          null,
                          AppTranslations.of(context).text(
                              "key_unable_to_perform_local_login"),
                          MessageTypes.ERROR,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
            ),
          ),
    );
  }
  Future<List<AcademicYear>> fetchAcademicYear() async {
    List<AcademicYear> academicYears = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {
        String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
        if (connectionServerMsg != "key_check_internet") {
          Map<String, dynamic> params = {
            "clientCode": AppData
                .current
                .user != null
                ? AppData
                .current
                .user
                .clientCode
                .toString()
                : "",
          };
          Uri fetchSchoolsUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                AcademicYearUrls.GET_ACADEMIC_YEARS,
            params,
          );

          Response response = await get(fetchSchoolsUri);
          if (response.statusCode != HttpStatusCodes.OK) {
            FlushbarMessage.show(
                context, null, response.body, MessageTypes.WARNING);
          } else {
            List responseData = json.decode(response.body);
            academicYears = responseData
                .map(
                  (item) => AcademicYear.fromJson(item),
            )
                .toList();
          }
        } else {
          FlushbarMessage.show(
            context,
            AppTranslations.of(context).text("key_no_internet"),
            AppTranslations.of(context).text("key_check_internet"),
            MessageTypes.WARNING,
          );
        }
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      _isLoading = false;
    });

    return academicYears;
  }
}
