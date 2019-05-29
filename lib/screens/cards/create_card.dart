import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myscout/models/card_model.dart';
import 'package:myscout/screens/cards/card_color.dart';
import 'package:myscout/screens/cards/full_screen_card.dart';
import 'package:myscout/utils/Config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'data.dart';

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';


import 'dart:ui' as ui;

class CreateCard extends StatefulWidget {
  CreateCard({this.userId,this.cardId,this.userType});
  final String userId;
  final String cardId;
  final String userType;
  @override
  _CreateCardState createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {

  GlobalKey _globalKey = new GlobalKey();


  void  _capturePng() async {
    try {
      setState(() {
        loading = true;
      });
      RenderRepaintBoundary boundary =
      _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();

      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      setState(() {});
      final FirebaseStorage storage = FirebaseStorage.instance;
      uploadImageBytes(pngBytes, storage).then((String data) {

        Firestore.instance.collection(Config.cards).document(cardId).updateData({
          Config.cardImageUrl:data
        }).then((_){
          print("image url"+ data);
          setState(() {
            loading = false;
          });
          Navigator.of(context).pop();
        });
      });

    } catch (e) {
      print(e);
    }
  }
  Future<String> uploadImageBytes(var pngBytes, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage
        .ref()
        .child(Config.cards)
        .child(widget.userId)
        .child("$uuid.png");


    StorageUploadTask uploadTask = ref.putData(pngBytes);
    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
  }



  String sports = "BasketBall";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  final fullNamesController = TextEditingController();
  final dobController = TextEditingController();
  final locationController = TextEditingController();
  final shortBioController = TextEditingController();
  final titleController = TextEditingController();
  final jerseyNumController = TextEditingController();
  final schoolOrganisationController = TextEditingController();


  final actSatController = TextEditingController();
  final classController = TextEditingController();
  final sportsController = TextEditingController();
  final positionController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  List<String> colorCodes = [
    "0xFF958d78",
    "0xFF6c6c6c",
    "0xFF11567b",
    "0xFFa4241d",
    "0xFF034f08",
    "0xFF935d05",
    "0xFF530673"
  ];
  bool autovalidate = false;
  bool loading = false;
  int currentColorIndex = 0;
  static DateTime dateTime = DateTime.now();
  static DateTime dateTime1 = DateTime.now();
  String cardPic;
  bool fullScreenCard = false;
  String cardId;

 // ProfileModel pModel = ProfileModel();
  CardModel pModel = CardModel();

  File file;

  String _error;

  Future<File> _imageFile;
  String profilePic;
  String userType;

  @override
  void initState() {
    loadCardDetails();
    _getUserType();
    super.initState();
  }
  void _onImageButtonPressed(ImageSource source, int numberOfItems) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  _getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userType = prefs.getString(Config.userType);
  print("userType is"+userType);
  }


  loadCardDetails(){

    Firestore.instance
        .collection(Config.cards)
        .document(widget.cardId)
        .get()
        .then((DocumentSnapshot snapshot) {
      setState(() {
        profilePic = snapshot[Config.profilePicUrl];
        fullNamesController.text = snapshot[Config.fullNames];
        dobController.text = snapshot[Config.dob];
        locationController.text = snapshot[Config.location];
        shortBioController.text = snapshot[Config.shortBio];
        if(userType==Config.coachScout){
          titleController.text = snapshot[Config.schoolOrOrg];
        }
        else
        {
          jerseyNumController.text = snapshot[Config.jerseyNumber];
          positionController.text = snapshot[Config.position];
        }

        schoolOrganisationController.text = snapshot[Config.schoolOrOrg];

        currentColorIndex = snapshot[Config.cardColorIndex];

        actSatController.text = snapshot[Config.actSat];
        classController.text = snapshot[Config.CLASS];
        sports = snapshot[Config.selectSport];

        heightController.text = snapshot[Config.height];
        weightController.text = snapshot[Config.weight];
      });


    });

  }




 saveCardDetailsWithImageUrl(){

   print(pModel.sports);

   setState(() {
     loading = true;
   });


     Map userInfo = new Map<String, dynamic>();
     userInfo[Config.fullNames]= fullNamesController.text;
     userInfo[Config.dob]= dobController.text;
     userInfo[Config.location]= locationController.text;
     userInfo[Config.shortBio]= shortBioController.text;
     userInfo[Config.collectedCount]= 0;



     userInfo[Config.profilePicUrl] = profilePic;
     userInfo[Config.cardColor] = colorCodes[currentColorIndex];
     userInfo[Config.cardColorIndex] = currentColorIndex;
     userInfo[Config.userType] = userType;
     userInfo[Config.cardCreatorId] = widget.userId;
     userInfo[Config.schoolOrOrg] = schoolOrganisationController.text;
     if(userType==Config.coachScout){
       userInfo[Config.title] = titleController.text;
     }
     else
     {
       userInfo[Config.position]= positionController.text;
       userInfo[Config.jerseyNumber]= jerseyNumController.text;

     }



     userInfo[Config.actSat]= actSatController.text;
     userInfo[Config.CLASS]= classController.text;

     userInfo[Config.height]= heightController.text;
     userInfo[Config.weight]= weightController.text;
     userInfo[Config.selectSport]= sports;
     userInfo[Config.createdOn]= FieldValue.serverTimestamp();



       Firestore.instance.collection(Config.cards).document(widget.cardId).updateData(userInfo).then((_){

         setState(() {
           loading = false;
           cardId = widget.cardId;
           fullScreenCard = true;
         });
         /*
         Navigator.push(
             context,
             new MaterialPageRoute(
               builder: (context) => FullScreenCard(cardId:widget.cardId,userId: widget.userId,),
             ));
             */
         // Navigator.of(context).pop();
       });




 }
  saveCardDetailsWithImage(){

    print(pModel.sports);

    setState(() {
      loading = true;
    });
    final FirebaseStorage storage = FirebaseStorage.instance;
    uploadImage(file, storage).then((String data) {


      Map userInfo = new Map<String, dynamic>();
      userInfo[Config.fullNames]= fullNamesController.text;
      userInfo[Config.dob]= dobController.text;
      userInfo[Config.location]= locationController.text;
      userInfo[Config.shortBio]= shortBioController.text;
      userInfo[Config.collectedCount]= 0;



      userInfo[Config.profilePicUrl] = data;
      userInfo[Config.cardColor] = colorCodes[currentColorIndex];
      userInfo[Config.cardColorIndex] = currentColorIndex;
      userInfo[Config.userType] = userType;
      userInfo[Config.cardCreatorId] = widget.userId;
      userInfo[Config.schoolOrOrg] = schoolOrganisationController.text;
      if(userType==Config.coachScout){
        userInfo[Config.title] = titleController.text;
      }
      else
        {
          userInfo[Config.position]= positionController.text;
          userInfo[Config.jerseyNumber]= jerseyNumController.text;

        }



      userInfo[Config.actSat]= actSatController.text;
      userInfo[Config.CLASS]= classController.text;

      userInfo[Config.height]= heightController.text;
      userInfo[Config.weight]= weightController.text;
      userInfo[Config.selectSport]= sports;
      userInfo[Config.createdOn]= FieldValue.serverTimestamp();


      Firestore.instance
          .collection(Config.cards).add(userInfo).then((DocumentReference docRef){

            Firestore.instance.collection(Config.cards).document(docRef.documentID).updateData({
              Config.cardId:docRef.documentID
            }).then((_){
              Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).document(docRef.documentID)
                  .setData({
                Config.cardId:docRef.documentID,
                Config.cardCreatorId:widget.userId
              });
              Firestore.instance.collection(Config.users).document(widget.userId)
                  .updateData({
                Config.cardId:docRef.documentID,

              });
              setState(() {
                loading = false;
                cardId = docRef.documentID;
                fullScreenCard = true;
              });
              /*
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                       builder: (context) => FullScreenCard(cardId:docRef.documentID,userId: widget.userId,),
                  ));
                  */
             // Navigator.of(context).pop();
            });
      });

    });


  }

  /**
   * upload Profile Pic
   */
  Future<String> uploadImage(var imageFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();
    StorageReference ref = storage
        .ref()
        .child(Config.cards)
        .child(widget.userId)
        .child("$uuid.jpg");


    StorageUploadTask uploadTask = ref.putFile(imageFile);
    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;
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
              child:Container(
                padding: EdgeInsets.all(10),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border:Border.all(color: Theme.of(context).accentColor,width: 4),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Image.file(snapshot.data,width: 150,height: 150,fit: BoxFit.cover,),
                  ),
            );
          } else if (snapshot.error != null) {
            // showInSnackBar("Error Picking Image");
            return InkWell(
              onTap: () {
                _onImageButtonPressed(ImageSource.gallery, 1);
              },
              child: Container(
                height: 150,
                width: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:Border.all(color: Theme.of(context).accentColor,width: 4),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 70.0,
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
                height: 150,
                width: 150,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:Border.all(color: Theme.of(context).accentColor,width: 4),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                    Icons.card_membership,
                    color: Colors.white,
                    size: 70.0,
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
    titleController.dispose();
    schoolOrganisationController.dispose();
    jerseyNumController.dispose();


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
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.cardId== null ? "Create Card" : "Edit Card",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        centerTitle: true,

      ),
      body: fullScreenCard ?
      Center(
        child:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RepaintBoundary(
                key: _globalKey,

                child:  Container(
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection(Config.cards)
                            .document(cardId)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> docs) {
                          if (docs.data != null) {
                            return docs.data[Config.userType] == Config.coachScout
                                ? InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 400,
                                  width: 300,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, right: 5.0),
                                          child: AspectRatio(
                                            aspectRatio: 2 / 2.3,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                              docs.data[Config.profilePicUrl],
                                              placeholder: (context, url) =>
                                                  SpinKitWave(
                                                    itemBuilder: (_, int index) {
                                                      return DecoratedBox(
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context)
                                                              .accentColor,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 330,
                                        height: 100,
                                        margin: EdgeInsets.fromLTRB(10, 330, 10, 0),
                                        color: Color(
                                            int.parse(docs.data[Config.cardColor])),
                                      ),
                                      Center(
                                        child: Container(
                                          margin:
                                          EdgeInsets.fromLTRB(10, 330, 10, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(docs.data[Config.fullNames],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      docs.data[Config.schoolOrOrg],
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white)),
                                                  Text(
                                                      " - " +
                                                          docs.data[Config.title],
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                          child: Image.asset(
                                            'assets/images/card_coach.png',
                                            height: 400,
                                            width: 300,
                                          )),
                                    ],
                                  ),
                                ))
                                : InkWell(
                                onTap: () {},
                                child: Container(
                                  color: Color(
                                      int.parse(docs.data[Config.cardColor])),

                                  height: 400,
                                  width: 290  ,

                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 40),
                                        child: AspectRatio(
                                          aspectRatio: 1.4 / 1.82,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                            docs.data[Config.profilePicUrl],
                                            placeholder: (context, url) =>
                                                SpinKitWave(
                                                  itemBuilder: (_, int index) {
                                                    return DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                    );
                                                  },
                                                ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(80, 0, 0, 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "HEIGHT",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  docs.data[Config.height],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "WEIGHT",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  docs.data[Config.weight],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(

                                                child: Text(
                                                  "lbs",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left:90,top: 340),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: <Widget>[
                                            Text(
                                              docs.data[Config.fullNames],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            Container(

                                              margin: EdgeInsets.only(top: 5,right: 20),
                                              child: Row(

                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text(
                                                      docs.data[
                                                      Config.schoolOrOrg],
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Text(
                                                    " . #" +
                                                        docs.data[
                                                        Config.jerseyNumber],
                                                    maxLines: 1,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left:5.0),
                                                    child: Text(
                                                      docs.data[Config.position],
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Container(




                                          child: Image.asset(
                                            'assets/images/card_athlete.png',
                                            height: 400,
                                            width: 300,
                                          )),
                                      Container(
                                        margin: EdgeInsets.only(left:10,top: 340),
                                        child:
                                        Text(

                                          docs.data[Config.CLASS].toLowerCase() == Config.freshMan ? "FR":docs.data[Config.CLASS].toLowerCase() == Config.senior ? "SR" : "JR" ,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF998e6f)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          } else {
                            return Container();
                          }
                        })),
              ),
              Column(
                children: <Widget>[
                  loading == true
                      ?  Container(
                    padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                    child: CircularProgressIndicator(),
                  )
                      : Container(
                    padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                    width: size.width / 1.3,
                    //  color: Theme.of(context).primaryColor,

                    child: RaisedButton(
                      elevation: 0.0,
                      onPressed: () =>_capturePng(),


                      color: Theme.of(context).primaryColorLight,
                      child: new Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: new Text("Save Card",
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
      ) :
      Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            width: size.width,
            height: 300,
            alignment: Alignment.center,

          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
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
                          child:Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border:Border.all(color: Theme.of(context).accentColor,width: 4),
                              borderRadius:
                               BorderRadius.circular(10),
                            ),
                            child: profilePic != null
                                  ?
                                CachedNetworkImage(
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit.cover,
                                  imageUrl: profilePic,
                                  placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                                  errorWidget: (context, url, ex) =>
                                  new Icon(Icons.error),
                                )

                                  :
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                border:Border.all(color: Theme.of(context).accentColor,width: 4),
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                              child:
                             Icon(
                                  Icons.card_membership,
                                  color: Theme.of(context).accentColor,
                                  size:70.0,

                              ),
                            ),
                          )
                          )
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
                              userType == Config.coachScout ?
                              Container(
                                child: new TextFormField(
                                  controller: titleController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Title";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.title = value.trim();
                                  }),

                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Title",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ) :Container(),
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
                              userType == Config.coachScout ? Container():  Container(
                                child: new TextFormField(
                                  controller: jerseyNumController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Jersey Number";
                                    }
                                  },
                                  onSaved: ((String value){
                                    pModel.jerseyNumber = value.trim();
                                  }),


                                  // enabled: false,
                                  // keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    labelText: "Jersey Number",
                                    contentPadding: new EdgeInsets.all(10.0),
                                    filled: false,
                                  ),
                                ),
                              ),
                              Container(
                                child: new TextFormField(
                                  controller: schoolOrganisationController,
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
                                  decoration: new InputDecoration(
                                    labelText: "School Or Organisation",
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

                                userType == Config.coachScout ? Container():    Container(
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
                                userType == Config.coachScout ? Container():      Container(
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
                                          value: sports ??
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
                                              sports = value.trim();
                                            });
                                          }),

                                    ],
                                  ),

                                ),
                                Divider(color: Theme.of(context).primaryColor,),

                                userType == Config.coachScout ? Container() :
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
                                ?  Padding(
                              padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                              child: CircularProgressIndicator(),
                            )
                                : Container(
                              padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                              width: size.width / 1.3,
                              //  color: Theme.of(context).primaryColor,

                              child: RaisedButton(
                                elevation: 0.0,
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                   if(profilePic != null)
                                     {
                                       saveCardDetailsWithImageUrl();

                                     }
                                     else
                                       {
                                         saveCardDetailsWithImage();
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
