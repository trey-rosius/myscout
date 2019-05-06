import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/utils/Config.dart';

class CardItem extends StatelessWidget {
  CardItem({this.document});
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: <Widget>[
          Image.asset('assets/images/card_athlete.png',height: 350,),
          Positioned(
            top: 6,
            left: 55,
            child: Padding(
              padding: const EdgeInsets.only(left:5.0,right:5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                  height: 280,
                  width: 185,
                  fit: BoxFit.cover,
                  imageUrl: document[Config.profilePicUrl],
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
              top: 45.0,
              left: size.width/50,
              child: RotatedBox(quarterTurns: 1,child: Stack(
                children: <Widget>[
                  Container(
                    height: 53.0,
                    width: 228.0,
                    padding: EdgeInsets.all(10),
                    color: Color(int.parse(document[Config.cardColor])),
                    // child: Text(document[Config.cardColor]),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 10.0),
                    child: Row(

                      children: <Widget>[
                        Container(

                          padding: EdgeInsets.all(4),
                          child: Text("HEIGHT",style: TextStyle(fontSize: 16.0,color: Colors.white),),
                        ),
                        Container(

                          padding: EdgeInsets.all(4),
                          child: Text(document[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: Colors.white),),
                        ),
                        Container(

                          padding: EdgeInsets.all(4),
                          child: Text("WEIGHT",style: TextStyle(fontSize: 16.0,color: Colors.white),),
                        ),
                        Container(

                          padding: EdgeInsets.all(4),
                          child: Text(document[Config.weight],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),)
          ),

          Positioned(
              top: size.height/2.4,
              left: size.width/6,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 177.0,
                    padding: EdgeInsets.all(10),
                    color: Color(int.parse(document[Config.cardColor])),
                    // child: Text(document[Config.cardColor]),
                  ),
                  Container(
                    width: 150.0,
                    padding: EdgeInsets.all(4),
                    child: Text(document[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20.0,color: Colors.white),),
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}
