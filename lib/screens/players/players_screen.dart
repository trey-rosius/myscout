import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/coaches/coach_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class PlayerScreen extends StatefulWidget {
  PlayerScreen({this.userId});
  final String userId;

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {


@override
  void initState() {
  print("User id is"+widget.userId);
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
    return Scaffold(

      body:  StreamBuilder(
        stream:
       // Firestore.instance.collection(Config.cards).where(Config.userType,isEqualTo: Config.athleteOrParent).where(Config.cardCreatorId,isEqualTo: widget.userId).snapshots(),
        Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).where(Config.userType,isEqualTo: Config.athleteOrParent).snapshots(),



        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 3/4
                    ,crossAxisCount:ScreenUtil.screenWidthDp>1023 ? 3 : 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, int index)
                {
                  final DocumentSnapshot document = snapshot.data.documents[
                  index];
                  print(document);
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
