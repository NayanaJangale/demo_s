import 'package:flutter/material.dart';

class CustomFeedbackItem extends StatelessWidget {
  String query, option;

  CustomFeedbackItem({
    this.query,
    this.option,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 12,
          right: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.question_answer,
                  color: Colors.black38,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    query,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.question_answer,
                  color: Colors.transparent,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Feedback: ",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  option,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
