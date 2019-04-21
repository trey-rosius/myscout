import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myscout/screens/chats/chat_screen.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
class ConversationListItem extends StatelessWidget {
  ConversationListItem({this.userId,this.document});
  final String userId;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection(Config.users)
            .document(document[Config.userId])
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> docSnap) {
          if (docSnap.hasData)
          {

            return InkWell(
              onTap: (){

                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          senderId: userId,
                          receiverId: document[Config.userId],

                        ),
                      ));

              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),

                child: Card(
                  elevation: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                            imageUrl: docSnap.data[Config.profilePicUrl],
                            placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                            errorWidget: (context, url, ex) => new Icon(Icons.error),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right:3.0),
                              child: Text(docSnap.data[Config.fullNames],style: TextStyle(fontSize: 17.0,fontWeight:FontWeight.bold,color: Theme.of(context).primaryColor),),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top:2.0),
                              child: Text(document[Config.createdOn] == null
                                  ? ""
                                  :
                              timeago.format(DateTime.fromMillisecondsSinceEpoch(
                                  document[Config.createdOn].millisecondsSinceEpoch)),
                              ),
                            ),

                          ],
                        ),
                      )






                    ],
                  ),
                ),
              ),
            );
          }
          else
          {
            return Container();
          }
        });



  }
}
