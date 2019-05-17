import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class SearchCardScreen extends StatefulWidget {
  SearchCardScreen({this.userId,this.searchString});
  final String userId;
  final String searchString;
  @override
  _SearchCardScreenState createState() => _SearchCardScreenState();
}

class _SearchCardScreenState extends State<SearchCardScreen> {

  bool isLargeScreen = false;

  @override
  void initState() {
    print("search String is"+widget.searchString);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;



    /*24 is for notification bar on Android*/
   final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
   final double itemHeight1 = (size.height - kToolbarHeight - 24) / 3.4;
    final double itemWidth = size.width / 2.3;
    return Scaffold(

      body:  StreamBuilder(
     stream:
     Firestore.instance.collection(Config.cards).snapshots(),




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
                  return document[Config.fullNames]
                      .toLowerCase()
                      .contains(widget.searchString.toLowerCase()) ?

                    CardItem(document: document) :Container();
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
