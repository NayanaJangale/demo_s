import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_list_divider.dart';
import 'package:student/components/custom_message_item.dart';
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
import 'package:student/models/message.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';

import 'message_details_page.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  GlobalKey<ScaffoldState> _messagesPageGK;

  bool _isLoading;
  String _loadingText;

  List<Message> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messagesPageGK = GlobalKey<ScaffoldState>();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';
    fetchMessages().then((result) {
      setState(() {
        this._messages = result;
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
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_see_your_messages"),
          ),
          elevation: 0.0,
        ),
        key: _messagesPageGK,
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            fetchMessages().then((result) {
              setState(() {
                this._messages = result;
              });
            });
          },
          child: _messages != null && _messages.length > 0
              ? ListView.separated(
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<String>(
                        future: getImageUrl(_messages[index]),
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          return CustomMessageItem(
                            onMessageItemTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MessageDetailsPage(
                                    messageTitle: _messages[index].teacher_name,
                                    networkPath: snapshot.data.toString(),
                                    message: _messages[index].message,
                                    messageNo: _messages[index].message_no.toString(),
                                    timeStamp: DateFormat('dd MMM hh:mm aaa')
                                        .format(_messages[index].msg_date),
                                    recipients: _messages[index].recipients,
                                  ),
                                ),
                              );
                            },
                            messageTimestamp: DateFormat('dd-MM-yyyy').format(_messages[index].msg_date) == DateFormat('dd-MM-yyyy').format(DateTime.now())
                                ? DateFormat('hh:mm a').format(_messages[index].msg_date)
                                : DateFormat('dd-MMM').format(_messages[index].msg_date),

                            messageTitle: StringHandlers.capitalizeWords(
                                _messages[index].teacher_name),
                            messageBody: _messages[index].message,
                            messageIndex: index,
                          );
                        });


                  },
                  separatorBuilder: (context, index) {
                    return CustomListSeparator();
                  },
                )
              : Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return CustomDataNotFound(
                description: AppTranslations.of(context)
                    .text("key_messages_not_available"),
              );
            },
          ),
        ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(Message message) =>   NetworkHandler.getServerWorkingUrl()
      .then((connectionServerMsg) {
    if (connectionServerMsg != "key_check_internet") {
        return Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              'Message/GetMessageImage',
        ).replace(queryParameters: {
          "MessageNo": message.message_no.toString(),
          StudentFieldNames.brcode:
          AppData.current.student.brcode,
          UserFieldNames.clientCode:
          AppData.current.user.clientCode,
        }).toString();
    }
  });

  Future<List<Message>> fetchMessages() async {
    List<Message> messages = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

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
              MessageUrls.GET_STUDENTS_MESSAGES,
          params,
        );

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
            messages = responseData
                .map(
                  (item) => Message.fromJson(item),
                )
                .toList();
          });
          DBHandler().updateNotificationsByTopic(NotificationTopics.MESSAGE);
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
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      _isLoading = false;
    });

    return messages;
  }
}
