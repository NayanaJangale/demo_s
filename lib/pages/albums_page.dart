import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
import 'package:student/models/album.dart';
import 'package:student/models/student.dart';
import 'package:student/pages/album_page.dart';

class AlbumsPage extends StatefulWidget {
  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  bool isLoading;
  String loadingText;
  List<Album> _albums = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.isLoading = false;
    this.loadingText = 'Loading . .';

    fetchStudentAlbums().then((result) {
      setState(() {
        _albums = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this.isLoading,
      loadingText: this.loadingText,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_gallery"),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchStudentAlbums().then((result) {
              setState(() {
                _albums = result;
              });
            });
          },
          child: _albums != null && _albums.length > 0
              ? GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: List<Widget>.generate(
                    _albums.length,
                    (index) => getAlbumCard(_albums[index]),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomDataNotFound(
                        description: AppTranslations.of(context)
                            .text("key_gallery_not_available"),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Future<String> getImageUrl(Album albumItem) =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                AlbumUrls.GET_ALBUM_PHOTO,
          ).replace(queryParameters: {
            "album_id": albumItem.album_id.toString(),
            "photo_id": "-1",
            StudentFieldNames.brcode: AppData.current.student.brcode,
            "clientCode": AppData.current.user.clientCode
          }).toString();
        }
      });

  Widget getAlbumCard(Album albumItem) {
    return FutureBuilder<String>(
        future: getImageUrl(albumItem),
        builder: (context, AsyncSnapshot<String> snapshot) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Card(
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
                        value: 20,
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlbumPage(
                          albumID: albumItem.album_id,
                          albumDesc: albumItem.album_desc,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                  bottom: 4.0,
                  left: 3.0,
                  right: 3.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.zero,
                              topRight: Radius.zero,
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                                albumItem.album_desc != null
                                    ? StringHandlers.capitalizeWords(
                                        albumItem.album_desc)
                                    : "",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Colors.white,
                                        )),
                          )),
                    ],
                  )),
            ],
          );
        });
  }

  Future<List<Album>> fetchStudentAlbums() async {
    List<Album> albums = [];

    try {
      setState(() {
        isLoading = true;
      });


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode
        };

        Uri fetchStudentAlbumsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              AlbumUrls.GET_TEACHER_ALBUMS,
          params,
        );

        Response response = await get(fetchStudentAlbumsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body.toString(), MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          albums = responseData
              .map(
                (item) => Album.fromJson(item),
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

    return albums;
  }
}
