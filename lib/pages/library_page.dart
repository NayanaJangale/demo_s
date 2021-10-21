import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_library_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/library_author.dart';
import 'package:student/models/library_book_details.dart';
import 'package:student/models/library_publication.dart';
import 'package:student/models/library_title.dart';
import 'package:student/models/student.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _isLoading;
  String _loadingText;

  GlobalKey<ScaffoldState> _libraryPageGK;
  TextEditingController _autoCompleteController;
  String autoCompleteFor = 'T';
  int currentSegment = 0;

  List<LibraryBookDetails> _books = new List<LibraryBookDetails>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._libraryPageGK = GlobalKey<ScaffoldState>();

    this._isLoading = false;
    this._loadingText = 'Loading . .';
    _autoCompleteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    this._loadingText = AppTranslations.of(context).text("key_loading");
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
        key: _libraryPageGK,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: CustomAppBar(
            title: AppTranslations.of(context).text("key_hi") +
                ' ' +
                StringHandlers.capitalizeWords(
                    AppData.current.student.student_name),
            subtitle: AppTranslations.of(context).text("key_your_books"),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    controller: _autoCompleteController,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 0.0,
                                        bottom: 0.0,
                                      ),
                                      hintText: autoCompleteFor == 'P'
                                          ? AppTranslations.of(context)
                                          .text("key_by_publication")
                                          : (autoCompleteFor == 'A'
                                          ? AppTranslations.of(context)
                                          .text("key_by_author")
                                          : AppTranslations.of(context)
                                          .text("key_by_title")),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) async {
                                    List<String> data = [];
                                    if (autoCompleteFor == 'P') {
                                      List<LibraryPublication> pubs =
                                      await fetchPublications(pattern);

                                      for (LibraryPublication pub in pubs) {
                                        data.add(pub.bPub);
                                      }
                                    } else if (autoCompleteFor == 'A') {
                                      List<LibraryAuthor> authors =
                                      await fetchAuthors(pattern);

                                      for (LibraryAuthor author in authors) {
                                        data.add(author.bAuthor);
                                      }
                                    } else {
                                      List<LibraryTitle> titles =
                                      await fetchTitles(pattern);

                                      for (LibraryTitle title in titles) {
                                        data.add(title.bTitle);
                                      }
                                    }

                                    return data;
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      leading: Icon(
                                        suggestion ==
                                            AppTranslations.of(context)
                                                .text("key_no_internet")
                                            ? Icons.signal_wifi_off
                                            : Icons.description,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        suggestion,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    _autoCompleteController.text = suggestion;
                                    fetchBooksDetails().then((result) {
                                      if (this.mounted) {
                                        setState(() {
                                          _books = result;
                                        });
                                      }
                                    });
                                  },
                                  noItemsFoundBuilder: (context) {
                                    return ListTile(
                                      leading: Icon(
                                        Icons.not_interested,
                                        color: Colors.grey,
                                      ),
                                      title: Text(
                                        AppTranslations.of(context)
                                            .text("key_no_record"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  this._autoCompleteController.text = '';
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: CupertinoSegmentedControl<int>(
                                children: <int, Widget>{
                                  0: Text(
                                    AppTranslations.of(context)
                                        .text("key_title"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: autoCompleteFor == 'T'
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  1: Text(
                                    AppTranslations.of(context)
                                        .text("key_author"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: autoCompleteFor == 'A'
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  2: Text(
                                    AppTranslations.of(context)
                                        .text("key_publication"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                      color: autoCompleteFor == 'P'
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                },
                                onValueChanged: (int newValue) {
                                  setState(() {
                                    currentSegment = newValue;
                                    newValue == 0
                                        ? autoCompleteFor = 'T'
                                        : newValue == 1
                                        ? autoCompleteFor = 'A'
                                        : autoCompleteFor = 'P';
                                  });
                                },
                                borderColor: Theme.of(context).primaryColor,
                                selectedColor: Theme.of(context).primaryColor,
                                pressedColor:
                                Theme.of(context).secondaryHeaderColor,
                                unselectedColor: Colors.white,
                                groupValue: currentSegment,
                                padding: EdgeInsets.only(
                                  left: 0.0,
                                  right: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              child: Text(
                                AppTranslations.of(context).text("key_title"),
                              ),
                              onPressed: () {
                                setState(() {
                                  autoCompleteFor = 'T';
                                });
                              },
                              color: autoCompleteFor == 'T'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                              textColor: autoCompleteFor == 'T'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            RaisedButton(
                              child: Text(
                                AppTranslations.of(context).text("key_author"),
                              ),
                              onPressed: () {
                                setState(() {
                                  autoCompleteFor = 'A';
                                });
                              },
                              color: autoCompleteFor == 'A'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                              textColor: autoCompleteFor == 'A'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            RaisedButton(
                              child: Text(
                                AppTranslations.of(context)
                                    .text("key_publication"),
                              ),
                              onPressed: () {
                                setState(() {
                                  autoCompleteFor = 'P';
                                });
                              },
                              color: autoCompleteFor == 'P'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColorLight,
                              textColor: autoCompleteFor == 'P'
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                          ],
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _books.isNotEmpty
                  ? ListView.builder(
                itemCount: _books.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 3.0,
                      right: 3.0,
                      top: 3.0,
                    ),
                    child: CustomLibraryItem(
                      title: _books[index].bTitle,
                      author: _books[index].bAuthor,
                      publication: _books[index].bPub,
                      no_of_copies: _books[index].no_of_copies,
                      available: _books[index].available,
                      itemIndex: index,
                    ),
                  );
                },
              )
                  : Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  AppTranslations.of(context).text("key_search_books"),
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
    );
  }

  Future<List<LibraryAuthor>> fetchAuthors(String pattern) async {
    List<LibraryAuthor> authors = [];

    try {
     /* setState(() {
        _isLoading = true;
      });*/


      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchCircularsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              LibraryUrls.GET_BOOK_AUTHOR,
          {
            'emp_no': '',
            "bAuthor": '%' + pattern + '%',
            StudentFieldNames.brcode: AppData.current.student.brcode,
          },
        );

        http.Response response = await http.get(fetchCircularsUri);
        if (response.statusCode == HttpStatusCodes.OK) {
          List responseData = json.decode(response.body);
          authors = responseData
              .map(
                (item) => LibraryAuthor.fromJson(item),
          )
              .toList();
        }
      } else {
        authors.add(
          LibraryAuthor(
            book_no: 0,
            bAuthor: AppTranslations.of(context).text("key_no_internet"),
          ),
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

    return authors;
  }

  Future<List<LibraryTitle>> fetchTitles(String pattern) async {
    List<LibraryTitle> titles = [];

    try {
     /* setState(() {
        _isLoading = true;
      });*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchCircularsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              LibraryUrls.GET_BOOK_TITLE,
          {
            'emp_no': '',
            "bTitle": '%' + pattern + '%',
            StudentFieldNames.brcode: AppData.current.student.brcode,
          },
        );

        http.Response response = await http.get(fetchCircularsUri);
        if (response.statusCode == HttpStatusCodes.OK) {
          List responseData = json.decode(response.body);
          titles = responseData
              .map(
                (item) => LibraryTitle.fromJson(item),
          )
              .toList();
        }
      } else {
        titles.add(
          LibraryTitle(
            book_no: 0,
            bTitle: AppTranslations.of(context).text("key_no_internet"),
          ),
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

    return titles;
  }

  Future<List<LibraryPublication>> fetchPublications(String pattern) async {
    List<LibraryPublication> publications = [];

    try {
     /* setState(() {
        _isLoading = true;
      });*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchCircularsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              LibraryUrls.GET_BOOK_PUBLICATION,
          {
            'emp_no': '',
            "bPub": '%' + pattern + '%',
            StudentFieldNames.brcode: AppData.current.student.brcode,
          },
        );

        http.Response response = await http.get(fetchCircularsUri);
        if (response.statusCode == HttpStatusCodes.OK) {
          List responseData = json.decode(response.body);
          publications = responseData
              .map(
                (item) => LibraryPublication.fromJson(item),
          )
              .toList();
        }
      } else {
        publications.add(LibraryPublication(
          book_no: 0,
          bPub: AppTranslations.of(context).text("key_no_internet"),
        ));
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

    return publications;
  }

  Future<List<LibraryBookDetails>> fetchBooksDetails() async {
    List<LibraryBookDetails> books = [];
    try {
    /*  setState(() {
        _isLoading = true;
      });*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchBookDetailsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              LibraryUrls.GET_BOOK_DETAILS,
          {
            'emp_no': '1',
            "bPub": autoCompleteFor == "P" ? _autoCompleteController.text : "%",
            "bTitle":
            autoCompleteFor == "T" ? _autoCompleteController.text : "%",
            "bAuthor":
            autoCompleteFor == "A" ? _autoCompleteController.text : "%",
            'user_no': AppData.current.user.userNo.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
          },
        );
        http.Response response = await http.get(fetchBookDetailsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          List responseData = json.decode(response.body);
          books = responseData
              .map(
                (item) => LibraryBookDetails.fromJson(item),
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
      _isLoading = false;
    });

    return books;
  }
}
