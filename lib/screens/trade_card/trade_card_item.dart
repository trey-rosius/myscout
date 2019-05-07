import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/utils/Config.dart';
class TradeCardItem extends StatelessWidget {
  TradeCardItem({this.document,this.userId,this.cardName,this.cardId});
  final DocumentSnapshot document;
  final String userId;
  final String cardName;
  final String cardId;

  @override
  Widget build(BuildContext context) {
    return document[Config.userId] == userId ? Container(): Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Container(
                      child:
                      CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<
                            Color>(
                            Theme.of(context)
                                .accentColor),
                      ),
                      width: 50.0,
                      height: 50.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                        BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                imageUrl: document[
                Config.profilePicUrl],
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(30.0)),
              clipBehavior: Clip.hardEdge,
            ),
            title: Text(document[Config.fullNames],style: TextStyle(fontSize: 18),),
            trailing:
    StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance
        .collection(Config.users)
        .document(userId)
        .collection(Config.following)
        .document(document[Config.userId])
        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<DocumentSnapshot> docSnap) {
    if (docSnap.hasData && docSnap.data.exists) {
     return RaisedButton(
        color: Theme.of(context).accentColor,

        onPressed: (){
          /*
          Firestore.instance.collection(Config.users).document(userId).collection(Config.following).document(document[Config.userId])
              .setData({Config.userId:document[Config.userId] }).then((_){
            Firestore.instance.collection(Config.users).document(document[Config.userId]).collection(Config.followers).document(userId)
                .setData({Config.userId:userId});
          });
          */

        },
        child: Text("Traded",style: TextStyle(color: Colors.white,fontSize: 15),),);


    }else{
      return RaisedButton(
        color: Theme.of(context).primaryColorLight,

        onPressed: (){

          Firestore.instance.collection(Config.users).document(userId).collection(Config.following).document(document[Config.userId])
              .setData({Config.userId:document[Config.userId] }).then((_){
            Firestore.instance.collection(Config.users).document(document[Config.userId]).collection(Config.followers).document(userId)
                .setData({Config.userId:userId});

          });

          Map notific = Map<String,dynamic>();
          notific[Config.notificationType] =Config.acceptTrade;
          notific[Config.cardId] = cardId;
          notific[Config.senderId] = userId;
          notific[Config.receiverId] = document[Config.userId];
          notific[Config.cardName] = cardName;
          notific[Config.createdOn] = FieldValue.serverTimestamp();
          notific[Config.notificationText] = Config.tradeText;

          Firestore.instance.collection(Config.notifications).add(notific).then((DocumentReference docRef){
            Firestore.instance.collection(Config.notifications).document(docRef.documentID).updateData({Config.notificationId:docRef.documentID}).then((_){


            });

          });

        },
        child: Text("Trade",style: TextStyle(color: Colors.white,fontSize: 15),),);

    }
    })

          ),
          Padding(
            padding: const EdgeInsets.only(left:80.0),
            child: Divider(color: Theme.of(context).primaryColor,),
          )
        ],
      ),
    );
  }
}
