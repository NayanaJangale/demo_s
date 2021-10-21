import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_document_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/circular.dart';
import 'package:student/models/document.dart';
import 'package:student/models/student.dart';
import 'package:student/constants/file_types.dart';
import 'package:path_provider/path_provider.dart';


class CircularDocumentsPage extends StatefulWidget {
  int circular_no;

  CircularDocumentsPage({this.circular_no});

  @override
  _CircularDocumentsPageState createState() => _CircularDocumentsPageState();
}

class _CircularDocumentsPageState extends State<CircularDocumentsPage> {
  bool _isLoading;
  String _loadingText, _version = 'Unknown';
  GlobalKey<ScaffoldState> _circularDownloadsPageGK;
  List<Document> _documents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._circularDownloadsPageGK = GlobalKey<ScaffoldState>();
    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchDocuments().then((result) {
      setState(() {
        _documents = result;
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
          key: _circularDownloadsPageGK,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_circular_document"),
              subtitle:
              AppTranslations.of(context).text("key_see_your_documents"),
            ),
            elevation: 0,
          ),
          body: _documents != null && _documents.length > 0
              ? ListView.separated(
            itemCount: _documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomDocumentItem(
                leading: Image.asset(
                  getImageNameByFileType(_documents[index].content_type),
                  height: 30,
                ),
                onItemTap: () {
                  downloadFile(
                      _documents[index].doc_id,
                      _documents[index].content_type,
                      _documents[index].caption
                  );
                },
                itemText: StringHandlers.capitalizeWords(
                    _documents[index].caption),
                itemIndex: index,
                subItemText: "",
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 55.0,
                  top: 0.0,
                  bottom: 0.0,
                ),
                child: Divider(
                  height: 0.0,
                ),
              );
            },
          )
              : Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              AppTranslations.of(context)
                  .text("key_select_document_category"),
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          )),
    );
  }

  Future<List<Document>> fetchDocuments() async {
    List<Document> documents = [];
    try {
      setState(() {
        _isLoading = true;
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          "circular_no": widget.circular_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              CircularUrls.GetCircularDocuments,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            documents = responseData
                .map(
                  (item) => Document.fromMap(item),
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

    return documents;
  }
  Future<void> downloadFile(int doc_id, String contentType,String caption) async {
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Downloading . .';
      });
      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "doc_id": doc_id.toString(),
          "circular_no": widget.circular_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri downloadUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                CircularUrls.GetCircularDocument,
            params);

        http.Response data = await http.get(downloadUri);
        var bytes = data.bodyBytes;
        PermissionStatus permissionStatus = await _getExternalStoragePermission();
        if (permissionStatus == PermissionStatus.granted) {
          final dir =  await getApplicationDocumentsDirectory();
          File temp = new File(dir.path+  caption);
          temp.writeAsBytes(bytes).then((res) {
            FlushbarMessage.show(
              context,
              caption,
              "File Successfully Downloaded..",
              MessageTypes.INFORMATION,
            );
            OpenFile.open(dir.path + caption, type: contentType, uti: "public.plain-text").then((res){
              if (res.message == 'No APP found to open this file。')
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    message: Text(
                      res.message,
                      style: TextStyle(fontSize: 18),
                    ),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text(
                          AppTranslations.of(context).text("key_ok"),
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context, true);
                        },
                      )
                    ],
                  ),
                );
              print(res.message);
            });
          });
        } else {
          _handleInvalidPermissions(permissionStatus);
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
  }
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to photos,media and files denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('photos,media and files  not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<PermissionStatus> _getExternalStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted ||
        permission == PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }
  String getImageNameByFileType(String fileType) {
    String imageName;
    switch (fileType) {
      case ContentType.text_plain:
        imageName = "assets/images/texts.png";
        break;
      case ContentType.application_excel:
        imageName = "assets/images/sheets.png";
        break;
      case ContentType.application_pdf:
        imageName = "assets/images/pdf.png";
        break;
      case ContentType.application_msword:
      case ContentType.application_msword1:
        imageName = "assets/images/docs.png";
        break;
      case ContentType.image_jpeg:
      case ContentType.image_png:
        imageName = "assets/images/images.png";
        break;
      default:
        imageName = "assets/images/docs.png";
        break;
    }

    return imageName;
  }
}

