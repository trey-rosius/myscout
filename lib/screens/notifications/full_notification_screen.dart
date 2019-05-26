import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/notifications/notification_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FullNotificationScreen extends StatefulWidget {
  FullNotificationScreen({this.userId});
  final String userId;
  @override
  _FullNotificationScreenState createState() => _FullNotificationScreenState();
}

class _FullNotificationScreenState extends State<FullNotificationScreen> {
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
    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Notifications",style: TextStyle(fontSize: 20.0),),


      ),
      body: Container(

        child: StreamBuilder(
          stream: Firestore.instance.collection(Config.notifications).where(Config.receiverId,isEqualTo: widget.userId).orderBy(Config.createdOn,descending: true).snapshots(),
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
                    return NotificationItem(document: document,userId:widget.userId);
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
