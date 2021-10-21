import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';

class CustomDocumentItem extends StatelessWidget {
  final String itemText;
  final int itemIndex;
  final Function onItemTap;
  final Image leading;
  final String subItemText;

  const CustomDocumentItem(
      {this.leading, this.itemText, this.itemIndex, this.onItemTap,this.subItemText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: this.onItemTap,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 15.0,
                top: 3.0,
                bottom: 3.0,
              ),
              child: leading,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemText,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible:  subItemText != null && subItemText!="",
                    child: LinkWell(
                      subItemText,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.blue,
                          fontSize: 14
                      ) ,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.file_download,
              color: Colors.grey[600],
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
