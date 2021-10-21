import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_message_bar.dart';
import 'package:student/components/custom_message_comment_item.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/message.dart';
import 'package:student/models/message_comment.dart';
import 'package:student/models/recipient.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';

class MessageDetailsPage extends StatefulWidget {
  String networkPath, message, messageNo, timeStamp, messageTitle;
  List<Recipient> recipients = [];

  MessageDetailsPage({
    this.messageTitle,
    this.networkPath,
    this.message,
    this.messageNo,
    this.timeStamp,
    this.recipients,
  });

  @override
  _MessageDetailsPageState createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  GlobalKey<ScaffoldState> _messageDetailsPageGlobalKey;
  List<MessageComment> _comments = [];
  TextEditingController messageController;

  bool isLoading;
  String loadingText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _messageDetailsPageGlobalKey = GlobalKey<ScaffoldState>();
    this.isLoading = false;
    this.loadingText = 'Loading . . .';
    this.messageController = TextEditingController();

    fetchComments().then((result) {
      setState(() {
        _comments = result;
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
        key: _messageDetailsPageGlobalKey,
        appBar: AppBar(
          title: CustomAppBar(
            title: StringHandlers.capitalizeWords(widget.messageTitle),
            subtitle: widget.timeStamp,
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: RefreshIndicator(
          onRefresh: () async {
            fetchComments().then((result) {
              setState(() {
                this._comments = result;
              });
            });
          },
          child: SingleChildScrollView(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.networkPath,
                    imageBuilder: (context, imageProvider) => Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          widget.networkPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 4,
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Wrap(
                      spacing: 3.0, // gap between adjacent chips,
                      runSpacing: 0.0,
                      children: List<Widget>.generate(
                        widget.recipients.length,
                        (i) => Chip(
                          backgroundColor: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                              topLeft: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                            ),
                          ),
                          avatar: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 12,
                            height: 12,
                          ),
                          label: Text(
                            StringHandlers.capitalizeWords(
                                widget.recipients[i].recipientName),
                          ),
                          labelStyle:
                              Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Text(
                      widget.message,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  _comments.length > 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: Divider(
                            height: 0.0,
                          ),
                        )
                      : Container(),
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: new EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: 4.0,
                      top: 4.0,
                    ),
                    itemCount: _comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CustomMessageCommentItem(
                        sender: _comments[index].ReplyFrom,
                        comment: _comments[index].Comment,
                        timestamp: DateFormat('dd MMM hh:mm aaa')
                            .format(_comments[index].ReplySentOn),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4.0,
                          top: 4.0,
                        ),
                        child: Divider(
                          height: 0.0,
                        ),
                      );
                    },
                  ),
                  CustomMessageBar(
                    isMediaOptionRequired: false,
                    messageFieldController: this.messageController,
                    onSendButtonPressed: () {
                      if (this.messageController.text != '') {
                        MessageComment comment = MessageComment();
                        comment.MessageNo = int.parse(widget.messageNo);
                        comment.Comment = messageController.text;
                        comment.ReplyFrom = 'Student';
                        comment.FromEmpNo = 0;
                        comment.FromStudentNo = AppData.current.student.stud_no;
                        postComment(comment);
                      } else {
                        FlushbarMessage.show(
                          context,
                          null,
                          AppTranslations.of(context).text("key_enter_message"),
                          MessageTypes.ERROR,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<MessageComment>> fetchComments() async {
    List<MessageComment> comments = [];

    try {
      setState(() {
        isLoading = true;
      });

      /*String connectionStatus = await NetworkHandler.checkInternetConnection();
      if (connectionStatus == InternetConnection.CONNECTED) {*/

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri fetchCircularsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              MessageUrls.GET_MESSAGE_COMMENTS,
          {
            'MessageNo': widget.messageNo,
            StudentFieldNames.brcode: AppData.current.student.brcode,
          },
        );

        http.Response response = await http.get(fetchCircularsUri);
        if (response.statusCode == HttpStatusCodes.OK) {
          List responseData = json.decode(response.body);
          comments = responseData
              .map(
                (item) => MessageComment.fromJson(item),
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

    return comments;
  }

  Future<void> postComment(MessageComment comment) async {
    try {
      setState(() {
        isLoading = true;
        loadingText = 'Saving . . .';
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        User user = AppData.current.user;
        Student student = AppData.current.student;

        Map<String, dynamic> params = {
          "user_id": user != null ? user.loginID : "",
          'user_no': user != null ? user.userNo.toString() : '',
          StudentFieldNames.brcode: student != null ? student.brcode : '',
        };

        Uri saveMessageCommentsUri = NetworkHandler.getUri(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                MessageUrls.POST_MESSAGE_COMMENTS,
            params);

        http.Response response = await http.post(
          saveMessageCommentsUri,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: json.encode(comment),
          encoding: Encoding.getByName("utf-8"),
        );

        if (response.statusCode == HttpStatusCodes.CREATED) {
          FlushbarMessage.show(
            context,
            null,
            AppTranslations.of(context).text("key_message_sent"),
            MessageTypes.WARNING,
          );

          _clearData();
          fetchComments().then((result) {
            setState(() {
              _comments = result;
            });
          });
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearData() {
    this.messageController.text = '';
  }
}
