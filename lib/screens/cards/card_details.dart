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

class CardDetails extends StatefulWidget {
  CardDetails({this.cardId,this.cardName});
  final String cardId;
  final String cardName;





  @override
  _CardDetailsState createState() => _CardDetailsState();
}



class _CardDetailsState extends State<CardDetails> {

  String userId;


  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }


  @override
  void initState() {
    // TODO: implement initState

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
                      child: Stack(

                        children: <Widget>[
                          Container(
                            height: isLargeScreen ? size.height/4.5 : size.height/5,
                            width: size.width,
                            color: Theme.of(context).primaryColor,



                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: size.height/20),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                      color: Color(int.parse(document.data[Config.cardColor])),
                                      child: Image.asset('assets/images/card_athlete.png',height: 255,)),
                                  Positioned(
                                    top: isSmallScreen ?6 :isMediumScreen ?6 :6,
                                    left:isSmallScreen ?40 :isMediumScreen ? 37 :37,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left:5.0,right:5.0),
                                      child: CachedNetworkImage(
                                          height: isSmallScreen ? 193 : isMediumScreen ? 190 : 190,
                                          width: isSmallScreen ?133 :isMediumScreen ? 135 :135,
                                          fit: BoxFit.cover,
                                          imageUrl: document.data[Config.profilePicUrl],
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

                                  Positioned(
                                      top: 30.0,
                                      left: size.width/60,
                                      child: RotatedBox(quarterTurns: 1,child:
                                          Container(
                                            margin: EdgeInsets.only(top: 10.0,left: 2.0),
                                            child: Row(

                                              children: <Widget>[
                                                Container(

                                                  padding: EdgeInsets.all(4),
                                                  child: Text("HEIGHT",style: TextStyle(fontSize: 12.0,color: Colors.white),),
                                                ),
                                                Container(

                                                  padding: EdgeInsets.all(2),
                                                  child: Text(document.data[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12.0,color: Colors.white),),
                                                ),
                                                Container(

                                                  padding: EdgeInsets.all(4),
                                                  child: Text("WEIGHT",style: TextStyle(fontSize: 12.0,color: Colors.white),),
                                                ),
                                                Container(

                                                  padding: EdgeInsets.all(4),
                                                  child: Text(document.data[Config.weight],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12.0,color: Colors.white),),
                                                ),
                                              ],
                                            ),


                                      ),)
                                  ),

                                  Positioned(
                                    top: isSmallScreen ? size.height/2.8 :isMediumScreen ? size.height/3.3 : size.height/4.3,
                                    left: size.width/7,
                                      child:
                                          Container(
                                            width: isSmallScreen ? 140 :isMediumScreen ? 150 : 150,
                                            padding: EdgeInsets.all(4),
                                            child: Text(document.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                          ),

                                  )
                                ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
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
                                  padding: const EdgeInsets.all(18.0),
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

        width: size.width / 2,
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
            padding: const EdgeInsets.all(14.0),
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

          width: size.width / 2.3,
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
              padding: const EdgeInsets.all(14.0),
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
