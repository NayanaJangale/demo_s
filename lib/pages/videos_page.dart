import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_data_not_found.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/student.dart';
import 'package:student/models/video.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _videosPageGK;

  List<Video> _videos = [];
  String _thumbnail_url = "http://img.youtube.com/vi/video_key/0.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    _videosPageGK = GlobalKey<ScaffoldState>();

    fetchVideos().then((result) {
      setState(() {
        _videos = result;
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
        key: _videosPageGK,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_videos"),
          ),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchVideos().then((result) {
              setState(() {
                _videos = result;
              });
            });
          },
          child: _videos != null && _videos.length > 0
              ? Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: ListView.builder(
                    itemCount: _videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      String video_id = "";
                      String imageUrl = '';
                      video_id = YoutubePlayer.convertUrlToId(
                          _videos[index].video_url,
                          trimWhitespaces: true);

                      if(video_id!=null&&video_id!=""){
                        imageUrl = _thumbnail_url;
                        imageUrl = imageUrl.replaceAll('video_key', video_id);
                      }


                      print(imageUrl);
                      print(_videos[index].video_url);

                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _launchURL(_videos[index].video_url);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 4.0,
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor: Theme.of(context)
                                            .secondaryHeaderColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    textBaseline: TextBaseline.alphabetic,
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
                                          _videos[index].title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return CustomDataNotFound(
                  description: AppTranslations.of(context)
                      .text("key_videos_not_available"),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Video>> fetchVideos() async {
    List<Video> videos = [];
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
          StudentFieldNames.brcode: student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg + ProjectSettings.rootUrl + VideoUrls.GET_VIDEOS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            videos = responseData
                .map(
                  (item) => Video.fromMap(item),
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

    return videos;
  }

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
}
