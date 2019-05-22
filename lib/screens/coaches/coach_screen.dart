import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/coaches/coach_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class CoachScreen extends StatefulWidget {
  CoachScreen({this.userId});
  final String userId;

  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;



    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemHeight1 = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 1.8;
    return Scaffold(

      body:  StreamBuilder(
        stream:
        Firestore.instance.collection(Config.cards).where(Config.userType,isEqualTo: Config.coachScout).snapshots(),



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
                  print(document);
                  return CoachItem(document: document);
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
