import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';

class CustomLibraryItem extends StatelessWidget {
  final String title;
  final String author;
  final String publication;

  final int itemIndex;
  final int no_of_copies, available;
  final Function onItemTap;

  CustomLibraryItem({
    this.title,
    this.author,
    this.publication,
    this.no_of_copies,
    this.available,
    this.itemIndex,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onItemTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                StringHandlers.capitalizeWords(this.title),
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 10.0),
              Table(
                columnWidths: {
                  0: FractionColumnWidth(.4),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    children: [
                      Container(),
                      Container(),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          StringHandlers.capitalizeWords(
                            AppTranslations.of(context).text("key_author"),
                          ),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          StringHandlers.capitalizeWords(this.author),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          StringHandlers.capitalizeWords(
                            AppTranslations.of(context).text("key_publication"),
                          ),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          StringHandlers.capitalizeWords(this.publication),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          AppTranslations.of(context).text("key_no_of_copies"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          this.no_of_copies.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey[700],
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
                          top: 10.0,
                          bottom: 5.0,
                        ),
                        child: Text(
                          AppTranslations.of(context)
                              .text("key_books_available"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 5.0,
                        ),
                        child: Text(
                          this.available.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color: Colors.grey[700],
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
      ),
    );
  }
}
