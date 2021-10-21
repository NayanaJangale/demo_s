import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_bus_schedule_item.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/bus_schedule.dart';
import 'package:student/models/student.dart';

class BusTrackingPage extends StatefulWidget {
  @override
  _BusTrackingPage createState() => _BusTrackingPage();
}

class _BusTrackingPage extends State<BusTrackingPage> {
  GlobalKey<ScaffoldState> _busTrackingGlobalKey;
  bool isLoading;
  String loadingText;
  List<BusSchedule> _busSchedule = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.isLoading = false;
    this.loadingText = 'Loading . . .';

    _busTrackingGlobalKey = GlobalKey<ScaffoldState>();
    fetchBusSchedule().then((result) {
      setState(() {
        _busSchedule = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle:
              AppTranslations.of(context).text("key_bus_tracking"),
            ),
            bottom: TabBar(
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              isScrollable: false,
              tabs: <Widget>[
                Tab(
                  text: AppTranslations.of(context).text("key_schedule"),
                ),
                Tab(
                  text: AppTranslations.of(context).text("key_tracking"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              BusScheduleTab(),
              BusScheduleTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget BusScheduleTab() {
    return RefreshIndicator(
      onRefresh: () async {
        fetchBusSchedule().then((result) {
          setState(() {
            _busSchedule = result;
          });
        });
      },
      child:_busSchedule != null && _busSchedule.length != 0
          ? ListView.builder(
        itemCount: _busSchedule.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomBusScheduleItem(
            point_name: _busSchedule[index].point_name,
            in_time: DateFormat('hh:mm aaa').format(_busSchedule[index].in_time),
            out_time: DateFormat('hh:mm aaa').format(_busSchedule[index].out_time)
          );
        },
      )
          : Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return CustomDataNotFound(
              description: AppTranslations.of(context)
                  .text("key_bus_schedule_not_avalialble"),
            );
          },
        ),
      ),
    );
  }

  Future<List<BusSchedule>> fetchBusSchedule() async {
    List<BusSchedule> busSchedule = [];
    try {
      setState(() {
        isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              BusScheduleUrls.GetBUSSCHEDULE,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            busSchedule = responseData
                .map(
                  (item) => BusSchedule.fromMap(item),
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
      isLoading = false;
    });
    return busSchedule;
  }
}
