import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/profile/external_profile_screen.dart';
import 'package:myscout/utils/Config.dart';

class SportsItem extends StatelessWidget {
  SportsItem({this.document,this.userId});
  final String userId;

  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: userId == document[Config.userId] ?Container():
      InkWell(
        onTap: (){
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>ExternalProfileScreen(userId: document[Config.userId],)
              ));
        },
        child:   Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(50),
                child: CachedNetworkImage(
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                  imageUrl: document[Config.profilePicUrl]??"",
                  placeholder: (context, url) =>
                  new CircularProgressIndicator(),
                  errorWidget: (context, url, ex) => new Icon(Icons.error),
                ),
              ),
            ),

            Expanded(
              child:  Padding(
                padding: const EdgeInsets.only(right:3.0),
                child: Text(document[Config.fullNames]??"",style: TextStyle(fontSize: 17.0,fontWeight:FontWeight.bold,color: Theme.of(context).primaryColor),),
              ),
            )
          ],
        ),
      )


    );
  }
}
