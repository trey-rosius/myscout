import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/cards/card_details.dart';
import 'package:myscout/utils/Config.dart';

class CardItem extends StatelessWidget {
  CardItem({this.document});
  final DocumentSnapshot document;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);

    return  StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection(Config.cards).document(document[Config.cardId]).snapshots(),
        builder: (context,AsyncSnapshot<DocumentSnapshot> docs){
          if(docs.data !=null)
          {
            return document[Config.userType] == Config.coachScout ? InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames]),
                      ));
                },
                child:
                Container(

                  color: Color(int.parse(docs.data[Config.cardColor])),
                  margin: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[

                      Positioned(

                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right:5.0),
                          child:CachedNetworkImage(
                            height: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.getInstance().setHeight(400) :ScreenUtil.screenWidthDp >650 ?ScreenUtil.getInstance().setHeight(450) : ScreenUtil.getInstance().setHeight(520),
                            width: ScreenUtil.getInstance().setWidth(385),
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




                        Center(
                          child: Container(

                            margin: EdgeInsets.only(top:ScreenUtil.screenWidthDp>413? ScreenUtil.instance.setHeight(400) : ScreenUtil.instance.setHeight(500),left: 10),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(30) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(25) : ScreenUtil(allowFontScaling: true).setSp(36),color: Colors.white),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(docs.data[Config.schoolOrOrg],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(25) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(15) : ScreenUtil(allowFontScaling: true).setSp(22),color: Colors.white),),
                                    Text(" - "+docs.data[Config.title],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(25) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(15) : ScreenUtil(allowFontScaling: true).setSp(22),color: Colors.white),),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),



                      Container(

                          child: Image.asset('assets/images/card_coach.png')),
                    ],
                  ),)
            )
            :


              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames]),
                      ));
                },
                child:
                Container(
                  color: Color(int.parse(docs.data[Config.cardColor])),
                  margin: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[

                      Positioned(
                        left:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?  ScreenUtil.instance.setWidth(80) :ScreenUtil.screenWidthDp >650 ? ScreenUtil.instance.setWidth(60) : ScreenUtil.instance.setWidth(80),
                        child: CachedNetworkImage(
                            height:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil.getInstance().setHeight(420) : ScreenUtil.screenWidthDp >650 ? ScreenUtil.getInstance().setHeight(470) : ScreenUtil.getInstance().setHeight(550),
                            width:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.getInstance().setWidth(280) : ScreenUtil.screenWidthDp >650 ? ScreenUtil.getInstance().setWidth(190) : ScreenUtil.getInstance().setWidth(280),
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


                      Container(

                        child: Center(
                          child: RotatedBox(quarterTurns: 1,child:

                            Container(

                              margin: EdgeInsets.only(top:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.instance.setHeight(300) : ScreenUtil.screenWidthDp>650? ScreenUtil.instance.setHeight(300) : ScreenUtil.instance.setHeight(360),
                                  left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? 40 : ScreenUtil.screenWidthDp>650? 60 : 50),

                              child: Row(

                                children: <Widget>[
                                  Container(

                                    padding: EdgeInsets.all(2),
                                    child: Text("HEIGHT",style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                  ),
                                  Container(

                                    padding: EdgeInsets.all(2),
                                    child: Text(docs.data[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                  ),
                                  Container(

                                    padding: EdgeInsets.all(2),
                                    child: Text("WEIGHT",style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                  ),
                                  Container(

                                    padding: EdgeInsets.all(2),
                                    child: Text(docs.data[Config.weight],maxLines: 1,overflow:
                                    TextOverflow.ellipsis,style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),

                            ),
                        ),
                      ),


                        Center(
                          child: Container(

                            width: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?  ScreenUtil.getInstance().setWidth(240) : ScreenUtil.screenWidthDp>650 ? ScreenUtil.getInstance().setWidth(160) : ScreenUtil.getInstance().setWidth(230),



                            margin: EdgeInsets.only(top:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?  ScreenUtil.instance.setHeight(410) :ScreenUtil.screenWidthDp>650 ? ScreenUtil.instance.setHeight(450) : ScreenUtil.instance.setHeight(500),
                                left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)?45 : ScreenUtil.screenWidthDp >650 ?

                                100 : 60),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(30) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(25) : ScreenUtil(allowFontScaling: true).setSp(30),color: Colors.white),),
                                Padding(
                                  padding: const EdgeInsets.only(top:5.0,right: 5),
                                  child: Row(


                                    children: <Widget>[
                                      Expanded(
                                        child: Text(docs.data[Config.schoolOrOrg],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                        TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(20) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(14),color: Colors.white),),
                                      ),

                                      Text(" . #"+docs.data[Config.jerseyNumber],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                      TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(20) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(16),color: Colors.white),),
                                      Text(docs.data[Config.position],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                      TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(20) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(16),color: Colors.white),),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                      Container(

                          child: Image.asset('assets/images/card_athlete.png',)),


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
