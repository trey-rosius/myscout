import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/cards/card_item_scroller.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class PopularCardScroller extends StatefulWidget {
  PopularCardScroller({this.userId});
  final String userId;
  @override
  _PopularCardScrollerState createState() => _PopularCardScrollerState();
}

class _PopularCardScrollerState extends State<PopularCardScroller> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:  StreamBuilder(
        stream: Firestore.instance.collection(Config.cards).orderBy(Config.collectedCount,descending: true).snapshots(),

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
