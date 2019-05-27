import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/screens/cards/card_details.dart';
import 'package:myscout/utils/Config.dart';

class CoachItem extends StatelessWidget {
  CoachItem({this.document});
  final DocumentSnapshot document;



  @override
  Widget build(BuildContext context) {


    return  StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection(Config.cards).document(document[Config.cardId]).snapshots(),
        builder: (context,AsyncSnapshot<DocumentSnapshot> docs){
          if(docs.data !=null)
          {
            return  InkWell(
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
                            height: (ScreenUtil.screenWidthDp>413 && ScreenUtil.screenWidthDp <650) ? ScreenUtil.getInstance().setHeight(400) :ScreenUtil.screenWidthDp >650 ?ScreenUtil.getInstance().setHeight(450) : ScreenUtil.getInstance().setHeight(500),
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
            );

          }
          else
          {
            return Container();
          }

        });

  }
}
