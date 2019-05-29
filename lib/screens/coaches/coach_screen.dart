import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/coaches/coach_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool isMediumScreen = false;
  bool isSmallScreen = false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
    return Scaffold(

      body:  StreamBuilder(
        stream:
        Firestore.instance.collection(Config.cards).where(Config.userType,isEqualTo: Config.coachScout).snapshots(),



        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: ScreenUtil.screenWidthDp < 413 ?(ScreenUtil.instance.setWidth(370)/ScreenUtil.instance.setHeight(650)) :
                (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? (ScreenUtil.instance.setWidth(450)/ScreenUtil.instance.setHeight(600))
                    :(ScreenUtil.instance.setWidth(450)/ScreenUtil.instance.setHeight(980))
                    ,crossAxisCount:ScreenUtil.screenWidthDp>1023 ? 3 : 2),
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
