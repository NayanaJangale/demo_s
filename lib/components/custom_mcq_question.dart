import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/models/mcq_question.dart';
import 'package:student/pages/full_screen_image_page.dart';

class CustomMcqQuestion extends StatefulWidget {
  final String questionDescription;
  final String networkPath;
  final Function onItemTap;
  final MCQQuestion question;



  CustomMcqQuestion(
      {
      this.questionDescription,
      this.networkPath,
      this.onItemTap,
      this.question});

  @override
  _CustomMCQQuestionState createState() => _CustomMCQQuestionState();
}

class _CustomMCQQuestionState extends State<CustomMcqQuestion> {
  List<MCQQuestion> _questions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questions.add(widget.question);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.question_answer,
                color: Theme.of(context).accentColor,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  widget.questionDescription ??
                      widget.questionDescription,
                  style:
                  Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                visible: widget.networkPath != null && widget.networkPath != '',
                child:  GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImagePage(
                          dynamicObjects:  _questions,
                          imageType: 'MCQuestion',
                          photoIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.networkPath,
                    imageBuilder: (context, imageProvider) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          widget.networkPath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 4.0,
                      ),
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }
}
