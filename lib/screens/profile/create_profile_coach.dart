import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:myscout/models/profile_model.dart';
import 'package:myscout/screens/home/home_screen.dart';
import 'package:myscout/utils/Config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
class CreateProfileCoach extends StatefulWidget {
  CreateProfileCoach({this.userId});
  final String userId;
  @override
  _CreateProfileCoachState createState() => _CreateProfileCoachState();
}
const String MIN_DATETIME = '1900-01-01';
const String MAX_DATETIME = '2030-11-25';
const String INIT_DATETIME = '2019-05-17';

class _CreateProfileCoachState extends State<CreateProfileCoach> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  final fullNamesController = TextEditingController();
  final dobController = TextEditingController();
  final locationController = TextEditingController();
  final shortBioController = TextEditingController();
  final schoolController = TextEditingController();
  final positionController = TextEditingController();
  final sportsController = TextEditingController();

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  String _format = 'dd-MMMM-yyyy';
  String _timeFormat = 'HH:m';
  DateTime _dateTime;
  bool _showTitle = true;
  loadProfileDetails(){

    Firestore.instance
        .collection(Config.users)
        .document(widget.userId)
        .get()
        .then((DocumentSnapshot snapshot) {
         setState(() {
           profilePic = snapshot[Config.profilePicUrl];
           fullNamesController.text = snapshot[Config.fullNames];
           dobController.text = snapshot[Config.dob];
           locationController.text = snapshot[Config.location];
           shortBioController.text = snapshot[Config.shortBio];
           schoolController.text = snapshot[Config.schoolOrOrg];
           positionController.text = snapshot[Config.position];
           pModel.sports = snapshot[Config.selectSport];

         });


    });

  }

  saveProfileDetailsWithoutImage(){
    setState(() {
      loading  = true;
    });
    Map userInfo = new Map<String, dynamic>();
    userInfo[Config.fullNames]= fullNamesController.text;
    userInfo[Config.dob]= dobController.text;
    userInfo[Config.location]= locationController.text;
    userInfo[Config.shortBio]= shortBioController.text;
    userInfo[Config.schoolOrOrg]= schoolController.text;
    userInfo[Config.position]= positionController.text;
    userInfo[Config.selectSport]= pModel.sports ?? "BasketBall";

    _saveSports(pModel.sports ?? "BasketBall");
    Firestore.instance
        .collection(Config.users)
        .document(widget.userId)
        .updateData(userInfo)
        .then((_) {
      setState(() {
        loading = false;
      });

      print("completed");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()),
      );

    });

  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text('DONE', style: TextStyle(color: Theme.of(context).primaryColor,fontFamily: 'GothamRnd',fontWeight: FontWeight.bold)),
        cancel: Text('CANCEL', style: TextStyle(color: Theme.of(context).accentColor,fontFamily: 'GothamRnd',fontWeight: FontWeight.w600)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          dobController.text = _dateTime.day.toString()+"/"+_dateTime.month.toString()+"/"+_dateTime.year.toString();

        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          dobController.text = _dateTime.day.toString()+"/"+_dateTime.month.toString()+"/"+_dateTime.year.toString();

        });
      },
    );
  }


  _saveUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saved userId to preferences");
    prefs.setString(Config.userId, uid);
    print("user id is saved"+uid);
  }

  _saveSports(String sport) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saved sport to preferences"+sport);
    prefs.setString(Config.sport, sport);
  }
  saveProfileDetailsWithImage(){

    final FirebaseStorage storage = FirebaseStorage.instance;
    uploadImage(file, storage).then((String data) {


      Map userInfo = new Map<String, dynamic>();
      userInfo[Config.fullNames]= fullNamesController.text;
      userInfo[Config.dob]= dobController.text;
      userInfo[Config.location]= locationController.text;
      userInfo[Config.shortBio]= shortBioController.text;
      userInfo[Config.schoolOrOrg]= schoolController.text;
      userInfo[Config.position]= positionController.text;
      userInfo[Config.profilePicUrl] = data;

      userInfo[Config.selectSport]= pModel.sports;

      _saveSports(pModel.sports ?? "BasketBall");
      Firestore.instance
          .collection(Config.users)
          .document(widget.userId)
          .updateData(userInfo)
          .then((_) {
        setState(() {
          loading = false;
        });

        print("completed");

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
        );

      });

    });


  }

  bool autovalidate = false;
  bool loading = false;
  static DateTime dateTime = DateTime.now();
  static DateTime dateTime1 = DateTime.now();

  ProfileModel pModel = ProfileModel();

  String profilePic;

  File file;

  String _error;

  Future<File> _imageFile;

  void _onImageButtonPressed(ImageSource source, int numberOfItems) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Future<Null> _selectTodayDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime1,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != dateTime1) {
      print("date selected: ${dateTime.toString()}");
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime1);
      // String formattedDate = DateFormat.yMMMd().format(dateTime);
      setState(() {
        dateTime1 = picked;
        dobController.text = formattedDate;
      });
    } else if (picked != null) {
      print("date selected: ${dateTime.toString()}");
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime1);
      // String formattedDate = DateFormat.yMMMd().format(dateTime);
      setState(() {
        dateTime1 = picked;
        dobController.text = formattedDate;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
   loadProfileDetails();
   _saveUserId(widget.userId);
   print("user Id is"+widget.userId);
    super.initState();
  }



  @override
  void dispose() {
    // TODO: implement dispose

    fullNamesController.dispose();
  dobController.dispose();
    locationController.dispose();
    shortBioController.dispose();
    schoolController.dispose();
    positionController.dispose();
   sportsController.dispose();

    super.dispose();
    
  }

  /**
   * upload Profile Pic
   */
  Future<String> uploadImage(var imageFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage
        .ref()
        .child(Config.users)
        .child(Config.profilePic)
        .child(widget.userId)
        .child("myscout_$uuid.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
  }
  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            file = snapshot.data;

            return InkWell(
              onTap: () => _onImageButtonPressed(ImageSource.gallery, 1),
              child: new Container(
                  padding: EdgeInsets.all(10),
                  // height: MediaQuery.of(context).size.height/2.5,
                  child: CircleAvatar(
                    radius: 70.0,
                    backgroundImage: FileImage(snapshot.data),
                  )),
            );
          } else if (snapshot.error != null) {
            // showInSnackBar("Error Picking Image");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 70.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 70.0,
                  ),
                ),
              ),
            );
          } else {
            // showInSnackBar("You have not yet picked an image.");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  radius: 70.0,
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 70.0,
                  ),
                ),
              ),
            );
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: size.width,
            height:ScreenUtil.screenWidthDp > 650 ? ScreenUtil.instance.setHeight(300) :ScreenUtil.screenWidthDp > 413 || ScreenUtil.screenWidthDp < 650 ? ScreenUtil.instance.setHeight(500) : ScreenUtil.instance.setHeight(300) ,
            alignment: Alignment.center,
            child: Text(
              "Create Profile",
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top:
              ScreenUtil.screenWidthDp > 650 ? ScreenUtil.instance.setHeight(200) :ScreenUtil.screenWidthDp > 413 || ScreenUtil.screenWidthDp < 650 ? ScreenUtil.instance.setHeight(300) : ScreenUtil.instance.setHeight(200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  InkWell(
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery, 1);
                      },
                      child: _imageFile == null
                          ? Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ClipOval(
                            child: profilePic != null
                                ?  ClipRRect(
                                  borderRadius:
                                  new BorderRadius.circular(30),
                                  child:

                                  CachedNetworkImage(
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                    imageUrl: profilePic,
                                    placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                    errorWidget: (context, url, ex) =>
                                    new Icon(Icons.error),
                                  ),
                            )
                                : CircleAvatar(
                              backgroundColor:
                              Theme.of(context).accentColor,
                              radius: 70.0,
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size:70.0,
                              ),
                            ),
                          ))
                          : _previewImage()
                    // child: _prev,

                  ),
                  Form(
                    key: formKey,
                    autovalidate: autovalidate,
                    child: new Column(
                      children: <Widget>[
                        Card(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 50.0,
                                width: size.width,
                                padding: EdgeInsets.only(left: 5.0),
                                color: Theme.of(context).accentColor,
                                child: Text(
                                  "Basic Details",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                child: new TextFormField(
                                  controller: fullNamesController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "First Name and Last Name";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.fullNames = value.trim();
                                  }),

                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "First Name and Last Name",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ),
                              Container(
                                child:  InkWell(
                                  onTap: ()=>_showDatePicker(),
                                  child: TextFormField(
                                    controller: dobController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Date Of Birth";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.dob = value.trim();
                                    }),


                                     enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Date Of Birth",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: new TextFormField(
                                  controller: locationController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Hometown";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.location = value.trim();
                                  }),


                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Hometown",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ),
                              Container(
                                child: new TextFormField(
                                  controller: shortBioController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Short Bio";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.shortBio = value.trim();
                                  }),

                                  maxLines: 3,

                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Short Bio",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ),
                              Divider(color: Theme.of(context).primaryColor,),
                              Container(
                                child: new TextFormField(
                                  controller: positionController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Title Or Position";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.position = value.trim();
                                  }),

                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Title Or Position",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50.0,
                                  width: size.width,
                                  padding: EdgeInsets.only(left: 5.0),
                                  color: Theme.of(context).accentColor,
                                  child: Text(
                                    "Educational Level",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  child: new TextFormField(
                                    controller: schoolController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "School Or Organisation";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.school = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                      labelText: "School Or Organisation",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50.0,
                                  width: size.width,
                                  padding: EdgeInsets.only(left: 5.0),
                                  color: Theme.of(context).accentColor,
                                  child: Text(
                                    "Sport",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Select Sports"),

                                      DropdownButton(
                                          value: pModel.sports ??
                                              "BasketBall",
                                          items: <String>[
                                            "BasketBall",
                                            "FootBall",
                                            "Soccer",
                                            "Tennis",
                                            "BaseBall"

                                          ].map((String value) {
                                            return new DropdownMenuItem(
                                                value: value,
                                                child: new Text(
                                                  '${value}',
                                                  style: TextStyle(fontSize: 16.0),
                                                ));
                                          }).toList(),
                                          onChanged: (String value) {
                                            setState(() {
                                              pModel.sports = value.trim();
                                            });
                                          }),

                                    ],
                                  ),

                                ),


                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            loading == true
                                ? new CircularProgressIndicator()
                                : Container(
                                    padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                                    width: size.width / 1.3,
                                    //  color: Theme.of(context).primaryColor,

                                    child: RaisedButton(
                                      elevation: 0.0,
                                      onPressed: () {
                                        if (formKey.currentState.validate()) {
                                          if (_imageFile == null) {

                                            saveProfileDetailsWithoutImage();
                                          } else {
                                            setState(() {
                                              loading  = true;
                                            });
                                            saveProfileDetailsWithImage();
                                          }
                                        }
                                      },
                                      color: Theme.of(context).primaryColorLight,
                                      child: new Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: new Text("Submit",
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600)),
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
            ),
          ),
        ],
      ),
    );
  }
}
