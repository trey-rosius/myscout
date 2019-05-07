import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/cards/card_details.dart';
import 'package:myscout/utils/Config.dart';

class CardItemScroller extends StatelessWidget {
  CardItemScroller({this.document,this.isLargeScreen});
  final DocumentSnapshot document;
  final bool isLargeScreen;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection(Config.cards).document(document[Config.cardId]).snapshots(),
          builder: (context,AsyncSnapshot<DocumentSnapshot> docs){
            if(docs.data !=null)
              {
                return InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames],isLargeScreen: isLargeScreen,),
                          ));
                    },
                    child:
                 Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          color: Color(int.parse(docs.data[Config.cardColor])),
                          child: Image.asset('assets/images/card_athlete.png',height: 350,)),
                      Positioned(
                        top: 7,
                        left:  40,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right:5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: CachedNetworkImage(
                              height: 200,
                              width: 135 ,
                              fit: BoxFit.cover,
                              imageUrl: docs.data[Config.profilePicUrl],
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
                      Positioned(
                          top: isLargeScreen ? 30 :30.0,
                          left: size.width/60,
                          child: RotatedBox(quarterTurns: 1,child: Stack(
                            children: <Widget>[
                              Container(
                                height: 38.0,
                                width: 168.0,
                                padding: EdgeInsets.all(10),
                                color: Color(int.parse(docs.data[Config.cardColor])),
                                // child: Text(document[Config.cardColor]),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0,left: 2.0),
                                child: Row(

                                  children: <Widget>[
                                    Container(

                                      padding: EdgeInsets.all(4),
                                      child: Text("HEIGHT",style: TextStyle(fontSize: 10.0,color: Colors.white),),
                                    ),
                                    Container(

                                      padding: EdgeInsets.all(2),
                                      child: Text(docs.data[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10.0,color: Colors.white),),
                                    ),
                                    Container(

                                      padding: EdgeInsets.all(4),
                                      child: Text("WEIGHT",style: TextStyle(fontSize: 10.0,color: Colors.white),),
                                    ),
                                    Container(

                                      padding: EdgeInsets.all(4),
                                      child: Text(docs.data[Config.weight],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10.0,color: Colors.white),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),)
                      ),

                      Positioned(
                          top: isLargeScreen ? size.height/4.35 : size.height/3.3,
                          left: size.width/8.1,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 45.0,
                                width: 128.0,
                                padding: EdgeInsets.all(10),
                                color: Color(int.parse(docs.data[Config.cardColor])),
                                // child: Text(document[Config.cardColor]),
                              ),
                              Container(
                                width: 150.0,
                                padding: EdgeInsets.all(4),
                                child: Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: Colors.white),),
                              ),
                            ],
                          )
                      )
                    ],
                  ),)
                );
              }
              else
                {
                  return Container();
                }

      });

  }
}
