import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/mcq_exam.dart';
import 'package:student/pages/full_screen_image_page.dart';


class CustomExamcard extends StatefulWidget {
  final String title;
  final Function onPressed;
  final String fromDate;
  final String toDate;
  final double totalMark;
  final int totaltime;
  final String networkPath;
  final MCQExam exam;

  CustomExamcard({
    this.title,
    this.onPressed,
    this.fromDate,
    this.toDate,
    this.totalMark,
    this.totaltime,
    this.networkPath,
    this.exam
  });

  @override
  _CustomExamcardState createState() => _CustomExamcardState();
}


class _CustomExamcardState extends State<CustomExamcard> {
  List<MCQExam> _exams = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _exams.add(widget.exam);

  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap:widget.onPressed ,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0),
            ),
          ),
          child: Column(
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
                          dynamicObjects:  _exams,
                          imageType: 'MCQExam',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color:Theme.of(context).primaryColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Table(
                      columnWidths: {
                        0: FractionColumnWidth(.3),
                      },
                      children: [
                        TableRow(
                          children: [
                            Container(),
                            Container(),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Text(
                                "Validity ",
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color:Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,

                              ),
                              child: Text(
                               StringHandlers.capitalizeWords(
                                  "${this.widget.fromDate}-${this.widget.toDate}"),
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Text(
                                "Total Marks ",
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color:Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Text(
                                widget.totalMark.toString(),
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,
                              ),
                              child: Text(
                                "Total Time",
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color:Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 0.0,

                              ),
                              child: Text(
                                "${widget.totaltime}  min",
                                /*StringHandlers.capitalizeWords(
                                  "${this.start_date}-${this.end_date}"),*/
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


