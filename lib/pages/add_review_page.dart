import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/custom_text_box.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/homework.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/bottom_nevigation_page.dart';
import 'package:student/pages/home_page.dart';

class AddReviewPage extends StatefulWidget {

  @override
  _AddReviewPage createState() => _AddReviewPage();
}

class _AddReviewPage extends State<AddReviewPage> {
  GlobalKey<ScaffoldState> _addReviewPageGK;
  bool isLoading;
  String loadingText;
  String msgKey;
  TextEditingController descController;
  FocusNode myFocusNode;
  @override
  void initState() {
    myFocusNode = FocusNode();
    msgKey = "key_loading_gallery";

    // TODO: implement initState
    super.initState();
    _addReviewPageGK = GlobalKey<ScaffoldState>();
    descController = TextEditingController();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';
  }

  @override
  Widget build(BuildContext context) {
    loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        key: _addReviewPageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                    AppData.current.student.student_name,
                  ),
              subtitle:
              AppTranslations.of(context).text("add_suggestion")),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        bottom: 10.0,
                        left: 10,
                        right: 10
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          border: Border.all(
                            width: 1.0,
                            color: Colors.grey[300],
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              top: 8.0,
                              bottom: 8.0
                          ),
                          child: TextFormField(
                            autofocus: true,
                            controller: descController,
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: AppTranslations.of(context)
                                  .text("add_suggestion_here"),
                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black45,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
               ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                String valMsg = getValidationMessage();
                if (valMsg != '') {
                  FlushbarMessage.show(
                    context,
                    null,
                    valMsg,
                    MessageTypes.ERROR,
                  );
                } else {
                  postReview();
                }
              },
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Text(
                      AppTranslations.of(context)
                          .text("key_submit"),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }


  String getValidationMessage() {
    if (descController.text == '') {
      return AppTranslations.of(context).text("key_enter_suggestion_description");
    }
    return "";
  }

  Future<void> postReview() async {
    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;

        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          "emp_no": "0",
          'Remark': descController.text,
          'ReviewFor': "Management",
           StudentFieldNames.brcode: student.brcode,
          'user_no': AppData.current.user.userNo.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString()
        };
        Uri fetchreviewUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              "Feedback/AddUserReview",
          params,
        );

        http.Response response = await http.post(
          fetchreviewUri,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: '',
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == HttpStatusCodes.CREATED) {
          setState(() {
            descController.text = '';
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                message: Text(
                  response.body,
                  style: TextStyle(fontSize: 18),
                ),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text(
                      AppTranslations.of(context).text("key_ok"),
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context,
                          true); // It worked for me instead of above line
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNevigationPage()),
                      );
                    },
                  )
                ],
              ),
            );
          });
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.INFORMATION,
          );
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
  }

}
