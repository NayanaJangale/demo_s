import 'package:flutter/material.dart';

class CustomSelectItem extends StatelessWidget {
  String itemTitle;
  int itemIndex;
  Function onItemTap;
  bool isSelected = false;

  CustomSelectItem({
    this.itemTitle,
    this.itemIndex,
    this.onItemTap,
    this.isSelected,
  });

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
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 10.0,
                top: 3.0,
                bottom: 3.0,
              ),
              child: Icon(
                Icons.check_box,
                color: this.isSelected
                    ? Theme.of(context).accentColor
                    : Theme.of(context).secondaryHeaderColor,
              ),
            ),
            Expanded(
              child: Text(
                itemTitle,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 3.0,
                bottom: 3.0,
              ),
              child: Icon(
                Icons.navigate_next,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
