import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student/components/custom_select_item.dart';
class MultiSelectDialog extends StatefulWidget {
  String message;
  List<dynamic> data;
  Function onOkayPressed;

  MultiSelectDialog({
    this.message,
    this.data,
    this.onOkayPressed,
  });

  @override
  _MultiSelectDialogState createState() => new _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<dynamic> filteredData = [];

  @override
  Widget build(BuildContext context) {
    filteredData =
        widget.data.where((item) => item.isSelected == true).toList();

    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.message,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List<Widget>.generate(
                  filteredData.length,
                      (i) => new Chip(
                    /*avatar: Container(),*/
                    label: new Text(filteredData[i].toString()),
                  ),
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return CustomSelectItem(
                  isSelected: widget.data[index].isSelected,
                  onItemTap: () {
                    setState(() {
                      if(widget.data[index].TopicName =='All'){
                        bool isSelected = !widget.data[index].isSelected;
                        for(int i=0;i<widget.data.length;i++){
                          widget.data[i].isSelected = isSelected;
                        }
                      }else{
                        widget.data[index].isSelected =
                        !widget.data[index].isSelected;
                      }
                    });
                  },
                  itemTitle: widget.data[index].toString(),
                  itemIndex: index,
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    top: 0.0,
                    bottom: 0.0,
                  ),
                  child: Divider(
                    height: 0.0,
                  ),
                );
              },
              itemCount: widget.data.length,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'OK',
            style:
            Theme.of(context).textTheme.button.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            widget.onOkayPressed();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
