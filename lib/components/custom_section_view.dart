import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSectionView extends StatelessWidget {
  final String sectionTitle, instruction;
  final int examTime;
  final double examMarks;
  final Function onItemTap;
  bool isSolved;


   CustomSectionView(
      {this.sectionTitle, this.instruction, this.onItemTap,this.examTime,this.examMarks,this.isSolved});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onItemTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(3.0),
                bottomRight: Radius.circular(3.0),
                bottomLeft: Radius.circular(3.0),
              ),
            ),

            color: this.isSolved
                ? Theme.of(context).secondaryHeaderColor
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight])
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            sectionTitle,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      // widget.instruction!= null? widget.instruction:"",
                      "Instruction",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    // widget.instruction!= null? widget.instruction:"",
                    instruction,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                        ),
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[

                   Padding(
                       padding: const EdgeInsets.only(
                         top: 8.0,
                         right: 8.0,
                         bottom: 4.0,
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                           Text(
                             'Time : ${examTime} min',
                             textAlign: TextAlign.start,
                             style: Theme.of(context).textTheme.bodyText2.copyWith(
                               color: Colors.green,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       )),
                   Padding(
                       padding: const EdgeInsets.only(
                         top: 8.0,
                         left: 8.0,
                         right: 8.0,
                         bottom: 4.0,
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: <Widget>[
                           Text(
                             'Marks : ${examMarks}',
                             textAlign: TextAlign.end,
                             style: Theme.of(context).textTheme.bodyText2.copyWith(
                               color: Colors.green,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       )),
                 ],)
                ],
              ),
            )),
      ),
    );
  }
}
