import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/gallery/photo_item.dart';
import 'package:myscout/screens/gallery/video_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class VideoScreen extends StatefulWidget {
  VideoScreen({this.userId});
  final String userId;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    getUserId();
    super.initState();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    final double itemWidth = size.width / 2.3;
    return Scaffold(
      body:  StreamBuilder(
        stream: Firestore.instance.collection(Config.posts).where(Config.postAdminId,isEqualTo:userId).where(Config.isVideoPost,isEqualTo: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return LoadingScreen();
          } else if (snapshot.hasData) {
            return ListView.builder(
               itemBuilder: (context,index){
                 final DocumentSnapshot document = snapshot.data.documents[
                 index];
                 return VideoItem(document: document);

               },
              itemCount: snapshot.data.documents.length,
              );


          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
    );
  }
}
