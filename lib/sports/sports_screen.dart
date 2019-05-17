import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/categories/category_data.dart';
import 'package:myscout/screens/categories/category_item.dart';
import 'package:myscout/sports/sports_item.dart';
import 'package:myscout/utils/Config.dart';

class SportScreen extends StatefulWidget {
     SportScreen({this.item,this.userId});
     final Category item;
     final String userId;
  @override
  _SportScreenState createState() => _SportScreenState();
}


class _SportScreenState extends State<SportScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.item.name);
    print("user id is " +widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.item.name),
      ),
      body: StreamBuilder(
         stream: Firestore.instance.collection(Config.users).where(Config.selectSport, isEqualTo: widget.item.name).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
           if(snapshot.hasData)
             {
               print(snapshot.data.documents);
               return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                   itemBuilder: (context,index){
                     DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                     return SportsItem(document: documentSnapshot,userId:widget.userId);

               });
             } else
               {
                 return Container();
               }

      }),
    );
  }
}
