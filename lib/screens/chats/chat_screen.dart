import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myscout/screens/chats/chat_list.dart';
import 'package:myscout/utils/Config.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  final String receiverId;

  ChatScreen({Key key, @required this.senderId, @required this.receiverId})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(senderId: senderId, receiverId: receiverId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key, @required this.senderId, @required this.receiverId});

  String senderId;
  String receiverId;
  String userId;
  String _filePath;
  final greyColor = Color(0xffaeaeae);
  bool update = false;
  String chatId="";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  SharedPreferences prefs;
 // var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  File imageFile;
  File audioFile;
  bool isLoading;
  String audioFilePath;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  ScrollController listScrollController;
  final FocusNode focusNode = new FocusNode();

  String fileExtension;


  @override
  void initState() {
    super.initState();

    if (senderId.hashCode <= receiverId.hashCode) {
      chatId = '$senderId-$receiverId';
    } else {
      chatId = '$receiverId-$senderId';
    }
    listScrollController = new ScrollController();
    isLoading = false;

    imageUrl = '';

    readLocal();



    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage 1: $message");
        print("onMessage 2: "+message['notification']['title']);
        print("onMessage 3: "+message['data']['username']);



        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

  }




  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(Config.userId) ?? '';


  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendImage(imageUrl, Config.image);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print("this file is not an image");
      //show a snackbar instead
      // Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }



  sendTypingMessage(bool typing) {
    Firestore.instance
        .collection(Config.typing)
        .document(senderId)
        .collection(receiverId)
        .document(Config.typing)
        .setData({Config.typing: typing});
  }

  void onSendImage(String imageUrl, String type) {

    Map map = Map<String,bool>();
    map[senderId] = true;
    map[receiverId] = true;
    var colReference = Firestore.instance
        .collection(Config.chats)
        .document(chatId)
        .collection(Config.chatThread);

//add message to receiver

    colReference.add({
      Config.senderId: senderId,
      Config.receiverId: receiverId,
      Config.imageUrl: imageUrl,
      Config.visible:map,
      Config.createdOn: FieldValue.serverTimestamp(),
      Config.messageType: type
    }).then((DocumentReference doc) {
      String docId = doc.documentID;
      colReference
          .document(docId)
          .updateData({Config.messageId: docId});

      Firestore.instance.collection(Config.users).document(senderId).collection(Config.chatList).document(receiverId).setData({
        Config.userId : receiverId,
        Config.createdOn:FieldValue.serverTimestamp()
      },merge: true);
      Firestore.instance.collection(Config.users).document(receiverId).collection(Config.chatList).document(senderId).setData({
        Config.userId : senderId,
        Config.createdOn:FieldValue.serverTimestamp()
      },merge: true);

    });
  }


  void senderReceiver(String content, String type) {


    Map map = Map<String,bool>();
    map[senderId] = true;
    map[receiverId] = true;
    var colReference = Firestore.instance
        .collection(Config.chats)
        .document(chatId)
        .collection(Config.chatThread);

//add message to receiver

    colReference.add({
      Config.senderId: senderId,
      Config.receiverId: receiverId,
      Config.imageUrl: imageUrl,
      Config.message:content,
      Config.visible:map,
      Config.createdOn: FieldValue.serverTimestamp(),
      Config.messageType: type
    }).then((DocumentReference doc) {
      String docId = doc.documentID;
      colReference
          .document(docId)
          .updateData({Config.messageId: docId});

      Firestore.instance.collection(Config.users).document(senderId).collection(Config.chatList).document(receiverId).setData({
        Config.userId : receiverId,
        Config.createdOn:FieldValue.serverTimestamp()

      },merge: true);
      Firestore.instance.collection(Config.users).document(receiverId).collection(Config.chatList).document(senderId).setData({
        Config.userId : senderId,
        Config.createdOn:FieldValue.serverTimestamp()
      },merge: true);

    },);
  }

  void onSendMessage(String content, String type) {
    //type = audio,text,image
    if (content.trim() != '') {
      textEditingController.clear();
      sendTypingMessage(false);

      senderReceiver(content.trim(), type);
      setState(() {
        update = true;
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final platform = Theme.of(context).platform;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
        title: Text("Message"),







      ),
     body:  Column(
       children: <Widget>[
         // List of messages
         // Container(),

         ChatList(
             listScrollController: listScrollController,
             userId: userId,
             senderId: senderId,
             receiverId: receiverId,
             platform: platform,
             update: update,
         chatId: chatId,),


         // Sticker

         // Input content
         buildInput(),
       ],
     ),
    );
  }



  Widget buildInput() {
    return
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection(Config.typing)
                          .document(receiverId)
                          .collection(senderId)
                          .document(Config.typing)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {

                        if (snapshot.data != null && snapshot.data.exists) {
                          return
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                                  child: snapshot.data[Config.typing] ? Text("typing......",style: TextStyle(fontSize: 14.0,color: Colors.white,fontStyle: FontStyle.italic),) : Container()



                          );
                        }
                        else
                        {
                          return Container();
                        }


                      }),
                  isLoading ?
                  Container(
                      height: 20.0,
                      width: 20.0,
                      margin:EdgeInsets.only(right: 20.0),
                      child: CircularProgressIndicator())
                      : Container()
                ],
              ),
              Row(
                  children: <Widget>[
                    // Button send image
                     Container(
                       margin: EdgeInsets.only(left: 10.0),
                       decoration: BoxDecoration(
                           color: Theme.of(context).accentColor,
                           shape: BoxShape.circle),
                       child: IconButton(
                            icon: new Icon(Icons.image),
                            onPressed: getImage,
                            color: Colors.white,
                          ),
                     ),





                    // Edit text
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0)
                        ),

                        child: Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: TextField(
                                maxLines: null,
                                onChanged: (String text) {
                                  if (text.trim().length > 0) {
                                    sendTypingMessage(true);
                                  } else {
                                    sendTypingMessage(false);
                                  }
                                },

                                style: TextStyle(color: Colors.black, fontSize: 15.0),
                                controller: textEditingController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Say Something...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Button send message
                    Container(
                        margin: new EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: new IconButton(
                            icon: new Icon(Icons.send),
                            onPressed: () => onSendMessage(
                                textEditingController.text, Config.text),
                            color: Colors.white,
                          ),
                        ),
                      ),

                  ],


    ),
            ],
          );
  }
}
