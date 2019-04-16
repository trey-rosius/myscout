import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
class AwardItem extends StatelessWidget {
  AwardItem({this.document, this.size, this.isLargeScreen, this.userId});
  final DocumentSnapshot document;
  final Size size;
  final bool isLargeScreen;
  final String userId;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(50),
                child: CachedNetworkImage(
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                  imageUrl: document[Config.postImageUrl],
                  placeholder: (context, url) =>
                  new CircularProgressIndicator(),
                  errorWidget: (context, url, ex) => new Icon(Icons.error),
                ),
              ),
            ),
            title: Text(document[Config.postText]),
            subtitle: Text(document[Config.awardYear],
            ),


          ),
          Padding(
            padding: EdgeInsets.only(left:size.width/3.5),
            child: Divider(color: Colors.grey,),
          )
        ],
      ),
    );
  }
}
