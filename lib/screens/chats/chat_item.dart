import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myscout/screens/gallery/view_image.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatItem extends StatefulWidget {
  ChatItem(
      {Key key,
      // @required this.document,

      @required this.userId,
      @required this.senderId,
      @required this.receiverId,
      this.listMessage,
        this.chatId,
      this.index})
      : super(key: key);
  // final DocumentSnapshot document;
  final String userId;
  List<DocumentSnapshot> listMessage;
  final String chatId;
  final int index;
  final String senderId;
  final String receiverId;

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _isLoading;
  bool _permissisonReady;
  String _localPath;
  var status, progress;
  String downId;

  void initState() {
    super.initState();
      print("senderId =" +widget.senderId);
      print("receiverId = "+widget.receiverId);
    _isLoading = true;
  }


  Future<Null> chatOptions(BuildContext context, String messageId, bool left) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,

          content: Container(
              height: 120.0,

              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/myscout.png'),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Do you wish to delete this message?",style: TextStyle(
                        color: Colors.white,fontSize: 18.0
                    ),),
                  )
                ],
              )
          ),
          actions: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Theme.of(context).accentColor,
                child: new Text(
                  "No",
                  style: TextStyle(fontSize: 14.0,color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();


                  // checkUserType();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Theme.of(context).accentColor,
                child: new Text(
                  "Yes",
                  style: TextStyle(fontSize: 14.0,color: Colors.white),
                ),
                onPressed: () {

                  Map map = Map<String,bool>();
                  map[widget.senderId] = false;
                  map[widget.receiverId] = true;

                  Navigator.of(context).pop();
                  left?
                  Firestore.instance.collection(Config.chats).document(widget.chatId).collection(Config.chatThread).document(messageId)
                  .updateData({
                   Config.visible:map
                  }).then((_){
                    setState(() {

                    });
                  }) :
                  Firestore.instance.collection(Config.chats).document(widget.chatId).collection(Config.chatThread).document(messageId)
                      .updateData({
                    Config.visible:map
                  }).then((_){
                    setState(() {

                    });
                  });



                  // checkUserType();
                },
              ),
            ),

          ],
        );
      },
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            widget.listMessage != null &&
            widget.listMessage[index - 1][Config.receiverId] ==
                widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            widget.listMessage != null &&
            widget.listMessage[index - 1][Config.receiverId] !=
                widget.userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem(BuildContext context) {


    if (widget.listMessage[widget.index][Config.receiverId] !=
        widget.senderId) {
      return widget.listMessage[widget.index][Config.visible][widget.senderId] ?
      // Right (my message)
       Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          widget.listMessage[widget.index][Config.messageType] == Config.text
              // Text
              ? InkWell(
                  onLongPress: () {
                    chatOptions(context,widget.listMessage[widget.index][Config.messageId], false);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.listMessage[widget.index][Config.message],
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.listMessage[widget.index]
                                          [Config.createdOn] ==
                                      null
                                  ? ""
                                  : timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(widget
                                          .listMessage[widget.index]
                                              [Config.createdOn]
                                          .millisecondsSinceEpoch)),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(bottom: 5.0, right: 10.0),
                  ),
                )
              : widget.listMessage[widget.index][Config.messageType] ==
                      Config.image
                  ?
                  // Image
                  InkWell(
                      onLongPress: () {
                        chatOptions(context,widget.listMessage[widget.index][Config.messageId], false);
                      },

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewImageScreen(
                                    tag: widget.listMessage[widget.index]
                                        [Config.messageId],
                                    imageUrl: widget.listMessage[widget.index]
                                        [Config.imageUrl],
                                  )),
                        );
                      },
                      child: Container(
                        width: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              child: Hero(
                                tag: widget.listMessage[widget.index]
                                    [Config.messageId],
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).accentColor),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                        child: Image.asset(
                                          'images/img_not_available.jpeg',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                  imageUrl: widget.listMessage[widget.index]
                                      [Config.imageUrl],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  widget.listMessage[widget.index]
                                              [Config.createdOn] ==
                                          null
                                      ? ""
                                      : timeago.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              widget
                                                  .listMessage[widget.index]
                                                      [Config.createdOn]
                                                  .millisecondsSinceEpoch)),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                /*
                                    Text(
                                      widget.listMessage[widget.index][Config.createdOn] ==
                                              null
                                          ? ""
                                          : DateFormat('kk:mm - yyyy-MM-dd').format(
                                              widget.listMessage[widget.index][
                                                  Config.createdOn]),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12.0),
                                    ),
                                    */
                              ],
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(
                            bottom:
                                isLastMessageRight(widget.index) ? 20.0 : 10.0,
                            right: 10.0),
                      ))
                  : Container(),
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(Config.users)
                  .document(widget.listMessage[widget.index][Config.senderId])
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                    onLongPress: () {
                      /*
                                chatOptions(
                                  context,
                                  widget.listMessage[widget.index][Config.FIREBASE_IMAGE],
                                  true),
                                 */
                    },
                    onTap: () {
                      /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewImageScreen(
                                            imageUrl: widget.listMessage[widget.index][
                                                Config.FIREBASE_IMAGE],
                                          )),
                                );
                                */
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 2),
                          borderRadius: BorderRadius.circular(30)),
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                                width: 35.0,
                                height: 35.0,
                                padding: EdgeInsets.all(10.0),
                              ),
                          imageUrl: snapshot.data[Config.profilePicUrl],
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ) : Container();
    } else {
      // Left (peer message)
      return widget.listMessage[widget.index][Config.visible][widget.senderId] ?

        InkWell(
        onLongPress: (){
          chatOptions(context,widget.listMessage[widget.index][Config.messageId], true);
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection(Config.users)
                          .document(
                              widget.listMessage[widget.index][Config.senderId])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(

                            onTap: () {
                              /*
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewImageScreen(
                                              imageUrl: widget.listMessage[widget.index][
                                                  Config.FIREBASE_IMAGE],
                                            )),
                                  );
                                  */
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context).accentColor),
                                        ),
                                        width: 35.0,
                                        height: 35.0,
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                  imageUrl: snapshot.data[Config.profilePicUrl],
                                  width: 35.0,
                                  height: 35.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                  widget.listMessage[widget.index][Config.messageType] ==
                          Config.text
                      ? InkWell(
                          onTap: () {
                            /*
                            chatOptions(context,
                              widget.listMessage[widget.index][Config.FIREBASE_IMAGE], true),
                             */
                          },
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.listMessage[widget.index]
                                      [Config.message],
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      widget.listMessage[widget.index]
                                                  [Config.createdOn] ==
                                              null
                                          ? ""
                                          : timeago.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  widget
                                                      .listMessage[widget.index]
                                                          [Config.createdOn]
                                                      .millisecondsSinceEpoch)),
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                            width: 200.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0)),
                            margin: EdgeInsets.only(left: 10.0),
                          ),
                        )
                      : widget.listMessage[widget.index][Config.messageType] ==
                              Config.image
                          ? Container(
                              width: 200.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onLongPress: () {
                                      chatOptions(context,widget.listMessage[widget.index][Config.messageId], true);
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewImageScreen(
                                                  tag: widget.listMessage[widget
                                                      .index][Config.messageId],
                                                  imageUrl: widget.listMessage[
                                                          widget.index]
                                                      [Config.imageUrl],
                                                )),
                                      );
                                    },
                                    child: Material(
                                      child: Hero(
                                        tag: widget.listMessage[widget.index]
                                            [Config.messageId],
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .accentColor),
                                                ),
                                                width: 200.0,
                                                height: 200.0,
                                                padding: EdgeInsets.all(70.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Material(
                                                child: Image.asset(
                                                  'images/img_not_available.jpeg',
                                                  width: 200.0,
                                                  height: 200.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                              ),
                                          imageUrl:
                                              widget.listMessage[widget.index]
                                                  [Config.imageUrl],
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.listMessage[widget.index]
                                                    [Config.createdOn] ==
                                                null
                                            ? ""
                                            : timeago.format(DateTime
                                                .fromMillisecondsSinceEpoch(widget
                                                    .listMessage[widget.index]
                                                        [Config.createdOn]
                                                    .millisecondsSinceEpoch)),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10.0),
                            )
                          : Container()
                ],
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        ),
      ) :Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildItem(context);
  }
}
