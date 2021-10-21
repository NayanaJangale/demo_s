import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/custom_text_box.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_request_methods.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/homework.dart';
import 'package:student/models/student.dart';
import 'package:student/models/submitted_hw_detail.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/homework_page.dart';
import 'package:student/themes/colors.dart';
import 'package:student/themes/theme_constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
class AddSubmitHomeworkPage extends StatefulWidget {
  int hw_no;
  DateTime submissionDate;
  List<SubmittesHWDetail> submittedHWList = [];
  AddSubmitHomeworkPage({this.hw_no, this.submissionDate});
  @override
  _AddSubmitHomeworkPage createState() => _AddSubmitHomeworkPage();
}

class _AddSubmitHomeworkPage extends State<AddSubmitHomeworkPage> {
  GlobalKey<ScaffoldState> _submitHomeworkPageGK;
  bool isLoading;
  String loadingText,msgKey;
  TextEditingController descController;
  List<Asset> images = [];
  List<SubmittesHWDetail> submittedHWList = [];
  FocusNode myFocusNode;
  @override
  void initState() {
    myFocusNode = FocusNode();
    msgKey = "key_loading_gallery";

    // TODO: implement initState
    super.initState();
    _submitHomeworkPageGK = GlobalKey<ScaffoldState>();
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
        key: _submitHomeworkPageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                    AppData.current.student.student_name,
                  ),
              subtitle:
                  AppTranslations.of(context).text("key_submit_your_homework")),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: CustomTextBox(
                      focusNode: myFocusNode,
                      inputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {},
                      labelText: AppTranslations.of(context)
                          .text("key_description"),
                      controller: descController,
                      icon: Icons.description,
                      keyboardType: TextInputType.text,
                      colour: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Container(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          loadAssets();
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                top: 15.0,
                                right: 15.0,
                                bottom: 15.0,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              AppTranslations.of(context)
                                  .text("key_add_homework_photos"),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                fontWeight: FontWeight.w500,
                                color:
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 0.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Divider(
                      color: Colors.black54,
                      height: 0.0,
                    ),
                  ),
                  Expanded(child: buildGridView()),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (DateTime.now().isBefore(widget.submissionDate) ==
                    true ||
                    DateTime.now()
                        .difference(widget.submissionDate)
                        .inDays ==
                        0) {
                  String valMsg = getValidationMessage();
                  if (valMsg != '') {
                    FlushbarMessage.show(
                      context,
                      null,
                      valMsg,
                      MessageTypes.ERROR,
                    );
                  } else {
                    postHomework(widget.hw_no);
                  }
                }
              },
              child: DateTime.now().isBefore(widget.submissionDate) ==
                  true ||
                  DateTime.now()
                      .difference(widget.submissionDate)
                      .inDays == 0
                  ? Container(
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
              )
                  : Container(
                color: Theme.of(context).primaryColorLight,
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
  Widget buildGridView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: List.generate(
          images.length,
          (index) => AssetThumb(
            asset: images[index],
            width: 300,
            height: 300,
            quality: 100,
            spinner: Padding(
              padding: const EdgeInsets.all(18.0),
              child: LiquidCircularProgressIndicator(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                direction: Axis.horizontal,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = AppTranslations.of(context).text("key_no_error_found");

    String theme = AppData.current.preferences.getString('theme');
    String actionBarColor, selectCircleStrokeColor, statusBarColor;

    switch (theme) {
      case ThemeNames.Purple:
        setState(() {
          actionBarColor = PurpleThemeColorStrings.primary;
          selectCircleStrokeColor = PurpleThemeColorStrings.primaryExtraLight1;
          statusBarColor = PurpleThemeColorStrings.primary;
        });
        break;
      case ThemeNames.Blue:
        setState(() {
          actionBarColor = BlueThemeColorStrings.primary;
          selectCircleStrokeColor = BlueThemeColorStrings.primaryExtraLight1;
          statusBarColor = BlueThemeColorStrings.primary;
        });
        break;
      case ThemeNames.Teal:
        setState(() {
          actionBarColor = TealThemeColorStrings.primary;
          selectCircleStrokeColor = TealThemeColorStrings.primaryExtraLight1;
          statusBarColor = TealThemeColorStrings.primary;
        });
        break;
      case ThemeNames.Amber:
        setState(() {
          actionBarColor = AmberThemeColorStrings.primary;
          selectCircleStrokeColor = AmberThemeColorStrings.primaryExtraLight1;
          statusBarColor = AmberThemeColorStrings.primary;
        });
        break;
    }

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: actionBarColor,
          //  actionBarColor: Theme.of(context).primaryColor.toString(),
          actionBarTitle: AppTranslations.of(context).text("key_pick_image"),
          allViewTitle: AppTranslations.of(context).text("key_all_photos"),
          useDetailsView: false,
          selectCircleStrokeColor: selectCircleStrokeColor,
          statusBarColor: statusBarColor,
        ),
      );

      descController = descController;
    } on Exception catch (e) {
      error = e.toString();
      FlushbarMessage.show(
        context,
        null,
        error,
        MessageTypes.ERROR,
      );
    }

    // If the widget was removed from the tree while the asynchronous platform

    if (!mounted) return;
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    setState(() {
      images = resultList;
    });
  }
  String getValidationMessage() {
    if (descController.text == '') {
      return AppTranslations.of(context).text("key_enter_homework_description");
    }

    if (images.length == 0) {
      return AppTranslations.of(context).text("key_add_one_or_more_image");
    }

    return "";
  }
  Future<void> postHomework(int hw_no) async {
    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;

        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          'hw_desc': descController.text,
          'hw_no': hw_no.toString(),
          StudentFieldNames.brcode: student.brcode,
          'user_no': AppData.current.user.userNo.toString()
        };
        Uri fetchsubmithwUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              HomeworkUrls.SUBMIT_HOMEWORK,
          params,
        );

        http.Response response = await http.post(
          fetchsubmithwUri,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: '',
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == HttpStatusCodes.CREATED) {
          // post Homework Photos
          if (images != null && images.length > 0) {
            await postHomeworkImage(int.parse(response.body.toString()));
          }
          setState(() {
            descController.text = '';
            images = [];
          });
        } else {
          FlushbarMessage.show(
            context,
            null,
            AppTranslations.of(context).text("key_homework_already_submitted"),
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
  Future<void> postHomeworkImage(int seq_no) async {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Student student = AppData.current.student;
      Uri postUri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            'Homework/PostSubmittedHwPhoto',
      ).replace(
        queryParameters: {
          'seq_no': seq_no.toString(),
          StudentFieldNames.brcode: student.brcode,
          'user_no': AppData.current.user.userNo.toString(),
          UserFieldNames.clientCode: AppData.current.user.clientCode,
          UserFieldNames.UserNo: AppData.current.user != null
              ? AppData.current.user.userNo.toString()
              : '',
          'UserType': 'Student',
          'ApplicationType': 'Student',
          'AppVersion': '1',
          'MacAddress': 'xxxxxx',
        },
      );

      int i = 0;
      for (; i < images.length; i++) {
        setState(() {
          loadingText = 'Uploading ${i + 1} of ${images.length} image(s).';
        });

        final imageUploadRequest =
            http.MultipartRequest(HttpRequestMethods.POST, postUri);

        ByteData data = await images[i].getByteData(quality: 60);
        final file = await http.MultipartFile.fromBytes(
          'image',
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          filename: 'Photo_$i.jpg',
          contentType: MediaType(
            'image',
            'jpeg',
          ),
        );

        imageUploadRequest.fields['ext'] = 'jpeg';
        imageUploadRequest.files.add(file);

        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode != HttpStatusCodes.CREATED) {
          break;
        }
      }

      if (i == images.length) {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
            message: Text(
              AppTranslations.of(context)
                  .text("key_submit_homework_successfully"),
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  AppTranslations.of(context).text("key_ok"),
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeworkPage(),
                    ),
                  );

                  // It worked for me instead of above line
                },
              )
            ],
          ),
        );
      } else {
        FlushbarMessage.show(
          context,
          null,
          'Homework Submission failed.',
          MessageTypes.WARNING,
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
  }
}
