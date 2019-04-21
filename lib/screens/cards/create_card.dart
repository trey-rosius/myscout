import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myscout/screens/cards/card_color.dart';
import 'data.dart';
import 'package:myscout/models/profile_model.dart';
class CreateCard extends StatefulWidget {
  @override
  _CreateCardState createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  final fullNamesController = TextEditingController();
  final dobController = TextEditingController();
  final locationController = TextEditingController();
  final shortBioController = TextEditingController();
  final schoolController = TextEditingController();
  final gpaController = TextEditingController();
  final actSatController = TextEditingController();
  final classController = TextEditingController();
  final sportsController = TextEditingController();
  final positionController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;
  int currentColorIndex = 0;
  static DateTime dateTime = DateTime.now();
  static DateTime dateTime1 = DateTime.now();
  String cardPic;

  ProfileModel pModel = ProfileModel();

  File file;

  String _error;

  Future<File> _imageFile;
  String profilePic;

  void _onImageButtonPressed(ImageSource source, int numberOfItems) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  List<Widget> colorSelector() {
    List<Widget> colorItemList = new List();

    for (var i = 0; i < colors.length; i++) {
      colorItemList
          .add(CardColor(colors[i], i == currentColorIndex, () {
        setState(() {
          currentColorIndex = i;
        });
      }));
    }

    return colorItemList;
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
  void dispose() {
    // TODO: implement dispose

    fullNamesController.dispose();
    dobController.dispose();
    locationController.dispose();
    shortBioController.dispose();
    schoolController.dispose();
    gpaController.dispose();
    actSatController.dispose();
    classController.dispose();
    sportsController.dispose();
    positionController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: size.width,
            height: size.height / 5,
            alignment: Alignment.center,
            child: Text(
              "Create Card",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 100.0),
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
                                  onTap: ()=>_selectTodayDate1(context),
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
                                      return "Location";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.location = value.trim();
                                  }),


                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Location",
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
                                    "Choose Main Color",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                ),
                                Container(

                                  height: 70.0,


                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: colorSelector(),
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: new TextFormField(
                                    controller: actSatController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Act/Sat";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.actSat = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Act/Sat",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: new TextFormField(
                                    controller: classController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Class";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.athleteClass = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Class",
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
                                            "VolleyBall",

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
                                Divider(color: Theme.of(context).primaryColor,),
                                Container(
                                  child: new TextFormField(
                                    controller: positionController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Position";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.position = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Position",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: new TextFormField(
                                    controller: heightController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Height";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.height = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Height",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: new TextFormField(
                                    controller: weightController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Weight";
                                      }
                                    },
                                    onSaved: ((String value){
                                      pModel.weight = value.trim();
                                    }),

                                    // enabled: false,
                                    // keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                      labelText: "Weight",
                                      contentPadding: new EdgeInsets.all(10.0),
                                      filled: false,
                                    ),
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
                                   // saveProfileDetails();
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
