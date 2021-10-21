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
import 'package:student/models/album.dart';
import 'package:student/models/album_photo.dart';
import 'package:student/models/student.dart';

import 'full_screen_image_page.dart';

class AlbumPage extends StatefulWidget {
  final int albumID;
  final String albumDesc;

  AlbumPage({this.albumID, this.albumDesc});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  bool isLoading;
  String loadingText;
  List<AlbumPhoto> _photos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.isLoading = false;
    this.loadingText = 'Loading . .';

    fetchAlbumPhotos().then((result) {
      setState(() {
        _photos = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: 'Hi, ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: 'Your Album Photos !',
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchAlbumPhotos().then((result) {
              setState(() {
                _photos = result;
              });
            });
          },
          child: _photos != null && _photos.length > 0
              ? GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: List<Widget>.generate(
                    _photos.length,
                    (index) => getAlbumCard(_photos[index], index),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'It seems your teachers didn\'t add any photos in the album..',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(AlbumPhoto photoItem) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
              connectionServerMsg +
                  ProjectSettings.rootUrl +
                  AlbumUrls.GET_ALBUM_PHOTO,
            ).replace(queryParameters: {
              "album_id": photoItem.album_id.toString(),
              "photo_id": photoItem.photo_id.toString(),
              StudentFieldNames.brcode: AppData.current.student.brcode,
              "clientCode": AppData.current.user.clientCode
            }).toString();

        }
      });

  Widget getAlbumCard(AlbumPhoto photoItem, int index) {
    return FutureBuilder<String>(
        future: getImageUrl(photoItem),
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
                      dynamicObjects:  _photos,
                      imageType: 'Album',
                      photoIndex: index,
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Future<List<AlbumPhoto>> fetchAlbumPhotos() async {
    List<AlbumPhoto> photos = [];

    try {
      setState(() {
        isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
          AlbumPhotoFieldNames.album_id: widget.albumID.toString()
        };

        Uri fetchStudentAlbumsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              AlbumPhotoUrls.GET_ALBUM_PHOTOS,
          params,
        );

        Response response = await get(fetchStudentAlbumsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          photos = responseData
              .map(
                (item) => AlbumPhoto.fromJson(item),
              )
              .toList();
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

    return photos;
  }
}
