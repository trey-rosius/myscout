import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);


  print("screen width Dp"+ScreenUtil.screenWidthDp.toString());
  print("screen width"+ScreenUtil.screenWidth.toString());
    return  StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection(Config.cards).document(document[Config.cardId]).snapshots(),
          builder: (context,AsyncSnapshot<DocumentSnapshot> docs){
            if(docs.data !=null)
              {
                return docs.data[Config.userType] == Config.coachScout ? InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                          //  builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames],cardCreator: docs.data[Config.cardCreatorId] ,),
                            builder: (context) => FullScreenCard(document: document,),
                          ));
                    },
                    child:
                    Container(
                      color: Color(int.parse(docs.data[Config.cardColor])),
                      margin: EdgeInsets.all(10),

                      child: Stack(
                        children: <Widget>[

                          Positioned(
                            top: ScreenUtil.getInstance().setWidth(8),

                            child: Padding(
                              padding: const EdgeInsets.only(left:5.0,right:4.0),
                              child:CachedNetworkImage(
                                height: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?ScreenUtil.getInstance().setHeight(420) : ScreenUtil.screenWidthDp > 650 ? ScreenUtil.getInstance().setHeight(450) : ScreenUtil.getInstance().setHeight(420),

                                width: ScreenUtil.getInstance().setWidth(395),
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

                                margin: EdgeInsets.only(top:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.instance.setHeight(400) : ScreenUtil.screenWidthDp>650 ? ScreenUtil.instance.setHeight(450): ScreenUtil.instance.setHeight(420),left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)?40 : ScreenUtil.screenWidthDp >650 ?

                                40 : 20),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                    TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(36) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(22) : ScreenUtil(allowFontScaling: true).setSp(36),color: Colors.white),),
                                    Row(
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

                              child: Image.asset('assets/images/card_coach.png',)),



                        ],
                      ),)
                )

                    :


                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            //  builder: (context) => CardDetails(cardId: document[Config.cardId],cardName: docs.data[Config.fullNames],cardCreator: docs.data[Config.cardCreatorId] ,),
                            builder: (context) => FullScreenCard(document: document,),
                          ));
                    },
                    child:
                 Container(
                   color: Color(int.parse(docs.data[Config.cardColor])),
                  margin: EdgeInsets.all(10),
                  child: Stack(
                    children: <Widget>[


                      Positioned(
                        top: ScreenUtil.getInstance().setHeight(20),
                        left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.getInstance().setWidth(85):ScreenUtil.screenWidthDp >650 ? ScreenUtil.getInstance().setWidth(50) : ScreenUtil.getInstance().setWidth(70),
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right:5.0),
                          child:CachedNetworkImage(
                              height: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?ScreenUtil.getInstance().setHeight(440) : ScreenUtil.screenWidthDp > 650 ? ScreenUtil.getInstance().setHeight(450) : ScreenUtil.getInstance().setHeight(420),
                              width: ScreenUtil.getInstance().setWidth(310),
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

                       RotatedBox(quarterTurns: 1,child:

                                Container(

                                  margin: EdgeInsets.only(bottom:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.instance.setHeight(30) : ScreenUtil.screenWidthDp>650? 20 : ScreenUtil.instance.setHeight(40),
                                      left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? 50 : ScreenUtil.screenWidthDp>650? 80 : 35),

                                  child: Row(

                                    children: <Widget>[
                                      Container(

                                        padding: EdgeInsets.all(2),
                                        child: Text("HEIGHT",style:
                                        TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(16) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                      ),
                                      Container(

                                        padding: EdgeInsets.all(2),
                                        child: Text(docs.data[Config.height],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                        TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(16) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                      ),
                                      Container(

                                        padding: EdgeInsets.all(2),
                                        child: Text("WEIGHT",style:
                                        TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(16) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                      ),
                                      Container(

                                        padding: EdgeInsets.all(2),
                                        child: Text(docs.data[Config.weight],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                        TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil(allowFontScaling: true).setSp(23) : ScreenUtil.screenWidthDp>650 ? ScreenUtil(allowFontScaling: true).setSp(16) : ScreenUtil(allowFontScaling: true).setSp(20),color: Colors.white),),
                                      ),
                                    ],
                                  ),
                                ),

                            ),



                              Center(
                                child: Container(


                                  width: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ?  ScreenUtil.getInstance().setWidth(250) : ScreenUtil.screenWidthDp>650 ? ScreenUtil.getInstance().setWidth(160) : ScreenUtil.getInstance().setWidth(200),
                                  margin:EdgeInsets.only(top: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)?ScreenUtil.instance.setHeight(430) :ScreenUtil.screenWidthDp > 650 ? ScreenUtil.instance.setHeight(420) : ScreenUtil.instance.setHeight(400),
                                       left: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)?65 : ScreenUtil.screenWidthDp >650 ?

                                  100 : 50) ,

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(docs.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,style:
                                      TextStyle(fontSize:(ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650)? ScreenUtil(allowFontScaling: true).setSp(30) :  ScreenUtil.screenWidthDp>650 ?  ScreenUtil(allowFontScaling: true).setSp(18) : ScreenUtil(allowFontScaling: true).setSp(30),color: Colors.white),),
                                    Padding(
                                      padding: const EdgeInsets.only(top:5.0),
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
