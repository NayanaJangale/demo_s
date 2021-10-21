import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/homework.dart';
import 'package:student/models/mcq_question.dart';
import 'package:student/models/period.dart';
import 'package:student/pages/full_screen_image_page.dart';

class CustomQuestionGroup extends StatefulWidget {
  final String instruction;
  final String groupTitle;
  final String groupDescription;
  final String networkPath;
  final Function onItemTap;
  final MCQQuestion question;



  CustomQuestionGroup(
      {this.instruction,
      this.groupTitle,
      this.groupDescription,
      this.networkPath,
      this.onItemTap,
      this.question});

  @override
  _CustomQuestionGroupState createState() => _CustomQuestionGroupState();
}

class _CustomQuestionGroupState extends State<CustomQuestionGroup> {
  List<MCQQuestion> _questionsGroup = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _questionsGroup.add(widget.question);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(right: 8,top: 8,left: 8),
            child: Text(
              // widget.instruction!= null? widget.instruction:"",
              "Instruction",
             // textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            bottom: 10.0,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.instruction,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,

              ),
            ),
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
                          dynamicObjects:  _questionsGroup,
                          imageType: 'MCQExamQusetion',
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
                Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        "Question Group :",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8,top: 8,bottom: 8),
                    child: Container(
                      child: Text(
                        widget.groupTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 10.0,
                ),
                child: Text(
                  widget.groupDescription,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,

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
