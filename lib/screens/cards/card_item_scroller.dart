import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/cards/card_details.dart';
import 'package:myscout/screens/cards/full_screen_card.dart';
import 'package:myscout/utils/Config.dart';

class CardItemScroller extends StatelessWidget {
  CardItemScroller({this.document});
  final DocumentSnapshot document;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection(Config.cards).document(document[Config.cardId]).snapshots(),
          builder: (context,AsyncSnapshot<DocumentSnapshot> docs){
            if(docs.data !=null)
              {
                return docs.data[Config.cardImageUrl] ==null ?Container(): InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames],cardCreator: docs.data[Config.cardCreatorId] ,),
                           // builder: (context) => FullScreenCard(document: document,),
                          ));
                    },
                    child: Padding(
                              padding: const EdgeInsets.only(left:5.0,right:4.0),
                              child:AspectRatio(
                                aspectRatio: 2/2.7,
                                child: CachedNetworkImage(

                                  fit: BoxFit.cover,
                                  imageUrl: docs.data[Config.cardImageUrl]??"",
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






                );


              }
              else
                {
                  return Container();
                }

      });

  }
}
