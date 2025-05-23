import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/post/post_item.dart';
import 'package:myscout/screens/awards/award_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AwardsScreen extends StatefulWidget {
  @override
  _AwardsScreenState createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  bool isLargeScreen = false;

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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(size.width < 412)
    {
      isLargeScreen = false;
    }
    else
    {
      isLargeScreen = true;
    }
    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Awards",style: TextStyle(fontSize: 20.0),),

      ),
      body:
      Container(

        child: StreamBuilder(
          stream: Firestore.instance.collection(Config.posts).where(Config.isVideoPost,isEqualTo: false).where(Config.isAward,isEqualTo: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingScreen();

            } else if (snapshot.hasData) {
              return  ListView.builder(

                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, int index)
                  {
                    final DocumentSnapshot document = snapshot.data.documents[
                    index];
                    return AwardItem(document: document,size:size,isLargeScreen:isLargeScreen,userId:userId);
                  });



            } else {
              return  ErrorScreen(error: snapshot.error.toString(),
              );
            }
          },
        ),
      ),
    );
  }
}
