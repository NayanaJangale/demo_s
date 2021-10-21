import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';

class CustomMessageCommentItem extends StatelessWidget {
  final String sender, comment, timestamp;

  CustomMessageCommentItem({this.sender, this.comment, this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                StringHandlers.capitalizeWords(sender),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              timestamp,
              style: Theme.of(context).textTheme.caption.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.grey,
            ),
          ],
        ),
        Text(
          comment,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.0,
          ),
        ),
        SizedBox(height: 5.0,),
      ],
    );
  }
}
