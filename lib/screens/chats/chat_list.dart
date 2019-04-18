import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/chats/chat_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatList extends StatefulWidget {
  ChatList(
      {this.senderId, this.receiverId, this.listScrollController, this.userId,this.platform,this.update,this.chatId});
  final String senderId;
  final userId;
  final String receiverId;
  ScrollController listScrollController;
  final bool update;
  final platform;
  final String chatId;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  var listMessage;

  SharedPreferences prefs;
  String userId;
  String receiverId;




  _scrollListener() {
    if (widget.listScrollController.offset >= widget.listScrollController.position.maxScrollExtent &&
        !widget.listScrollController.position.outOfRange) {



      print("reached bottom");





    }
    if (widget.listScrollController.offset <= widget.listScrollController.position.minScrollExtent &&
        !widget.listScrollController.position.outOfRange) {
      setState(() {
        print("reached top");

        //
      });
    }
  }



  void initState() {
    super.initState();

    widget.listScrollController.addListener(_scrollListener);




  }






  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flexible(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection(Config.chats)
              .document(widget.chatId)
              .collection(Config.chatThread)
              .orderBy(Config.messageId, descending: true)

              .limit(10000)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor)));
            } else {


               listMessage = snapshot.data.documents;
              //  print("last message id"+listMessage[snapshot.data.documents.length - 1][Config.FIREBASE_MESSAGE_ID]);
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {


                 return ChatItem(
                  index: index,
                 // onDelete: ()=>deleteMessage(index),
                  //  document: snapshot.data.documents[index],
                  listMessage: listMessage,
                  userId: widget.userId,
                  senderId: widget.senderId,
                  receiverId: widget.receiverId,
                   chatId:widget.chatId
                );

                },
                itemCount: listMessage.length,
                reverse: true,
                controller: widget.listScrollController,
              );
            }
          },
        ),
      ),
    );
  }
}

