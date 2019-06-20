import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/chats/chat_screen.dart';

import 'package:myscout/screens/trade_card/trade_screen.dart';
import 'package:myscout/utils/Config.dart';

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
          userId == widget.cardCreator ? Container():
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => ChatScreen(senderId: userId,receiverId: widget.cardCreator,),
                  ));
            },
            child: Image.asset('assets/images/chat.png'),
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

            int count = document.data[Config.collectedCount] +1;
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
