import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_bar_chart.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/class_test.dart';
import 'package:student/models/student.dart';

class ClassTestPage extends StatefulWidget {
  @override
  _ClassTestPageState createState() => _ClassTestPageState();
}

class _ClassTestPageState extends State<ClassTestPage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _classTestPageGK;

  List<ChartData> _chartData = [];
  List<ClassTest> _classTests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._classTestPageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchClassTest().then((result) {
      setState(() {
        _classTests = result != null ? result : [];
        generateBarChartData();
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
        key: _classTestPageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_class_tests"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchClassTest().then((result) {
              setState(() {
                _classTests = result != null ? result : [];
                generateBarChartData();
              });
            });
          },
          child:_classTests != null && _classTests.length > 0? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CustomBarChart(
                chartTitle:
                AppTranslations.of(context).text("key_sub_wise_avg"),
                data: _chartData,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _classTests.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            // 10% of the width, so there are ten blinds.
                            colors: [
                              Theme.of(context).secondaryHeaderColor,
                              Theme.of(context).primaryColorLight,
                            ],
                            // whitish to gray
                            tileMode: TileMode
                                .repeated, // repeats the gradient over the canvas
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Text(
                                DateFormat("dd").format(DateTime.parse(
                                    _classTests[index].test_date)),
                                style:
                                Theme.of(context).textTheme.title.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Text(
                                DateFormat("MMM")
                                    .format(DateTime.parse(
                                    _classTests[index].test_date))
                                    .toUpperCase(),
                                style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        StringHandlers.capitalizeWords(
                            _classTests[index].subject_name +
                                ': ' +
                                _classTests[index].test_desc),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        _classTests[index].stud_attendence == "A"
                            ? "Absent, Marks: n/a"
                            : _classTests[index].stud_attendence == null
                            ? "Marks: n/a"
                            : "Marks: ${_classTests[index].obt_marks} / ${_classTests[index].total_marks}",
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 80,
                        ),
                        child: CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 3.0,
                          center: GradientText(
                            calculatePercentage(index).round().toString() + '%',
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).accentColor,
                                Theme.of(context).primaryColor,
                              ],
                            ),
                            style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          percent: calculatePercentage(index) / 100,
                          backgroundColor:
                          Theme.of(context).secondaryHeaderColor,
                          linearGradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColorLight,
                              Theme.of(context).accentColor,
                              Theme.of(context).primaryColor,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 85.0,
                        top: 0.0,
                        bottom: 0.0,
                      ),
                      child: Divider(
                        height: 0.0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ):Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return CustomDataNotFound(
                  description:AppTranslations.of(context).text("key_class_test_not_available"),

                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double calculatePercentage(index) {
    try {
      double percentage = (_classTests[index].stud_attendence != null &&
          _classTests[index].stud_attendence.toUpperCase() == 'P')
          ? _classTests[index].obt_marks / _classTests[index].total_marks * 100
          : 0;
      return percentage;
    } catch (e) {
      return 0;
    }
  }

  void generateBarChartData() {
    if (_classTests != null && _classTests.length > 0) {
      List<ChartData> data = [];
      for (ClassTest test in _classTests) {
        if ((test.stud_attendence != null &&
            test.stud_attendence.toUpperCase() == 'P')) {
          if (data.where((item) => item.barName == test.subject_name).length >
              0) {
            double avg = data
                .where((item) => item.barName == test.subject_name)
                .elementAt(0)
                .barValue;

            avg = avg + (test.obt_marks / test.total_marks * 100) / 2;

            ChartData dataItem = data
                .where((item) => item.barName == test.subject_name)
                .elementAt(0);

            dataItem.barValue = avg;
          } else {
            data.add(
              ChartData(
                barNo: data.length,
                barName: test.subject_name,
                barShortName: test.subject_name.substring(0, 3).toUpperCase(),
                barValue: (test.obt_marks / test.total_marks * 100),
              ),
            );
          }
        }
      }
      setState(() {
        _chartData = data;
      });
    }
  }

  List<PieChartSectionData> showingSections(double percentage) {
    return List.generate(2, (i) {
      final double radius = 18;
      switch (i) {
        case 0:
          return PieChartSectionData(
            title: '',
            color: Theme.of(context).primaryColor,
            value: percentage,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            title: '',
            color: Theme.of(context).secondaryHeaderColor,
            value: 100 - percentage,
            radius: radius,
          );
        default:
          return null;
      }
    });
  }

  Future<List<ClassTest>> fetchClassTest() async {
    List<ClassTest> classTests = [];
    try {
      setState(() {
        _isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.class_id: student.class_id.toString(),
          StudentFieldNames.division_id: student.division_id.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              ClassTestUrls.GET_STUDENT_TESTS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            classTests = responseData
                .map(
                  (item) => ClassTest.fromJson(item),
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
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      _isLoading = false;
    });

    return classTests;
  }
}
