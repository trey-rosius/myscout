import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/screens/trade_card/trade_card_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class TradeScreen extends StatefulWidget {
  TradeScreen({this.userId,this.cardName,this.cardId});
  final String userId;
  final String cardName;
  final String cardId;
  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Trade Card",style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body:  StreamBuilder(
        stream: Firestore.instance.collection(Config.users).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return ListView.builder(

                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, int index)
                {
                  final DocumentSnapshot document = snapshot.data.documents[
                  index];
                  return TradeCardItem(document: document,userId: widget.userId,cardName:widget.cardName,cardId:widget.cardId);
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
