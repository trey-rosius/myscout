import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/utils/Config.dart';

import 'dart:ui' as ui;

import 'package:uuid/uuid.dart';


class FullScreenCard extends StatefulWidget {
  FullScreenCard({this.cardId,this.userId});
  final String cardId;
  final String userId;

  @override
  _FullScreenCardState createState() => _FullScreenCardState();
}

class _FullScreenCardState extends State<FullScreenCard> {
  GlobalKey _globalKey = new GlobalKey();
  bool loading = false;

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

        Firestore.instance.collection(Config.cards).document(widget.cardId).updateData({
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



@override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Save Card",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        centerTitle: true,

      ),

      body: Center(
        child:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RepaintBoundary(
    key: _globalKey,

      child:  Container(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection(Config.cards)
                          .document(widget.cardId)
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
                                                      Expanded(
                                                        child: Text(
                                                          docs.data[
                                                              Config.schoolOrOrg],
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12,
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
                                                            fontSize: 12,
                                                            color: Colors.white),
                                                      ),
                                                      Text(
                                                        docs.data[Config.position],
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white),
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
      )
    );
  }
}
