import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
class CommentsItem extends StatelessWidget {
  CommentsItem({this.document});
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
        .collection(Config.users)
        .document(document[Config.commentAdminId])
        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<DocumentSnapshot> docSnap) {
    if (docSnap.hasData)
    {



    return Container(

      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Container(
         child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: ClipRRect(
                 borderRadius: new BorderRadius.circular(50),
                 child: CachedNetworkImage(
                   width: 40.0,
                   height: 40.0,
                   fit: BoxFit.cover,
                   imageUrl: docSnap.data[Config.profilePicUrl],
                   placeholder: (context, url) =>
                   new CircularProgressIndicator(),
                   errorWidget: (context, url, ex) => new Icon(Icons.error),
                 ),
               ),
             ),
             Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[

      Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: Text(docSnap.data[Config.fullNames],style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),),
      ),

     Text(document[Config.commentText],style: TextStyle(fontSize: 15.0,color: Theme.of(context).primaryColor),),

      Padding(
        padding: const EdgeInsets.only(top:5.0,bottom: 10.0),
        child: Text(document[Config.createdOn] == null
            ? ""
            :
        timeago.format(DateTime.fromMillisecondsSinceEpoch(
            document[Config.createdOn].millisecondsSinceEpoch)),style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColorLight),
        ),
      )
           ],
         ),



           ],
         ),
      ),
    );

    } else
      {
        return Container();
      }

        })
    );
  }
}
