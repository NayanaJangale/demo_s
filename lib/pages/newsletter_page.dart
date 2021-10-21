import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:student/handlers/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/database_handler.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/newsletter.dart';
import 'package:student/models/notification.dart';
import 'package:student/models/student.dart';
import 'package:http/http.dart' as http;
import 'package:student/pages/full_screen_image_page.dart';
import 'package:student/pages/notification_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class NewsletterPage extends StatefulWidget {
  @override
  _NewsletterPageState createState() => _NewsletterPageState();
}

class _NewsletterPageState extends State<NewsletterPage> {
  bool _isLoading;
  String _loadingText;
  int unreadNotification = 0;
  GlobalKey<ScaffoldState> _newsletterPage;
  List<SoftCampusNotification> softcampusNotification = [];

  List<Newsletter> _newsletter = [];
  String _thumbnail_url = "http://img.youtube.com/vi/video_key/0.jpg";
  @override
  void initState() {
    // TODO: implement initState
    this._isLoading = false;
    this._loadingText = 'Loading . . .';
    super.initState();
    initNotifications();

    _newsletterPage = GlobalKey<ScaffoldState>();
    fetchNewsletter().then((result) {
      setState(() {
        _newsletter = result;
        if (AppData.current.student.birth_date != null) {
          String bdate =
          DateFormat('MM-dd').format(AppData.current.student.birth_date);
          String tdate = DateFormat('MM-dd').format(new DateTime.now());

          if (bdate == tdate) {
            _newsletter.insert(
                0,
                new Newsletter(
                    NewsDate: DateTime.now(),
                    NewsTitle: "Happy Birthday" +
                        " " +
                        AppData.current.student.student_name,
                    NewsDesc: "Wish You a Many Many Happy Returns Of the Day..",
                    news_type: "Birthday"));
          }
        }
      });
    });
    fetchUnReadNotifications();
  }
  initNotifications() async {
    try {
      NotificationHandler.subscribeTopics(FirebaseMessaging.instance);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.instance.getToken().then((token) {
        print(token);
        saveUserToken(token);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationHandler.processMessage(message.data);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _newsletterPage,
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context).text("key_welcometo") +
                      " " +
                      AppData.current.user.clientName ??
                  "",
            ),
            actions: <Widget>[
              new Stack(
                children: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NotificationPage(),
                            // builder: (_) => SubjectsPage(),
                          ),
                        );
                      }),
                  unreadNotification != 0
                      ? new Positioned(
                          right: 11,
                          top: 11,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              unreadNotification == 0
                                  ? ''
                                  : unreadNotification.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container()
                ],
              )
            ],
            elevation: 0.0,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              fetchNewsletter().then((result) {
                setState(() {
                  _newsletter = result;
                });
              });
            },
            child: _newsletter != null && _newsletter.length > 0
                ? Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      itemCount: _newsletter.length,
                      itemBuilder: (BuildContext context, int index) {
                        String video_id = "";
                        String imageUrl = '';
                        if (_newsletter[index].video_url != null &&
                            _newsletter[index].video_url != '') {
                          video_id = YoutubePlayer.convertUrlToId(
                              _newsletter[index].video_url,
                              trimWhitespaces: true);
                          if (video_id != null && video_id != "") {
                            imageUrl = _thumbnail_url;
                            imageUrl =
                                imageUrl.replaceAll('video_key', video_id);
                          }
                        }
                        return _newsletter[index].video_url != null &&
                                _newsletter[index].video_url != ''
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _launchURL(_newsletter[index].video_url);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 4.0,
                                              ),
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .secondaryHeaderColor,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.youtube,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  _newsletter[index].NewsTitle,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd hh:mm aaa')
                                                .format(_newsletter[index]
                                                    .NewsDate),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Container(
                                            child: Text(
                                              _newsletter[index].NewsDesc,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : _newsletter[index].news_type == 'Birthday'
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      right: 5.0,
                                    ),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset(
                                                "assets/images/bday_banner.jpg"),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              _newsletter[index].NewsTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              DateFormat('yyyy-MM-dd hh:mm aaa')
                                                  .format(_newsletter[index]
                                                      .NewsDate),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              child: Text(
                                                _newsletter[index].NewsDesc,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )

                                : FutureBuilder<String>(
                                    future: getImageUrl(_newsletter[index]),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        FullScreenImagePage(
                                                      dynamicObjects:
                                                          _newsletter,
                                                      imageType: 'Newsletter',
                                                      photoIndex: 0,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot.data != null
                                                    ? snapshot.data.toString()
                                                    : '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: AspectRatio(
                                                    aspectRatio: 16 / 9,
                                                    child: Image.network(
                                                      snapshot.data != null
                                                          ? snapshot.data
                                                              .toString()
                                                          : '',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 4),
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .secondaryHeaderColor,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                              ),
                                              child: Text(
                                                _newsletter[index].NewsTitle,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                DateFormat(
                                                        'yyyy-MM-dd hh:mm aaa')
                                                    .format(_newsletter[index]
                                                        .NewsDate),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                _newsletter[index].NewsDesc,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ],
                                        )),
                                      );
                                    });
                      },
                    ),
                  )
                :  Padding(
              padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 4),
              child:DefaultTextStyle(
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Quicksand',
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,

                ),
                textAlign: TextAlign.start,
                child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText( AppTranslations.of(context).text("key_dear_parents")+"  "
                          + StringHandlers.capitalizeWords(AppData.current.user.clientName) +" "+
                          AppTranslations.of(context)
                              .text("key_parents_welcome_instruction")),
                    ]
                ),
              ),
            ),
          )),
    );
  }
  Future<List<Newsletter>> fetchNewsletter() async {
    List<Newsletter> newsletter = [];
    try {
      setState(() {
        _isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              NewsletterUrls.GetNewsFeed,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
         /* FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);*/
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            newsletter = responseData
                .map(
                  (item) => Newsletter.fromMap(item),
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

    return newsletter;
  }

  Future<String> getImageUrl(Newsletter newsletter) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                'Video/GetNewsFeedImage',
          ).replace(queryParameters: {
            "NewsId": newsletter.NewsId.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.student.client_code,
          }).toString();
        }
      });

  _launchURL(String url) async {
    if (Platform.isIOS) {
      url = url.replaceAll('https://', '');
      url = url.replaceAll('http://', '');

      if (await canLaunch('youtube://' + url)) {
        await launch('youtube://' + url, forceSafariVC: false);
      } else {
        if (await canLaunch('https://' + url)) {
          await launch('https://' + url);
        } else {
          throw 'Could not launch https://' + url;
        }
      }
    } else {
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
  Future<void> saveUserToken(String token) async {
    try {
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          'ApplicationType': 'Student',
          'AppVersion': '1',
          'MacAddress': 'xxxxxx',
          "ClientCode": AppData.current.user.clientCode,
          "UserNo": AppData.current.user.userNo.toString(),
          "PackageName": "net.demo.s",
          'UserType': 'Parent',
          "RegistrationToken": token
        };

        Uri saveMessageUri = Uri.parse(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              SoftCampusNotificationUrls.GET_SAVEUSERTOKEN,
        ).replace(
          queryParameters: params,
        );

        http.Response response = await http.post(
          saveMessageUri,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: '',
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == HttpStatusCodes.ACCEPTED) {
        } else {
         /* FlushbarMessage.show(
            context,
            null,
            response.body.toString(),
            MessageTypes.ERROR,
          );*/
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
  }
  fetchUnReadNotifications() async {
    try {
      Student student = AppData.current.student;
        int count  = await DBHandler().getUnReadNotifications(
        student.stud_no.toString(),
        student.brcode,
        student.client_code,
      );
     setState(() {
       unreadNotification = count;
       FlutterAppBadger.updateBadgeCount(count);
     });
    } catch (e) {}
  }
}
