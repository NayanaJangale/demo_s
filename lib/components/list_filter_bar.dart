import 'package:flutter/material.dart';
import 'package:student/localization/app_translations.dart';

class ListFilterBar extends StatelessWidget {
  final Function onCloseButtonTap;
  final TextEditingController searchFieldController;

  ListFilterBar({
    this.onCloseButtonTap,
    this.searchFieldController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          bottom: 10.0,
          right: 10.0,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: TextFormField(
                  autofocus: true,
                  controller: searchFieldController,
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText:AppTranslations.of(context).text("key_search"),
                    hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onCloseButtonTap,
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
