import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student/localization/app_translations.dart';

class CustomMessageBar extends StatefulWidget {
  final TextEditingController messageFieldController;
  bool isLoading = false, isMediaOptionRequired;
  Function onSendButtonPressed, onMediaSelected;

  CustomMessageBar({
    this.messageFieldController,
    this.isMediaOptionRequired,
    this.onSendButtonPressed,
    this.onMediaSelected,
  });

  @override
  _CustomMessageBarState createState() => _CustomMessageBarState();
}

class _CustomMessageBarState extends State<CustomMessageBar> {
  File imageFile;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: Colors.grey[300],
          ),
          bottom: BorderSide.none,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              widget.isMediaOptionRequired
                  ? this.imageFile == null
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible
                              ? Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.grey[600],
                                )
                              : Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.grey[600],
                                ),
                        )
                      : GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey[400],
                              ),
                            ),
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: Image.file(
                              this.imageFile,
                              fit: BoxFit.cover,
                              width: 35,
                              height: 35,
                            ),
                          ),
                        )
                  : SizedBox(
                      width: 5.0,
                    ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey[300],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          top: 8.0,
                          bottom: 8.0
                      ),
                      child: TextFormField(
                        autofocus: true,
                        controller: widget.messageFieldController,
                        decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintText: AppTranslations.of(context)
                              .text("key_type_message"),
                          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black45,
                              ),
                        ),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.black87,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onSendButtonPressed,
                icon: Icon(
                  Icons.send,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Visibility(
            visible: _isVisible,
            child: Column(
              children: <Widget>[
                Container(
                  height: 1,
                  color: Colors.grey[300],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.camera);
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Camera',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                        },
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.photo,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future _pickImage(ImageSource iSource) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: iSource,
      imageQuality: 100,
    );
    setState(() {
      this.imageFile = File(compressedImage.path);
      _isVisible = false;
    });
    widget.onMediaSelected(this.imageFile);
  }
  /*Future _pickImage(ImageSource iSource) async {
    var imageFile =
        await ImagePicker.pickImage(source: iSource, imageQuality: 60);
    *//*imageFile = await compressAndGetFile(imageFile);*//*
    setState(() {
      this.imageFile = imageFile;
      _isVisible = false;
    });

    widget.onMediaSelected(this.imageFile);
  }*/
}
