import 'dart:convert';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_cupertino_action.dart';
import 'package:student/components/custom_cupertino_action_message.dart';
import 'package:student/components/custom_document_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/components/overlay_for_select_page.dart';
import 'package:student/constants/file_types.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/document.dart';
import 'package:student/models/download_category.dart';
import 'package:student/models/student.dart';

class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _downloadsPageGK;

  List<DownloadCategory> _downloadCategories = [];
  List<Document> _documents = [];

  String _category = '';

  DownloadCategory selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._downloadsPageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . . .';

    fetchDownloadCategories().then((result) {
      setState(() {
        _downloadCategories = result;
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
        key: _downloadsPageGK,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle:
                AppTranslations.of(context).text("key_see_your_downloads"),
          ),
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (selectedCategory != null) {
              fetchDocuments().then((result) {
                setState(() {
                  _documents = result;
                });
              });
            } else {
              FlushbarMessage.show(
                context,
                null,
                AppTranslations.of(context).text("key_select_category"),
                MessageTypes.WARNING,
              );
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    bottom: 8.0,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_downloadCategories != null &&
                          _downloadCategories.length > 0) {
                        showDownloadCategories();
                      } else {
                        fetchDownloadCategories().then((result) {
                          setState(() {
                            _downloadCategories = result;
                          });
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_category"),
                                style:
                                    Theme.of(context).textTheme.bodyText2.copyWith(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                              ),
                            ),
                            Text(
                              _category,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _documents != null && _documents.length > 0
                    ? ListView.separated(
                        itemCount: _documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomDocumentItem(
                            leading: Image.asset(
                              getImageNameByFileType(
                                  _documents[index].file_type),
                              height: 30,
                            ),
                            onItemTap: () {
                              downloadFile(_documents[index].file_ext,
                                  _documents[index].doc_id);
                            },
                            itemText: StringHandlers.capitalizeWords(
                                _documents[index].caption),
                            itemIndex: index,
                            subItemText:  _documents[index].doc_link ?? "",
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
                              .text("key_select_category"),
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<DownloadCategory>> fetchDownloadCategories() async {
    List<DownloadCategory> categories = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /* String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              DownloadCategoryUrls.GET_DOWNLOAD_CATEGORIES,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          setState(() {
            List responseData = json.decode(response.body);
            categories = responseData
                .map(
                  (item) => DownloadCategory.fromMap(item),
                )
                .toList();

          });
          bool documentOverlay = AppData.current.preferences.getBool('document_overlay') ?? false;
          if(!documentOverlay){
            AppData.current.preferences.setBool("document_overlay", true);
            _showOverlay(context);
          }
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

    return categories;
  }

  Future<List<Document>> fetchDocuments() async {
    List<Document> documents = [];
    try {
      setState(() {
        _isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Student student = AppData.current.student;
        Map<String, dynamic> params = {
          "category_id": selectedCategory.category_id.toString(),
          StudentFieldNames.stud_no: student.stud_no.toString(),
          StudentFieldNames.yr_no: student.yr_no.toString(),
          StudentFieldNames.brcode: student.brcode,
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              DocumentUrls.GET_DOCUMENTS,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, AppTranslations.of(context).text("key_document_not_avaliable"), MessageTypes.WARNING);
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

  void showDownloadCategories() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: CustomCupertinoActionMessage(
          message:
              AppTranslations.of(context).text("key_select_download_category"),
        ),
        actions: List<Widget>.generate(
          _downloadCategories.length,
          (index) => CustomCupertinoActionSheetAction(
            actionIndex: index,
            actionText: StringHandlers.capitalizeWords(
                _downloadCategories[index].category_name),
            onActionPressed: () {
              setState(() {
                selectedCategory = _downloadCategories[index];
                _category = selectedCategory.category_name;
              });
              fetchDocuments().then((result) {
                setState(() {
                  _documents = result;
                });
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(String file_ext, int doc_id) async {
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Downloading . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          "doc_id": doc_id.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
        };

        Uri downloadUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                DocumentUrls.DOWNLOAD_DOCUMENT,
            params);

        http.Response data = await http.get(downloadUri);
        var bytes = data.bodyBytes;

        String mimeType = data.headers["content-type"];

        String fileName =
            DateFormat('yyyy-MM-dd–kk:mm').format(DateTime.now().toUtc()) +
                "." +
                file_ext;

        await Share.file(
          'Share via',
          fileName,
          bytes,
          mimeType,
        );
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

  String getImageNameByFileType(String fileType) {
    String imageName;

    switch (fileType) {
      case FileTypes.doc:
        imageName = "assets/images/docs.png";
        break;
      case FileTypes.ppt:
        imageName = "assets/images/slides.png";
        break;
      case FileTypes.pdf:
        imageName = "assets/images/pdf.png";
        break;
      case FileTypes.img:
        imageName = "assets/images/images.png";
        break;
      case FileTypes.txt:
        imageName = "assets/images/texts.png";
        break;
      case FileTypes.xls:
      imageName = "assets/images/sheets.png";
      break;
      case FileTypes.image:
        imageName = "assets/images/images.png";
        break;
      default :
        imageName = "assets/images/docs.png";
        break;
    }


    return imageName;
  }

  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      OverlayForSelectPage(AppTranslations.of(context).text("key_click_here_to_select_category")),
    );
  }
}
