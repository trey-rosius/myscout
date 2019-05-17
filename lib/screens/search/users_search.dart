import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/categories/category_data.dart';
import 'package:myscout/screens/categories/category_item.dart';
import 'package:myscout/sports/sports_item.dart';
import 'package:myscout/utils/Config.dart';

class UsersScreen extends StatefulWidget {
  UsersScreen({this.userId,this.searchString});

  final String userId;
  final String searchString;
  @override
  _UsersScreenState createState() => _UsersScreenState();
}


class _UsersScreenState extends State<UsersScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("user id is " +widget.userId);
    print("search String " +widget.searchString);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
          stream: Firestore.instance.collection(Config.users).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData)
            {
              print(snapshot.data.documents);
              return


                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                    return documentSnapshot[Config.fullNames]
                        .toLowerCase()
                        .contains(widget.searchString.toLowerCase()) ?

                      SportsItem(document: documentSnapshot,userId:widget.userId) :Container();

                  });
            } else
            {
              return Container();
            }

          }),
    );
  }
}
