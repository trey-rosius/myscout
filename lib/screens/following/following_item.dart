import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/utils/Config.dart';
class FollowingItem extends StatelessWidget {
  FollowingItem({this.document,this.userId});
  final DocumentSnapshot document;
  final String userId;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection(Config.users).document(userId).snapshots(),
      builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
        if(snapshot.hasData)
          {
            return Container(

              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Container(
                            child:
                            CircularProgressIndicator(
                              valueColor:
                              AlwaysStoppedAnimation<
                                  Color>(
                                  Theme.of(context)
                                      .accentColor),
                            ),
                            width: 60.0,
                            height: 60.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                              BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          Material(
                            child: Image.asset(

                              "assets/images/user_profile.png",
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,

                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                      imageUrl: snapshot.data[
                      Config.profilePicUrl] ??"",
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Container(
                      width: size.width/5,
                      padding: EdgeInsets.only(top: 5),
                      child: Text(snapshot.data[Config.fullNames]??"",style: TextStyle(fontSize: 18),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                ],
              ),
            );
          } else
            {
              return Container();
            }
      },
    );
  }
}
