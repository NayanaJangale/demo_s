import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/models/circular.dart';
import 'package:student/models/period.dart';
import 'package:linkwell/linkwell.dart';
import 'package:student/pages/circular_documents_page.dart';

class CustomCircularItem extends StatefulWidget {
  final String networkPath;
  final List<Period> periods;
  final Function onItemTap;
  final Circular circular;

  CustomCircularItem(
      {
        this.networkPath,
        this.periods,
        this.onItemTap,
        this.circular});

  @override
  _CustomCircularItemState createState() => _CustomCircularItemState();
}

class _CustomCircularItemState extends State<CustomCircularItem> {
  String circularDate;
  List<Circular> _circulars = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _circulars.add(widget.circular);

    circularDate =
        DateFormat('dd MMM hh:mm aaa').format(widget.circular.circular_date);
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
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Text(
              StringHandlers.capitalizeWords(widget.circular.circular_title),
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              circularDate,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
         /* Visibility(
              visible: widget.networkPath != null && widget.networkPath != '',
            child:  GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImagePage(
                      dynamicObjects:  _circulars,
                      imageType: 'Circular',
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
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: LinkWell(
              widget.circular.circular_desc,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,right: 8),
                    child: Text(
                      widget.circular.emp_name ?? "",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  Visibility(
                    visible: widget.circular.docstatus,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CircularDocumentsPage(
                            circular_no: widget.circular.circular_no,
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
                ],)
          ),
        ],
      ),
    );
  }
}
