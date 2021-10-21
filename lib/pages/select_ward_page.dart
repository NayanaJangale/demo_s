import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';
import 'package:student/app_data.dart';
import 'package:student/components/auto_update_dialog.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/SoftCampusConfig.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/bottom_nevigation_page.dart';
class SelectWardPage extends StatefulWidget {
  @override
  _SelectWardPageState createState() => _SelectWardPageState();
}

class _SelectWardPageState extends State<SelectWardPage> {
  GlobalKey<ScaffoldState> _selectWardPageGK;

  List<SoftCampusConfig> _softCampusConfig = [];
  bool _isLoading;
  String _loadingText,brcode;
  Uri uri;
  List<Student> _students = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchConfiguration().then((result) {
      _softCampusConfig = result;
      if (_softCampusConfig != null && _softCampusConfig.length > 0) {
        if (double.parse(_softCampusConfig[0].ConfigurationValue) >
            ProjectSettings.AppVersion &&
            _softCampusConfig[0].ConfigurationName == 'Student App Version') {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return WillPopScope(
                  onWillPop: _onBackPressed,
                  child: AutoUpdateDialog(
                    color: Theme.of(context).primaryColor,
                    message:
                    AppTranslations.of(context).text("key_auto_update_instruction"),
                    onOkayPressed: () {
                      LaunchReview.launch(
                        androidAppId: "net.demo.s",
                        iOSAppId: "",
                      );
                      exit(0);
                    },
                  ),
                );
              });
        }
      }
    });
    _selectWardPageGK = GlobalKey<ScaffoldState>();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchWards().then((result) {
      setState(() {
        _students = result;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _selectWardPageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                AppData.current.user.displayName,
            subtitle: AppTranslations.of(context).text("key_select_ward"),
          ),
          leading: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Container(
                width: 50,
                height: 40,
                child:  uri != null ? Image.network(uri .toString(),
                  fit: BoxFit.fill,
                ): Container(),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchWards().then((result) {
              setState(() {
                _students = result;
              });
            });
          },
          child: _students != null && _students.length > 0 ?
          GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(3.0),
            children: List<Widget>.generate(
              _students.length,
                  (index) => getStudentCard(
                _students[index],
              ),
            ),
          ):Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return CustomDataNotFound(
                  description:AppTranslations.of(context).text("key_student_not_available"),

                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget getStudentCard(Student student) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AppData.current.student = student;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BottomNevigationPage(),
            // builder: (_) => SubjectsPage(),
          ),
        );
      },
      child: Card(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 40.0,
                  ),
                  child: Text(
                    StringHandlers.capitalizeWords(student.student_name),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Text(
                    AppTranslations.of(context).text("key_class") +
                        ' ' +
                        student.class_name +
                        ' ' +
                        student.division_name,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                top: 15.0,
              ),
              alignment: FractionalOffset.topCenter,
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: student.gender == 'M'
                        ? Image.asset("assets/images/boy.png")
                        : Image.asset("assets/images/girl.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Student>> fetchWards() async {
    List<Student> wards;
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          'MobileNo': AppData.current.user.loginID,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg + ProjectSettings.rootUrl + StudentUrls.GET_WARDS,
          params,
        );
//softcore.co.in/softSchoolapi/Students/GetStudentsByParentNo
        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          List responseData = json.decode(response.body);
          wards = responseData
              .map(
                (item) => Student.fromMap(item),
          )
              .toList();

          for (Student student in wards) {
            student.client_code = AppData.current.user.clientCode;
          }
          setState(() {
            brcode = wards[0].brcode;
            NetworkHandler.getServerWorkingUrl()
                .then((connectionServerMsg) {
              if (connectionServerMsg != "key_check_internet") {
                setState(() {
                  uri = Uri.parse(
                    connectionServerMsg +
                        ProjectSettings.rootUrl +
                        'Users/GetClientPhoto',
                  ).replace(queryParameters: {
                    UserFieldNames.clientCode:
                    AppData.current.user.clientCode,
                    "brcode":brcode,
                  });
                });
              }
            });
          });

          DBHandler().deleteStudents(AppData.current.user.loginID);
          DBHandler().saveStudent(wards);
        }
      } else {
        wards = await DBHandler().getStudents(AppData.current.user.loginID);
        setState(() {
          brcode = wards[0].brcode;
          NetworkHandler.getServerWorkingUrl()
              .then((connectionServerMsg) {
            if (connectionServerMsg != "key_check_internet") {
              setState(() {
                uri = Uri.parse(
                  connectionServerMsg +
                      ProjectSettings.rootUrl +
                      'Users/GetClientPhoto',
                ).replace(queryParameters: {
                  UserFieldNames.clientCode:
                  AppData.current.user.clientCode,
                  "brcode":brcode,
                });
              });
            }
          });
        });
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

    return wards != null ? wards : [];
  }

  Future<List<SoftCampusConfig>> fetchConfiguration() async {
    List<SoftCampusConfig> softCampusConfigList = [];
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Loading . . .';
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchSchoolsUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SoftCampusConfigUrls.GET_GetConfigration,
        ).replace(
          queryParameters: {
            'ConfigurationName': 'Student App Version',
            'ConfigurationGroup': 'Auto Update For Android'
          },
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            softCampusConfigList = responseData
                .map(
                  (item) => SoftCampusConfig.fromJson(item),
            )
                .toList();
          });
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
        'Not able to fetch Configuration, please contact Software Provider!' +
            e.toString(),
        MessageTypes.ERROR,
      );
    }
    setState(() {
      _isLoading = false;
    });

    return softCampusConfigList;
  }
  Future<bool> _onBackPressed() {
    exit(1);
  }
}
