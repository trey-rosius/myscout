import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/cards/card_item_scroller.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class CardScreenScroller extends StatefulWidget {
  CardScreenScroller({this.userId});
  final String userId;
  @override
  _CardScreenScrollerState createState() => _CardScreenScrollerState();
}

class _CardScreenScrollerState extends State<CardScreenScroller> {
  bool isLargeScreen = false;
  @override
  void initState() {
    print("card user Id is "+widget.userId);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if(size.width < 412)
    {
      isLargeScreen = false;
    }
    else
    {
      isLargeScreen = true;
    }


    return Scaffold(
      body:  StreamBuilder(
          stream: Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).snapshots(),

        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, int index)
                {
                  final DocumentSnapshot document = snapshot.data.documents[
                  index];
                  return CardItemScroller(document: document);
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
