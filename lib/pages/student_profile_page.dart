import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:student/app_data.dart';
import 'package:student/components/custom_app_bar.dart';
import 'package:student/components/custom_progress_handler.dart';
import 'package:student/components/custom_text.dart';
import 'package:student/components/custom_text_field.dart';
import 'package:student/components/flushbar_message.dart';
import 'package:student/constants/http_request_methods.dart';
import 'package:student/constants/http_status_codes.dart';
import 'package:student/constants/message_types.dart';
import 'package:student/constants/project_settings.dart';
import 'package:student/handlers/network_handler.dart';
import 'package:student/handlers/string_handlers.dart';
import 'package:student/localization/app_translations.dart';
import 'package:student/models/configuration.dart';
import 'package:student/models/student.dart';
import 'package:student/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


List<Configuration> _configurations = [];

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePage createState() => _StudentProfilePage();
}

class _StudentProfilePage extends State<StudentProfilePage>
    with SingleTickerProviderStateMixin {
  bool _isLoading,
      _addressenable = false,
      _cityenable = false,
      _mobilenoenable = false,
      _emailidenable = false,
      _districtenable = false,
      _isUpdate = false,
      textEmailautofocus = false,
      isprofileVisibility = false,
      _mobileno1enable = false,
      _talukaenable = false;
  String _loadingText, buttonLable = 'EDIT';
  TextEditingController _nameController;
  TextEditingController _emailIDController;
  TextEditingController _aadharNoController;
  TextEditingController _mobileNoController;
  TextEditingController _mobileNo1Controller;
  TextEditingController _bdateController;
  TextEditingController _studNoController;
  TextEditingController _genderController;
  TextEditingController _classController;
  TextEditingController _divisionController;
  TextEditingController _bloodGroupController;
  TextEditingController _addressController;
  TextEditingController _cityController;
  TextEditingController _districtController;
  TextEditingController _motherNameController;
  TextEditingController _fatherNameController;
  TextEditingController _talukaController;
  TextEditingController _regNoController;
  TextEditingController _bankcodeController;

  FocusNode _nameFocusNode;
  FocusNode _emailIDFocusNode;
  FocusNode _aadharNoFocusNode;
  FocusNode _mobileNoFocusNode;
  FocusNode _mobileNo1FocusNode;
  FocusNode _bdateFocusNode;
  FocusNode _studNoFocusNode;
  FocusNode _bloodGroupFocusNode;
  FocusNode _genderFocusNode;
  FocusNode _classFocusNode;
  FocusNode _divisionFocusNode;
  FocusNode _addressFocusNode;
  FocusNode _cityFocusNode;
  FocusNode _districtFocusNode;
  FocusNode _motherNameFocusNode;
  FocusNode _fatherNameFocusNode;
  FocusNode _talukaFocusNode;
  FocusNode _regNoFocusNode;
  FocusNode _bankcodeFocusNode;
  List<Student> _students = [];
  GlobalKey<ScaffoldState> _studentProfilePageGK;
  File imageFile;

  void initState() {
    // TODO: implement initState
    this._isLoading = false;
    this._loadingText = 'Loading . . .';
    super.initState();
    _studentProfilePageGK = GlobalKey<ScaffoldState>();
    _nameController = TextEditingController();
    _emailIDController = TextEditingController();
    _aadharNoController = TextEditingController();
    _mobileNoController = TextEditingController();
    _mobileNo1Controller = TextEditingController();
    _bdateController = TextEditingController();
    _studNoController = TextEditingController();
    _genderController = TextEditingController();
    _classController = TextEditingController();
    _divisionController = TextEditingController();
    _bloodGroupController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _districtController = TextEditingController();
    _motherNameController = TextEditingController();
    _fatherNameController = TextEditingController();
    _regNoController = TextEditingController();
    _bankcodeController = TextEditingController();
    _talukaController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailIDFocusNode = FocusNode();
    _aadharNoFocusNode = FocusNode();
    _mobileNoFocusNode = FocusNode();
    _mobileNo1FocusNode = FocusNode();
    _bdateFocusNode = FocusNode();
    _studNoFocusNode = FocusNode();
    _bloodGroupFocusNode = FocusNode();
    _genderFocusNode = FocusNode();
    _classFocusNode = FocusNode();
    _divisionFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _districtFocusNode = FocusNode();
    _motherNameFocusNode = FocusNode();
    _fatherNameFocusNode = FocusNode();
    _talukaFocusNode = FocusNode();

    fetchStudentInfo().then((result) {
      setState(() {
        _students = result;
        if (_students != null && _students.length > 0) {
          _nameController.text = _students[0].stud_fullname;
          _emailIDController.text = _students[0].email_id;
          _aadharNoController.text = _students[0].aadhar_no;
          _mobileNoController.text = _students[0].mobile_no;
          _mobileNo1Controller.text = _students[0].mobile_no_1;
          _bdateController.text =
              DateFormat('yyyy-MM-dd').format(_students[0].birth_date);
          _studNoController.text = _students[0].stud_no.toString();
          _genderController.text = _students[0].gender;
          _classController.text = _students[0].class_name;
          _divisionController.text = _students[0].division_name;
          _bloodGroupController.text = _students[0].bgroup;
          _addressController.text = _students[0].stud_address;
          _cityController.text = _students[0].city;
          _districtController.text = _students[0].dist;
          _motherNameController.text = _students[0].mother_name;
          _fatherNameController.text = _students[0].student_mname;
          _talukaController.text = _students[0].taluka;
          _bankcodeController.text = _students[0].bankCode;
          _regNoController.text = _students[0].reg_no;
        }
      });
    });
    fetchConfiguration(ConfigurationGroups.Profile).then((result) {
      setState(() {
        _configurations = result;
        Configuration conf = _configurations
            .firstWhere((item) => item.confName == ConfigurationNames.Updation);
        _isUpdate = conf != null && conf.confValue == "Y" ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomProgressHandler(
      isLoading: this._isLoading,
      loadingText: this._loadingText,
      child: Scaffold(
          key: _studentProfilePageGK,
          appBar: AppBar(
            title: CustomAppBar(
              title: AppTranslations.of(context).text("key_hi") +
                  ' ' +
                  StringHandlers.capitalizeWords(
                      AppData.current.student.student_name),
              subtitle: AppTranslations.of(context)
                      .text("key_subtitle_student_profile") ??
                  "",
            ),
            actions: <Widget>[
              Visibility(
                visible: _isUpdate,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    setState(() {
                      if (buttonLable == 'EDIT') {
                        _addressenable = true;
                        _cityenable = true;
                        _districtenable = true;
                        _mobilenoenable = true;
                        _mobileno1enable = true;
                        _emailidenable = true;
                        textEmailautofocus = true;
                        isprofileVisibility = true;
                        _talukaenable = true;
                        buttonLable = 'SAVE';
                        FocusScope.of(context)
                            .requestFocus(
                            _emailIDFocusNode);
                      } else {
                        String valMsg = getValidationMessage();
                        if (valMsg != '') {
                          FlushbarMessage.show(
                            context,
                            null,
                            valMsg,
                            MessageTypes.ERROR,
                          );
                        } else {
                          UpdateStudentProfile();
                        }
                      }
                    });
                  },
                  child: Text(
                    buttonLable,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
            elevation: 0.0,
          ),
          body: _students != null && _students.length > 0
              ? Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 200.0,
                            width: 200.0,
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    imageFile != null
                                        ? Card(
                                            elevation: 3.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 140.0,
                                                  height: 140.0,
                                                  child: Image.file(imageFile,
                                                      fit: BoxFit.fill),
                                                )))
                                        : FutureBuilder<String>(
                                            future: getImageUrl(),
                                            builder: (context,
                                                AsyncSnapshot<String>
                                                    snapshot) {
                                              return Card(
                                                elevation: 3.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  child: CachedNetworkImage(
                                                    imageUrl: snapshot.data
                                                        .toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                                width: 140.0,
                                                                height: 140.0,
                                                                child: Image
                                                                    .network(
                                                                  snapshot.data
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ))),
                                                    placeholder:
                                                        (context, url) =>
                                                            Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 50.0,
                                                              right: 60.0,
                                                              top: 60.0,
                                                              bottom: 60.0),
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor: Theme
                                                                .of(context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        _students[0].gender ==
                                                                "M"
                                                            ? Container(
                                                                width: 140.0,
                                                                height: 140.0,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      new DecorationImage(
                                                                    image: new ExactAssetImage(
                                                                        'assets/images/profile_b.png'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ))
                                                            : Container(
                                                                width: 140.0,
                                                                height: 140.0,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      new DecorationImage(
                                                                    image: new ExactAssetImage(
                                                                        'assets/images/profile_g.png'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )),
                                                  ),
                                                ),
                                              );
                                            }),
                                  ],
                                )),
                          ),
                          Visibility(
                            visible: isprofileVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 60, top: 5),
                              child: GestureDetector(
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    AppTranslations.of(context)
                                        .text("key_change_photo"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 0.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                AppTranslations.of(context).text(
                                                    "key_student_information"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 10.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_name"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText:
                                                _students[0].stud_fullname,
                                            controller: _nameController,
                                            hintMaxLines: 1,
                                            focusNode: _nameFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._nameFocusNode.unfocus();

                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  _emailIDFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_email_id"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Flexible(
                                            child: new TextFormField(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                              focusNode: _emailIDFocusNode,
                                              keyboardType: TextInputType.text,
                                              controller: _emailIDController,
                                              onFieldSubmitted: (value) {
                                                this
                                                    ._emailIDFocusNode
                                                    .unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(this
                                                        ._aadharNoFocusNode);
                                              },
                                              decoration: InputDecoration(
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                hintMaxLines: 1,
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_aadhar_no"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText: _students[0].aadhar_no,
                                            keyboardType: TextInputType.number,
                                            controller: _aadharNoController,
                                            focusNode: _aadharNoFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._aadharNoFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._mobileNoFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_mobile_no1"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_mobile_no2"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            textEnable: _mobilenoenable,
                                            labelText: _students[0].mobile_no,
                                            controller: _mobileNoController,
                                            focusNode: _mobileNoFocusNode,
                                            keyboardType: TextInputType.number,
                                            onFieldSubmitted: (value) {
                                              this._mobileNoFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._mobileNo1FocusNode);
                                            },
                                          ),
                                          new CustomTextField(
                                            textEnable: _mobileno1enable,
                                            labelText: _students[0].mobile_no_1,
                                            controller: _mobileNo1Controller,
                                            focusNode: _mobileNo1FocusNode,
                                            keyboardType: TextInputType.number,
                                            onFieldSubmitted: (value) {
                                              this
                                                  ._mobileNo1FocusNode
                                                  .unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._bdateFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_date_of_birth"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_stud_no"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText: DateFormat('yyyy-MM-dd')
                                                .format(
                                                    _students[0].birth_date),
                                            controller: _bdateController,
                                            focusNode: _bdateFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._bdateFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._studNoFocusNode);
                                            },
                                          ),
                                          new CustomTextField(
                                            labelText:
                                                _students[0].stud_no.toString(),
                                            controller: _studNoController,
                                            focusNode: _studNoFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._studNoFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(this
                                                      ._bloodGroupFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_blood_group"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_gender"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText:
                                                _students[0].bgroup.toString(),
                                            controller: _bloodGroupController,
                                            focusNode: _bloodGroupFocusNode,
                                            onFieldSubmitted: (value) {
                                              this
                                                  ._bloodGroupFocusNode
                                                  .unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._genderFocusNode);
                                            },
                                          ),
                                          new CustomTextField(
                                            labelText:
                                                _students[0].gender == "M"
                                                    ? "Male"
                                                    : "Female",
                                            controller: _genderController,
                                            focusNode: _genderFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._genderFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._classFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_class"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_division"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText: _students[0].class_name,
                                            controller: _classController,
                                            focusNode: _classFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._classFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._divisionFocusNode);
                                            },
                                          ),
                                          new CustomTextField(
                                            labelText:
                                                _students[0].division_name,
                                            controller: _divisionController,
                                            focusNode: _divisionFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._divisionFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._cityFocusNode);
                                            },
                                          ),
                                        ],
                                      )),

                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_bank_code"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_reg_no"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            labelText: _students[0].bankCode,
                                            controller: _bankcodeController,
                                            focusNode: _bankcodeFocusNode,
                                            onFieldSubmitted: (value) {
                                            },
                                          ),
                                          new CustomTextField(
                                            labelText: _students[0].reg_no,
                                            controller: _regNoController,
                                            focusNode: _regNoFocusNode,
                                            onFieldSubmitted: (value) {

                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_city"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                AppTranslations.of(context)
                                                    .text("key_taluka"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new CustomTextField(
                                            textEnable: _cityenable,
                                            labelText: _students[0].city,
                                            controller: _cityController,
                                            focusNode: _cityFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._cityFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._talukaFocusNode);
                                            },
                                          ),
                                          new CustomTextField(
                                            textEnable: _talukaenable,
                                            labelText: _students[0].taluka,
                                            controller: _talukaController,
                                            focusNode: _talukaFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._talukaFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._districtFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_district"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          CustomTextField(
                                            textEnable: _districtenable,
                                            labelText: _students[0].dist,
                                            controller: _districtController,
                                            focusNode: _districtFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._districtFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      this._addressFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                AppTranslations.of(context)
                                                    .text("key_address"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomTextField(
                                            hintMaxLines: 3,
                                            textEnable: _addressenable,
                                            labelText:
                                                _students[0].stud_address,
                                            controller: _addressController,
                                            focusNode: _addressFocusNode,
                                            onFieldSubmitted: (value) {
                                              this._addressFocusNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(this
                                                      ._fatherNameFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 20.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                AppTranslations.of(context).text(
                                                    "key_parents_information"),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[],
                                          )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 10.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_father_name"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomTextField(
                                            hintMaxLines: 3,
                                            labelText:
                                                _students[0].student_mname,
                                            controller: _fatherNameController,
                                            focusNode: _fatherNameFocusNode,
                                            onFieldSubmitted: (value) {
                                              this
                                                  ._fatherNameFocusNode
                                                  .unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(this
                                                      ._motherNameFocusNode);
                                            },
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 10.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomText(
                                            labelText:
                                                AppTranslations.of(context)
                                                    .text("key_mother_name"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new CustomTextField(
                                            hintMaxLines: 3,
                                            textautofocus: true,
                                            labelText: _students[0].mother_name,
                                            controller: _motherNameController,
                                            focusNode: _motherNameFocusNode,
                                            onFieldSubmitted: (value) {
                                              this
                                                  ._motherNameFocusNode
                                                  .unfocus();
                                            },
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Container()),
    );
  }

  Future<String> getImageUrl() =>
      NetworkHandler.getServerWorkingUrl().then((connectionServerMsg) {
        if (connectionServerMsg != "key_check_internet") {
          return Uri.parse(
            connectionServerMsg +
                ProjectSettings.rootUrl +
                StudentUrls.GET_STUDENT_IMAGE,
          ).replace(queryParameters: {
            StudentFieldNames.stud_no:
                AppData.current.student.stud_no.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            UserFieldNames.clientCode: AppData.current.user.clientCode,
          }).toString();
        }
      });

  Future _pickImage(ImageSource iSource) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: iSource,
      imageQuality: 100,
    );
    setState(() {
      this.imageFile = File(compressedImage.path);
    });
  }

  Future<List<Configuration>> fetchConfiguration(String confGroup) async {
    List<Configuration> configurations = [];
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          ConfigurationFieldNames.ConfigurationGroup: confGroup,
          "stud_no": AppData.current.student.stud_no.toString(),
          "yr_no": AppData.current.student.yr_no.toString(),
          "brcode": AppData.current.student.brcode.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              ConfigurationUrls.GET_CONFIGURATION_BY_GROUP,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
              context, null, response.body, MessageTypes.WARNING);
        } else {
          List responseData = json.decode(response.body);
          configurations = responseData
              .map(
                (item) => Configuration.fromJson(item),
              )
              .toList();
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      _isLoading = false;
    });

    return configurations;
  }

  Future<List<Student>> fetchStudentInfo() async {
    List<Student> wards;
    try {
      setState(() {
        _isLoading = true;
      });

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Map<String, dynamic> params = {
          StudentFieldNames.stud_no:  AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode.toString(),
        };

        Uri fetchSchoolsUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              StudentUrls.GET_STUDENT_PROFILE,
          params,
        );

        http.Response response = await http.get(fetchSchoolsUri);
        if (response.statusCode != HttpStatusCodes.OK) {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.WARNING,
          );
        } else {
          List responseData = json.decode(response.body);
          wards = responseData
              .map(
                (item) => Student.fromMapProfile(item),
              )
              .toList();
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.WARNING,
        );
      }
    } catch (e) {
      FlushbarMessage.show(
        context,
        null,
        AppTranslations.of(context).text("key_api_error"),
        MessageTypes.WARNING,
      );
    }

    setState(() {
      _isLoading = false;
    });

    return wards != null ? wards : [];
  }

  String getValidationMessage() {
    if (_mobileNoController.text == '' || _mobileNo1Controller.text == '') {
      return AppTranslations.of(context).text("key_select_mobile_no");
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (_emailIDController.text != null )
       if ( !(regex.hasMatch(_emailIDController.text))){
         return AppTranslations.of(context).text("key_invalid_email");
       }
    if (_mobileNoController.text.length != 10 && _mobileNo1Controller.text.length !=10 ) {
      return AppTranslations.of(context).text("key_enter_mobile_number");
    }
    return "";
  }
  Future<void> UpdateStudentProfile() async {
    try {
      setState(() {
        _isLoading = true;
        _loadingText = 'Processing . .';
      });
      //TODO: Call change password Api here

      String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
      if (connectionServerMsg != "key_check_internet") {
        Uri postChangePasswordUri = NetworkHandler.getUri(
          connectionServerMsg +
              ProjectSettings.rootUrl +
              StudentUrls.UPDATE_STUDENT_PROFILE,
          {
            StudentFieldNames.stud_no:  AppData.current.student.stud_no.toString(),
            StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
            StudentFieldNames.brcode: AppData.current.student.brcode,
            StudentFieldNames.mobile_no: _mobileNoController.text.toString(),
            StudentFieldNames.mobile_no_1: _mobileNo1Controller.text.toString(),
            StudentFieldNames.email_id: _emailIDController.text.toString(),
            StudentFieldNames.city: _cityController.text.toString(),
            StudentFieldNames.dist: _districtController.text.toString(),
            StudentFieldNames.stud_address: _addressController.text.toString(),
            StudentFieldNames.taluka: _talukaController.text.toString()
          },
        );
        http.Response response = await http.post(postChangePasswordUri);
        setState(() {
          _isLoading = false;
          _loadingText = '';
        });

        if (response.statusCode == HttpStatusCodes.CREATED) {
          //TODO: Call login
          if (imageFile != null) {
            await postStudentImage();

          }else{
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                message: Text(
                  response.body,
                  style: TextStyle(fontSize: 18),
                ),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                      child: Text(
                        AppTranslations.of(context).text("key_ok"),
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                        // It worked for me instead of above line
                        fetchStudentInfo().then((result) {
                          setState(() {
                            _students = result;
                            if (_students != null && _students.length > 0) {
                              _nameController.text = _students[0].stud_fullname;
                              _emailIDController.text = _students[0].email_id;
                              _aadharNoController.text = _students[0].aadhar_no;
                              _mobileNoController.text = _students[0].mobile_no;
                              _mobileNo1Controller.text = _students[0].mobile_no_1;
                              _bdateController.text =
                                  DateFormat('yyyy-MM-dd').format(_students[0].birth_date);
                              _studNoController.text = _students[0].stud_no.toString();
                              _genderController.text = _students[0].gender;
                              _classController.text = _students[0].class_name;
                              _divisionController.text = _students[0].division_name;
                              _bloodGroupController.text = _students[0].bgroup;
                              _addressController.text = _students[0].stud_address;
                              _cityController.text = _students[0].city;
                              _districtController.text = _students[0].dist;
                              _motherNameController.text = _students[0].mother_name;
                              _fatherNameController.text = _students[0].student_mname;
                              _talukaController.text = _students[0].taluka;
                             _addressenable = false;
                             _cityenable = false;
                             _mobilenoenable = false;
                             _emailidenable = false;
                             _districtenable = false;
                            // _isUpdate = false;
                             textEmailautofocus = false;
                             isprofileVisibility = false;
                             _mobileno1enable = false;
                             _talukaenable = false;
                              buttonLable = 'EDIT';
                              getImageUrl();
                            }
                          });
                        });
                      })
                ],
              ),
            );
          }
        } else {
          FlushbarMessage.show(
            context,
            null,
            response.body,
            MessageTypes.ERROR,
          );
        }
      } else {
        FlushbarMessage.show(
          context,
          AppTranslations.of(context).text("key_no_internet"),
          AppTranslations.of(context).text("key_check_internet"),
          MessageTypes.ERROR,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadingText = '';
      });
      print(e);
    }
  }
  Future<void> postStudentImage() async
  {
    String connectionServerMsg = await NetworkHandler.getServerWorkingUrl();
    if (connectionServerMsg != "key_check_internet") {
      Uri postUri = Uri.parse(
        connectionServerMsg +
            ProjectSettings.rootUrl +
            'Students/PostStudentImage',
      ).replace(
        queryParameters: {
          StudentFieldNames.stud_no: AppData.current.student.stud_no.toString(),
          StudentFieldNames.yr_no: AppData.current.student.yr_no.toString(),
          StudentFieldNames.brcode: AppData.current.student.brcode,
          "clientCode": AppData.current.student.client_code,
        },
      );

      final mimeTypeData =
      lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');

      final imageUploadRequest =
      http.MultipartRequest(HttpRequestMethods.POST, postUri);

      final file = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType(
          mimeTypeData[0],
          mimeTypeData[1],
        ),
      );

      imageUploadRequest.fields['ext'] = mimeTypeData[1];
      imageUploadRequest.files.add(file);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
       if (response.statusCode == HttpStatusCodes.CREATED) {
        FlushbarMessage.show(
          context,
          '',
          response.body.toString(),
          MessageTypes.INFORMATION,
        );
        fetchStudentInfo().then((result) {
          setState(() {
            _students = result;
            if (_students != null && _students.length > 0) {
              _nameController.text = _students[0].stud_fullname;
              _emailIDController.text = _students[0].email_id;
              _aadharNoController.text = _students[0].aadhar_no;
              _mobileNoController.text = _students[0].mobile_no;
              _mobileNo1Controller.text = _students[0].mobile_no_1;
              _bdateController.text =
                  DateFormat('yyyy-MM-dd').format(_students[0].birth_date);
              _studNoController.text = _students[0].stud_no.toString();
              _genderController.text = _students[0].gender;
              _classController.text = _students[0].class_name;
              _divisionController.text = _students[0].division_name;
              _bloodGroupController.text = _students[0].bgroup;
              _addressController.text = _students[0].stud_address;
              _cityController.text = _students[0].city;
              _districtController.text = _students[0].dist;
              _motherNameController.text = _students[0].mother_name;
              _fatherNameController.text = _students[0].student_mname;
              _talukaController.text = _students[0].taluka;
              _addressenable = false;
              _cityenable = false;
              _mobilenoenable = false;
              _emailidenable = false;
              _districtenable = false;
              _isUpdate = false;
               textEmailautofocus = false;
               isprofileVisibility = false;
              _mobileno1enable = false;
              _talukaenable = false;
               buttonLable = 'EDIT';
               getImageUrl();
            }
          });
        });
      } else {
        FlushbarMessage.show(
          context,
          null,
          AppTranslations.of(context).text("key_image_not_saved"),
          MessageTypes.ERROR,
        );
      }
    } else {
      FlushbarMessage.show(
        context,
        AppTranslations.of(context).text("key_no_internet"),
        AppTranslations.of(context).text("key_check_internet"),
        MessageTypes.WARNING,
      );
    }
  }
}
