import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/notifications/notification_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NotificationScreen extends StatefulWidget {
  NotificationScreen({this.userId});
  final String userId;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      body: Container(

        child: StreamBuilder(
          stream: Firestore.instance.collection(Config.notifications).where(Config.receiverId,isEqualTo: widget.userId).snapshots(),
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
