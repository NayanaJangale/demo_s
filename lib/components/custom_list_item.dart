import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  final String itemText;
  final int itemIndex;
  final Function onItemTap;

  const CustomListItem({this.itemText, this.itemIndex, this.onItemTap,});

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
                left: 10.0,
                right: 15.0,
                top: 3.0,
                bottom: 3.0,
              ),
              child: Container(
                child: Text(''),
                width: 3.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment
                        .bottomRight, // 10% of the width, so there are ten blinds.
                    colors: [
                      Theme.of(context).secondaryHeaderColor,
                      Theme.of(context).primaryColorLight,
                      Theme.of(context).accentColor,
                    ], // whitish to gray
                    tileMode: TileMode
                        .repeated, // repeats the gradient over the canvas
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                itemText,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black87,
                    ),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
