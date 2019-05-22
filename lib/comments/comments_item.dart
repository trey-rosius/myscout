import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
class CommentsItem extends StatelessWidget {
  CommentsItem({this.document,this.userId,this.postAdminId});
  final DocumentSnapshot document;
  final String userId;
  final String postAdminId;

  Future<Null> deleteConfirmation(BuildContext context,String commentsId) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: Container(
                height: 120.0,

                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Are you sure you want to delete this comment?",style: TextStyle(
                          color: Colors.white,fontSize: 18.0
                      ),),
                    )
                  ],
                )
            ),
            actions: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "No",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();


                    // checkUserType();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "Yes",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {

                    Navigator.of(context).pop();
                    Firestore.instance.collection(Config.posts).document(document[Config.postId]).collection(Config.comments).document(commentsId).delete();



                    // checkUserType();
                  },
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        if(userId ==  document[Config.commentAdminId] || userId ==  document[Config.postAdminId])
        {
          deleteConfirmation(context, document[Config.commentId]);
        }
        else
        {

        }
      },
      child: Container(
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
      ),
    );
  }
}
