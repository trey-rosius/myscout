import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/post/user_external_post_screen.dart';
import 'package:myscout/post/user_post_screen.dart';
import 'package:myscout/screens/chats/chat_screen.dart';
import 'package:myscout/screens/followers/followers_item.dart';
import 'package:myscout/screens/following/following_item.dart';
import 'package:myscout/screens/stats/soccer_screen.dart';
import 'package:myscout/screens/stats_external/baseball__external_screen.dart';
import 'package:myscout/screens/stats_external/basketball_external_screen.dart';
import 'package:myscout/screens/stats_external/coaching_external_screen.dart';
import 'package:myscout/screens/stats_external/soccer_external_screen.dart';
import 'package:myscout/screens/stats_external/stats_external_screen.dart';
import 'package:myscout/screens/stats_external/tennis_external_screen.dart';

import 'package:myscout/screens/trade_card/trade_screen.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CardDetails extends StatefulWidget {
  CardDetails({this.cardId,this.cardName,this.cardCreator});
  final String cardId;
  final String cardName;
  final String cardCreator;





  @override
  _CardDetailsState createState() => _CardDetailsState();
}



class _CardDetailsState extends State<CardDetails> {

  String userId;
  String userType;


  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
      userType = sharedPreferences.get(Config.userType);
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    print("Card Creator Id "+widget.cardCreator);
    getUserId();
    super.initState();
  }



  bool isLargeScreen = false;
  bool isSmallScreen = false;
  bool  isMediumScreen = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    if(size.width < 400)
    {
      isMediumScreen = false;
      isLargeScreen = false;
      isSmallScreen = true;

    }
    else if(size.width >400 && size.width <412)
    {
      isMediumScreen = true;
      isLargeScreen = false;
      isSmallScreen = false;
    } else{
      isMediumScreen = false;
      isLargeScreen = true;
      isSmallScreen = false;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.cardName,maxLines: 1,style: TextStyle(fontSize: 20.0,color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[

          StreamBuilder(
            stream: Firestore.instance.collection(Config.users).document(widget.cardCreator).collection(Config.followers).document(userId).snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
              if(snapshot.hasData && snapshot.data.exists)
                {
                   return StreamBuilder(
                       stream: Firestore.instance.collection(Config.users).document(widget.cardCreator).collection(Config.following).document(userId).snapshots(),
                       builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
                         if(snapshot.hasData && snapshot.data.exists){
                           return InkWell(
                             onTap: (){
                               Navigator.push(
                                   context,
                                   new MaterialPageRoute(
                                     builder: (context) => ChatScreen(senderId: userId,receiverId: widget.cardCreator,),
                                   ));
                             },
                             child: Image.asset('assets/images/chat.png'),
                           );
                         } else
                         {

                           return Container();

                         }
                       });
                }
                else
                  {
                    return Container();
                  }


            },
          )



        ],

      ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection(Config.cards)
                .document(widget.cardId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> document) {
              if (document.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[


                     Stack(

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

 Container(
   padding: EdgeInsets.all(10),
   child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: <Widget>[
       Container(
       width: size.width/3.5,
         height: size.height/10,
         child: RaisedButton(

           onPressed: (){
             if(document.data[Config.userType] == Config.athleteOrParent)
             {
               if(document.data[Config.selectSport]  == "BasketBall")
               {

                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) =>  BasketBallExternalScreen(
                         userId: document.data[Config.cardCreatorId],
                       ),
                     ));


               } else if((document.data[Config.selectSport] == "FootBall"))
               {

                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) =>  StatExternalScreen(
                         userId: document.data[Config.cardCreatorId],
                       ),
                     ));

               } else if((document.data[Config.selectSport] == "Soccer")){


                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) =>  SoccerExternalScreen(
                         userId: document.data[Config.cardCreatorId],
                       ),
                     ));

               } else if((document.data[Config.selectSport] == "Tennis"))
               {

                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) =>  TennisExternalScreen(
                         userId: document.data[Config.cardCreatorId],
                       ),
                     ));

               }else{


                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) =>  BaseBallExternalScreen(
                         userId: document.data[Config.cardCreatorId],
                       ),
                     ));

               }


             } else
             {


               Navigator.push(
                   context,
                   new MaterialPageRoute(
                     builder: (context) =>  CoachingExternalScreen(
                       userId: document.data[Config.cardCreatorId],
                     ),
                   ));

             }
           },
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           color: Theme.of(context).accentColor,
           child: Text("Stats",style: TextStyle(fontSize: 20,color: Colors.white),),
         ),
       ),
       Container(

         width: size.width/3,
         height: size.height/10,
         child: RaisedButton(
           shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
           onPressed: (){
             userId == document.data[Config.cardCreatorId] ?
             Navigator.push(
                 context,
                 new MaterialPageRoute(
                   builder: (context) =>  UserPostScreen(
                     userId: document.data[Config.cardCreatorId],
                   ),
                 )) : Navigator.push(
                 context,
                 new MaterialPageRoute(
                   builder: (context) =>  UserExternalPostScreen(
                     userId: document.data[Config.cardCreatorId],
                      visitorId: userId,
                   ),
                 ));
         },
           color: Theme.of(context).accentColor,
          child: Text("Posts",style: TextStyle(fontSize: 20,color: Colors.white),),
       )

   ),
   ]
   )
 ),


 Container(
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
                     Container(
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
                       Container(
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
                                      child: Text("ORGANIZATION", style: TextStyle(

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

                       Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("BIO",style: TextStyle(

                            fontFamily: 'Montserrat',
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)),
                      ),
                         Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(document.data[Config.shortBio]??""),
                        ),
                     Padding(
                       padding:  EdgeInsets.all(10.0),
                       child: Text("TRADED CARDS",style: TextStyle(

                           fontFamily: 'Montserrat',
                           color: Theme.of(context).primaryColor,
                           fontWeight: FontWeight.bold,
                           fontSize: 18.0)),

                     ),
                     StreamBuilder(
                       stream: Firestore.instance.collection(Config.users).document(document.data[Config.cardCreatorId]).collection(Config.following).snapshots(),
                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                         if (!snapshot.hasData) {
                           return LoadingScreen();
                         } else if (snapshot.hasData) {
                           return Container(
                             height: size.height/6,
                             child: ListView.builder(
                                 scrollDirection: Axis.horizontal,
                                 itemCount: snapshot.data.documents.length,
                                 itemBuilder: (_, int index)
                                 {
                                   final DocumentSnapshot document = snapshot.data.documents[
                                   index];
                                   return FollowingItem(document: document,userId: document[Config.userId]);
                                 }),
                           );

                         } else {
                           return ErrorScreen(error: snapshot.error.toString());
                         }
                       },
                     ),
                     Padding(
                       padding:  EdgeInsets.all(10.0),
                       child: Text("COLLECTED CARDS",style: TextStyle(

                           fontFamily: 'Montserrat',
                           color: Theme.of(context).primaryColor,
                           fontWeight: FontWeight.bold,
                           fontSize: 18.0)),

                     ),
                     StreamBuilder(
                       stream: Firestore.instance.collection(Config.users).document(document.data[Config.cardCreatorId]).collection(Config.myCards).where(Config.collected,isEqualTo: true).snapshots(),
                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                         if (!snapshot.hasData) {
                           return LoadingScreen();
                         } else if (snapshot.hasData) {
                           return Container(
                             height: size.height/6,
                             child: ListView.builder(
                                 scrollDirection: Axis.horizontal,
                                 itemCount: snapshot.data.documents.length,
                                 itemBuilder: (_, int index)
                                 {
                                   final DocumentSnapshot document = snapshot.data.documents[
                                   index];
                                   return FollowersItem(document: document,userId: document[Config.cardCreatorId]);
                                 }),
                           );

                         } else {
                           return ErrorScreen(error: snapshot.error.toString());
                         }
                       },
                     ),
                     Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              userType == Config.fan ? Container() :
                              userId == document.data[Config.cardCreatorId] ? Container(
                                padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                                width: size.width / 2.3,
                                //  color: Theme.of(context).primaryColor,

                                child: RaisedButton(
                                  elevation: 0.0,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TradeScreen(userId: userId,cardName: widget.cardName,cardId: document.data[Config.cardId],)),
                                    );
                                  },
                                  color: Theme.of(context).primaryColorLight,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: new Text("Trade Card",
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ) :Container(),
                              userId == document.data[Config.cardCreatorId]? Container() :  StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance
        .collection(Config.users)
        .document(userId)
        .collection(Config.myCards)
        .document(document.data[Config.cardId])
        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<DocumentSnapshot> docSnap) {
    if (docSnap.hasData && docSnap.data.exists) {
     return Container(
        padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

        width: size.width / 1.5,
        //  color: Theme.of(context).primaryColor,

        child: RaisedButton(
          elevation: 0.0,
          onPressed: () {

            int count = document.data[Config.collectedCount] -1;
            Firestore.instance.collection(Config.cards).document(document.data[Config.cardId])
                  .updateData({
              Config.collectedCount:count
            }).then((_){
              Firestore.instance.collection(Config.users).document(userId).collection(Config.myCards)
                    .document(document.data[Config.cardId])
                    .delete();
            });



          },
          color: Theme.of(context).primaryColorLight,
          child: new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Text("UnCollect Card",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600)),
          ),
        ),
      );

    } else
      {
       return Container(
          padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

          width: size.width / 1.5,
          //  color: Theme.of(context).primaryColor,

          child: RaisedButton(
            elevation: 0.0,
            onPressed: () {

              int count = document.data[Config.collectedCount] +1;
              Firestore.instance.collection(Config.cards).document(document.data[Config.cardId])
                    .updateData({
                  Config.collectedCount:count
              }).then((_){
                  Firestore.instance.collection(Config.users).document(userId).collection(Config.myCards)
                      .document(document.data[Config.cardId])
                      .setData({
                    Config.cardCreatorId: document.data[Config.cardCreatorId],
                    Config.cardId:document.data[Config.cardId],
                    Config.collected:true



                  });
              });


              Map notific = Map<String,dynamic>();
              notific[Config.notificationType] =Config.cardCollected;
              notific[Config.cardId] = document.data[Config.cardId];
              notific[Config.senderId] = userId;
              notific[Config.receiverId] = document.data[Config.cardCreatorId];
              notific[Config.cardName] = document.data[Config.fullNames];
              notific[Config.createdOn] = FieldValue.serverTimestamp();
              notific[Config.notificationText] = Config.collectedText;

              Firestore.instance.collection(Config.notifications).add(notific).then((DocumentReference docRef){
                  Firestore.instance.collection(Config.notifications).document(docRef.documentID).updateData({Config.notificationId:docRef.documentID}).then((_){


                  });

              });


            },
            color: Theme.of(context).accentColor,
            child: new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Text("Collect Card",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600)),
            ),
          ),
        );
      }
    })


                            ],
                          ),
                        ),





                    ],
                  ),
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
