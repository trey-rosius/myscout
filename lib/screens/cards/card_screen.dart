import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class CardScreen extends StatefulWidget {
  CardScreen({this.userId,this.cardType});
  final String userId;
  final String cardType;
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;



    /*24 is for notification bar on Android*/
   final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
   final double itemHeight1 = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 1.8;
    return Scaffold(

      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text(widget.cardType ==Config.popularCards ?"Popular Cards" :
        widget.cardType ==Config.newCards ?"New Cards" :"My Cards" ,style: TextStyle(fontSize: 20.0),),


      ),
      body:  StreamBuilder(
     stream: widget.cardType ==Config.popularCards ?
     Firestore.instance.collection(Config.cards).orderBy(Config.collectedCount,descending: true).snapshots()
          :
     widget.cardType ==Config.newCards ?
     Firestore.instance.collection(Config.cards).orderBy(Config.createdOn,descending: false).snapshots() :
     Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).snapshots(),



        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: isLargeScreen ? (itemWidth / itemHeight1) : (itemWidth / itemHeight), crossAxisCount: 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, int index)
                {
                  final DocumentSnapshot document = snapshot.data.documents[
                  index];
                  return CardItem(document: document);
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
