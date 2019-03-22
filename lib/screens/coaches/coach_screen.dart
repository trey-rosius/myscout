import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class CoachScreen extends StatefulWidget {
  @override
  _CoachScreenState createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2.3;
    return Scaffold(
      body:  StreamBuilder(
        stream: Firestore.instance.collection(Config.coaches).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (itemWidth / itemHeight), crossAxisCount: 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, int index)
                {
                  final DocumentSnapshot document = snapshot.data.documents[
                  index];
                  return PlayerItem(document: document);
                });

          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
