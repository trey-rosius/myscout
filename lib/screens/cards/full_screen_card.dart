import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/utils/Config.dart';

class FullScreenCard extends StatefulWidget {
  FullScreenCard({this.document});
  final DocumentSnapshot document;

  @override
  _FullScreenCardState createState() => _FullScreenCardState();
}

class _FullScreenCardState extends State<FullScreenCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection(Config.cards)
                    .document(widget.document[Config.cardId])
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> docs) {
                  if (docs.data != null) {
                    return docs.data[Config.userType] == Config.coachScout
                        ? InkWell(
                            onTap: () {},
                            child: Container(
                              height: 400,
                              width: 300,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: AspectRatio(
                                        aspectRatio: 2 / 2.3,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              docs.data[Config.profilePicUrl],
                                          placeholder: (context, url) =>
                                              SpinKitWave(
                                                itemBuilder: (_, int index) {
                                                  return DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  );
                                                },
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 330,
                                    height: 100,
                                    margin: EdgeInsets.fromLTRB(10, 330, 10, 0),
                                    color: Color(
                                        int.parse(docs.data[Config.cardColor])),
                                  ),
                                  Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 330, 10, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(docs.data[Config.fullNames],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  docs.data[Config.schoolOrOrg],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                              Text(
                                                  " - " +
                                                      docs.data[Config.title],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Image.asset(
                                    'assets/images/card_coach.png',
                                    height: 400,
                                    width: 300,
                                  )),
                                ],
                              ),
                            ))
                        : InkWell(
                            onTap: () {},
                            child: Container(
                              color: Color(
                                  int.parse(docs.data[Config.cardColor])),

                              height: 400,
                              width: 290  ,

                              child: Stack(
                                children: <Widget>[
                                  Container(
                                   margin: EdgeInsets.only(
                                        left: 40),
                                    child: AspectRatio(
                                      aspectRatio: 1.4 / 1.82,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            docs.data[Config.profilePicUrl],
                                        placeholder: (context, url) =>
                                            SpinKitWave(
                                              itemBuilder: (_, int index) {
                                                return DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                );
                                              },
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Container(
                                        margin: EdgeInsets.fromLTRB(80, 0, 0, 10),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "HEIGHT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              docs.data[Config.height],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "WEIGHT",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              docs.data[Config.weight],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(

                                            child: Text(
                                              "lbs",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Container(
                                      margin: EdgeInsets.only(left:90,top: 340),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: <Widget>[
                                          Text(
                                            docs.data[Config.fullNames],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                         Container(

                                           margin: EdgeInsets.only(top: 5,right: 20),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    docs.data[
                                                        Config.schoolOrOrg],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  " . #" +
                                                      docs.data[
                                                          Config.jerseyNumber],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  docs.data[Config.position],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                  Container(




                                      child: Image.asset(
                                    'assets/images/card_athlete.png',
                                        height: 400,
                                        width: 300,
                                  )),
                                  Container(
                                    margin: EdgeInsets.only(left:10,top: 340),
                                    child:
                                    Text(

                                      docs.data[Config.CLASS].toLowerCase() == Config.freshMan ? "FR":docs.data[Config.CLASS].toLowerCase() == Config.senior ? "SR" : "JR" ,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF998e6f)),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                  } else {
                    return Container();
                  }
                })),
      ),
    );
  }
}
