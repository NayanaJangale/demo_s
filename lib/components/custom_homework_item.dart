import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/homework.dart';
import 'package:student/models/period.dart';
import 'package:linkwell/linkwell.dart';
import 'package:student/pages/homework_documents_page.dart';

class CustomHomeworkItem extends StatefulWidget {
  final String description;
  final String homeworkDate;
  final String submissionDate;
  final String networkPath;
  final List<Period> periods;
  final Function onItemTap;
  final bool checkvisible;
  final Homework homework;

  CustomHomeworkItem(
      {this.description,
      this.homeworkDate,
      this.submissionDate,
      this.networkPath,
      this.periods,
      this.onItemTap,
      this.checkvisible,
      this.homework});

  @override
  _CustomHomeworkItemState createState() => _CustomHomeworkItemState();
}

class _CustomHomeworkItemState extends State<CustomHomeworkItem> {
  List<Homework> _homeworks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _homeworks.add(widget.homework);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(3.0),
          bottomRight: Radius.circular(3.0),
          bottomLeft: Radius.circular(3.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
         /* Visibility(
            visible: widget.networkPath != null && widget.networkPath != '',
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImagePage(
                      dynamicObjects: _homeworks,
                      imageType: 'HomeWork',
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
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                errorWidget: (context, url, error) => Container(),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Wrap(
              spacing: 5.0, // gap between adjacent chips,
              runSpacing: 0.0,
              children: List<Widget>.generate(
                widget.periods.length,
                (i) => Chip(
                  backgroundColor: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(18),
                      bottomRight: Radius.circular(18),
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
                    widget.periods[i].class_name +
                        ' ' +
                        widget.periods[i].division_name +
                        (widget.periods[i].subject_name != ''
                            ? ' - ' + widget.periods[i].subject_name
                            : ''),
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppTranslations.of(context).text("key_date") +
                        ': ' +
                        widget.homeworkDate,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  Text(
                    AppTranslations.of(context).text("key_submission_date") +
                        ': ' +
                        widget.submissionDate,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: LinkWell(
              widget.description,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 8.0,
              ),
              child: Row(
                children: <Widget>[
                  Visibility(
                    child: GestureDetector(
                      onTap: widget.onItemTap,
                      child: Text(
                        AppTranslations.of(context).text("key_submit_view"),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    visible: widget.checkvisible,
                  ),
                  Spacer(),
                  Visibility(
                    visible: widget.homework.docstatus,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeworkDocumentsPage(
                            hw_no: widget.homework.hw_no,
                          )),
                        );
                      },
                      child: Text(
                        'View Document',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontSize: 14
                        ),
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}
