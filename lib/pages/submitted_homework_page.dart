import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/submitted_hw_detail.dart';
import 'package:student/models/user.dart';
import 'package:student/pages/full_screen_image_page.dart';

class SubmittedHomeworkPage extends StatefulWidget {
  int hw_no,seq_no;
  String remark;
  SubmittedHomeworkPage({this.hw_no,this.seq_no,this.remark});
  @override
  _SubmittedHomeworkPage createState() => _SubmittedHomeworkPage();
}

class _SubmittedHomeworkPage extends State<SubmittedHomeworkPage> {
  GlobalKey<ScaffoldState> _submittedhwkey;
  bool isLoading;
  String loadingText;
  String msgKey;
  List<SubmittesHWDetail> submittedHWList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _submittedhwkey = GlobalKey<ScaffoldState>();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';

    msgKey = "key_loading_gallery";

    fetchHWPhotos().then((result) {
      setState(() {
        this.submittedHWList = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        key: _submittedhwkey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                  AppData.current.student.student_name,
                ),
            subtitle: AppTranslations.of(context).text("key_submited_homework"),
          ),

        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchHWPhotos().then((result) {
              setState(() {
                submittedHWList = result != null ? result : [];
              });
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child:GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(3.0),
                    children: List<Widget>.generate(
                      submittedHWList.length,
                          (index) => getAlbumPhotoCard(submittedHWList[index], index),
                    ),
                  )
                //:Text("Loading..."),
              ),
              Container(
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(5),
                width: double.infinity,
                color: Colors.grey[100],
                child: Text( AppTranslations.of(context).text("key_teacher_remark")+" : "+" ${widget.remark!=null? widget.remark : AppTranslations.of(context).text("key_not_varified")}",style: TextStyle(color: Colors.black, fontSize: 14),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<String> getImageUrl(SubmittesHWDetail submittesHWDetail) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                SubmittesHWDetailUrls.GET_SubmittedHWPhoto,
          ).replace(queryParameters: {
            SubmittesHWDetailFieldNames.seq_no:
            submittesHWDetail.seq_no.toString(),
            SubmittesHWDetailFieldNames.ent_no:
            submittesHWDetail.ent_no.toString(),
            "brcode": AppData.current.student.brcode,
            UserFieldNames.clientCode: AppData.current.user.clientCode,
            UserFieldNames.UserNo: AppData.current.user != null
                ? AppData.current.user.userNo.toString()
                : '',
            UserFieldNames.user_no: AppData.current.user != null
                ? AppData.current.user.userNo.toString()
                : '',
            'UserType': 'Student',
            'ApplicationType': 'Student',
            'AppVersion': '1',
            'MacAddress': 'xxxxxx',
          }).toString();
        }
      });

  Widget getAlbumPhotoCard(SubmittesHWDetail submittesHWDetail, int index) {
    return  FutureBuilder<String>(
        future: getImageUrl(submittesHWDetail),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: CachedNetworkImage(
                imageUrl: snapshot.data.toString(),
                imageBuilder: (context, imageProvider) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      snapshot.data.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 60.0, top: 60.0, bottom: 60.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                errorWidget: (context, url, error) => Container(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImagePage(
                      dynamicObjects: submittedHWList,
                      imageType: 'SubmittedHW',
                      photoIndex: index,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Future<List<SubmittesHWDetail>> fetchHWPhotos() async {
    List<SubmittesHWDetail> submittedHWs = [];

    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchteacherhwUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                SubmittesHWDetailUrls.GET_SubmittedHWPhotos,
            {
              SubmittesHWDetailFieldNames.seq_no: widget.seq_no.toString(),
              "user_no": AppData.current.user.userNo.toString(),
              "brcode": AppData.current.student.brcode.toString(),
              UserFieldNames.clientCode: AppData.current.user.clientCode,
              UserFieldNames.UserNo: AppData.current.user != null
                  ? AppData.current.user.userNo.toString()
                  : '',
              'UserType': 'Student',
              'ApplicationType': 'Student',
              'AppVersion': '1',
              'MacAddress': 'xxxxxx',
            });

        Response response = await get(fetchteacherhwUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            "",
            response.body,
            MessageTypes.ERROR,
          );

        } else {
          List responseData = json.decode(response.body);
          submittedHWs = responseData
              .map(
                (item) => SubmittesHWDetail.fromJson(item),
          )
              .toList();
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.ERROR,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.ERROR,
      );
    }

    setState(() {
      isLoading = false;
    });

    return submittedHWs;
  }
}
