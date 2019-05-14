import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/post/post_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  PostScreen({this.userId});
  final String userId;
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isLargeScreen = false;
/*
  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }
*/

  @override
  void initState() {
    // TODO: implement initState

   // getUserId();
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

        title:Text("Social Feed",style: TextStyle(fontSize: 20.0),),

      ),
      body:
      Container(
        color: Theme.of(context).primaryColor,
        child: StreamBuilder(
          stream: Firestore.instance.collection(Config.posts).where(Config.isVideoPost,isEqualTo: false).orderBy(Config.createdOn,descending: true).snapshots(),
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
                        return PostItem(document: document,size:size,isLargeScreen:isLargeScreen,userId:widget.userId);
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
