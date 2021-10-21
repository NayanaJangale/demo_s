import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_circular_item.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/notification_topics.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/circular.dart';
import 'package:student/models/student.dart';

class CircularPage extends StatefulWidget {
  @override
  _CircularPageState createState() => _CircularPageState();
}

class _CircularPageState extends State<CircularPage> {
  GlobalKey<ScaffoldState> _circularPageGK;

  bool _isLoading;
  String _loadingText;

  List<Circular> _circulars = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._circularPageGK = GlobalKey<ScaffoldState>();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchCirculars().then((result) {
      setState(() {
        _circulars = result;
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
        key: this._circularPageGK,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle:
                AppTranslations.of(context).text("key_see_your_circulars"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchCirculars().then((result) {
              setState(() {
                _circulars = result;
              });
            });
          },
          child: _circulars != null && _circulars.length > 0
              ? ListView.builder(
                  itemCount: _circulars.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCircularItem(
                      networkPath: '',
                      onItemTap: () {},
                      periods: _circulars[index].periods,
                      circular: _circulars[index],
                    );
                  },
                )
              : Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomDataNotFound(
                        description:AppTranslations.of(context).text("key_circulars_not_available"),

                      );
                    },
                  ),
              ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(Circular circular) => NetworkHandler.getServerWorkingUrl()
      .then((connectionServerMsg) {
    if (connectionServerMsg != "key_check_internet") {
        return Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              'Circular/GetCircularImage',
        ).replace(queryParameters: {
          "circular_no":
          circular.circular_no.toString(),
          StudentFieldNames.brcode:
          AppData.current.student.brcode,
          "clientCode":
              AppData.current.user.clientCode
        }).toString();
    }
  });

  Future<List<Circular>> fetchCirculars() async {
    List<Circular> circulars = [];
    try {
      setState(() {
        _isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
          'user_no': AppData.current.user.userNo.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              CircularUrls.GET_STUDENT_CIRCULARS,
          params,
        );

        print(fetchSchoolsUri);

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            circulars = responseData
                .map(
                  (item) => Circular.fromJson(item),
                )
                .toList();
          });
          DBHandler().updateNotificationsByTopic(NotificationTopics.CIRCULARS);
          Student student = AppData.current.student;
          int count  = await DBHandler().getUnReadNotifications(
            student.stud_no.toString(),
            student.brcode,
            student.client_code,
          );
          setState(() {
            FlutterAppBadger.updateBadgeCount(count);
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
        AppTranslations.of(context).text("key_api_error") + e.toString(),
        MessageTypes.WARNING,
      );
      print(e.toString());
    }
    setState(() {
      _isLoading = false;
    });

    return circulars;
  }
}
