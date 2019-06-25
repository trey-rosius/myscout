import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/gallery/photo_item.dart';
import 'package:myscout/screens/gallery/photo_item_scroller.dart';
import 'package:myscout/screens/trade_card/trade_screen.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedCardDetails extends StatefulWidget {
  AcceptedCardDetails({this.cardId,this.cardName,this.userId});
  final String cardId;
  final String cardName;
  final String userId;





  @override
  _AcceptedCardDetailsState createState() => _AcceptedCardDetailsState();
}



class _AcceptedCardDetailsState extends State<AcceptedCardDetails> {


  @override
  void initState() {
    // TODO: implement initState

   // getUserId();
    super.initState();
  }


  bool isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    if(size.width < 412)
    {
      isLargeScreen = false;
    }
    else
    {
      isLargeScreen = true;
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(widget.cardName,maxLines: 1,style: TextStyle(fontSize: 20.0,color: Colors.white),),
          centerTitle: true,

        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection(Config.cards)
                .document(widget.cardId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> document) {
              if (document.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[

                    SliverToBoxAdapter(
                      child:  Stack(

                        children: <Widget>[
                          Container(
                            height: size.height/5,
                            color:Theme.of(context).primaryColor ,
                          ),
                          Center(
                            child: Container(

                              height: 400,
                              width: 300,


                              child:AspectRatio(

                                aspectRatio: 2/2.7,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: document.data[Config.cardImageUrl],
                                  placeholder: (context,url) => SpinKitWave(
                                    itemBuilder: (_, int index) {
                                      return DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      );
                                    },
                                  ),


                                  errorWidget: (context,url,error) =>Icon(Icons.error),
                                ),
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),


                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0,left: 10.0),
                        child: Row(


                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(

                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("POSITION", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(document.data[Config.position]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("HEIGHT", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(document.data[Config.height]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),




                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0,left: 10.0),
                        child: Row(


                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(

                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("WEIGHT", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(document.data[Config.weight]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("CLASS", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(document.data[Config.CLASS]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),




                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0,left: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,

                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0,right: 5.0),
                                    child: Text("HOMETOWN", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),
                                  ),


                                  Text(document.data[Config.location]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("HIGH SCHOOL", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(document.data[Config.schoolOrOrg]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),




                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("BIO",style: TextStyle(

                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),),
                    SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(document.data[Config.shortBio]??""),
                        )
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                              width: size.width / 1.5,
                              //  color: Theme.of(context).primaryColor,

                              child:
    StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance
        .collection(Config.users)
        .document(widget.userId)
        .collection(Config.myCards)
        .document(document.data[Config.cardId])
        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<DocumentSnapshot> docSnap) {
      if (docSnap.hasData && docSnap.data.exists) {
       return RaisedButton(
          elevation: 0.0,
          onPressed: () {
            Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.following).document(document.data[Config.cardCreatorId]).delete();
            Firestore.instance.collection(Config.users).document(document.data[Config.cardCreatorId]).collection(Config.followers).document(widget.userId).delete();

            Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).document(document.data[Config.cardId]).delete();




          },
          color: Theme.of(context).accentColor,
          child: new Padding(
            padding: const EdgeInsets.all(18.0),
            child: new Text("Trade Accepted",
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600)),
          ),
        );

      } else
        {
         return RaisedButton(
            elevation: 0.0,
            onPressed: () {
              Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.following).document(document.data[Config.cardCreatorId])
                  .setData({Config.userId:document.data[Config.cardCreatorId] }).then((_){
                Firestore.instance.collection(Config.users).document(document.data[Config.cardCreatorId]).collection(Config.followers).document(widget.userId)
                    .setData({Config.userId:widget.userId});

                Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.myCards).document(document.data[Config.cardId])
                    .setData({
                  Config.cardId:document.data[Config.cardId],
                  Config.cardCreatorId: document.data[Config.cardCreatorId],
                });

              });

              Map notific = Map<String,dynamic>();
              notific[Config.notificationType] =Config.tradeAccepted;
              notific[Config.cardId] = document.data[Config.cardId];
              notific[Config.senderId] = widget.userId;
              notific[Config.receiverId] = document.data[Config.cardCreatorId];
              notific[Config.cardName] = document.data[Config.fullNames];
              notific[Config.createdOn] = FieldValue.serverTimestamp();
              notific[Config.notificationText] = Config.tradeAcceptedText;

              Firestore.instance.collection(Config.notifications).add(notific).then((DocumentReference docRef){
                Firestore.instance.collection(Config.notifications).document(docRef.documentID).updateData({Config.notificationId:docRef.documentID}).then((_){


                });

              });
            },
            color: Theme.of(context).primaryColorLight,
            child: new Padding(
              padding: const EdgeInsets.all(18.0),
              child: new Text("Accept Trade Card",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
            ),
          );
        }
    })


                            ),

                          ],
                        ),
                      ),
                    )




                  ],
                );
              }

              else {

                return  Center(
                  child: Container(
                    child: Text("Loading .."),

                  ),
                );

              }
            })
    );
  }
}
