import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/cards/card_details.dart';
import 'package:myscout/utils/Config.dart';

class PlayerItem extends StatelessWidget {
  PlayerItem({this.document});
  final DocumentSnapshot document;

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
                        builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames]),
                      ));
                },
                child:
                Container(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          color: Color(int.parse(docs.data[Config.cardColor])),
                          child: Image.asset('assets/images/card_athlete.png',)),
                      Positioned(
                        top: isSmallScreen ?5 :isMediumScreen ?6 :7,
                        left:isSmallScreen ?33 :isMediumScreen ? 37 :40,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right:5.0),
                          child:CachedNetworkImage(
                            height: isSmallScreen ? 165 : isMediumScreen ? 190 : 200,
                            width: isSmallScreen ?113 :isMediumScreen ? 135 :135,
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
                      Positioned(
                        top: isLargeScreen ? 30 :30.0,
                        left: isLargeScreen ?size.width/30 :size.width/60,
                        child: RotatedBox(quarterTurns: 1,child:

                        Container(
                          margin: EdgeInsets.only(top: 10.0,left: 2.0),
                          child: Row(

                            children: <Widget>[
                              Container(

                                padding: EdgeInsets.all(2),
                                child: Text("HEIGHT",style: TextStyle(fontSize:isLargeScreen? 12: 10.0,color: Colors.white),),
                              ),
                              Container(

                                padding: EdgeInsets.all(2),
                                child: Text(docs.data[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: isLargeScreen? 12: 10.0,color: Colors.white),),
                              ),
                              Container(

                                padding: EdgeInsets.all(2),
                                child: Text("WEIGHT",style: TextStyle(fontSize: isLargeScreen? 12: 10.0,color: Colors.white),),
                              ),
                              Container(

                                padding: EdgeInsets.all(2),
                                child: Text(docs.data[Config.weight],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:isLargeScreen? 12: 10.0,color: Colors.white),),
                              ),
                            ],
                          ),
                        ),

                        ),
                      ),
                      Positioned(
                        top: isLargeScreen ? size.height/4.3 : size.height/3.3,
                        left: isLargeScreen ? size.width/8 : size.width/8.1,
                        child:
                        Container(
                          width: 100.0,

                          padding: EdgeInsets.all(4),
                          child: Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:  14.0,color: Colors.white),),
                        ),

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
