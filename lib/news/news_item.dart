import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/comments/comments_screen.dart';
import 'package:myscout/post/view_post_item.dart';
import 'package:myscout/screens/gallery/view_image.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
class NewsItem extends StatelessWidget {
  NewsItem({this.document, this.size, this.isLargeScreen, this.userId});
  final DocumentSnapshot document;
  final Size size;
  final bool isLargeScreen;
  final String userId;

  _launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> deleteConfirmation(BuildContext context,String newsId) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: Container(
                height: 120.0,

                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Are you sure you want to delete this news card ?",style: TextStyle(
                          color: Colors.white,fontSize: 18.0
                      ),),
                    )
                  ],
                )
            ),
            actions: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "No",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();


                    // checkUserType();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "Yes",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Firestore.instance.collection(Config.users).document(Config.userId).collection(Config.news).document(newsId).delete();
                    Firestore.instance.collection(Config.news).document(newsId).delete();


                    // checkUserType();
                  },
                ),
              ),

            ],
          ),
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: (){
        if(userId ==  document[Config.linkAdmin])
          {
            deleteConfirmation(context, document[Config.linkId]);
          }
          else
            {

            }

      },
      onTap: (){
        _launchURL(document[Config.linkUrl]);
      },
      child: Container(
        width: size.width,
        height: isLargeScreen ? size.height / 2.0 : size.height / 1.5,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: document[Config.linkId],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: document[Config.linkImage],
                        placeholder: (context, url) => SpinKitWave(
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                              ),
                            );
                          },
                        ),
                        errorWidget: (context, url, ex) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),

            Flexible(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  document[Config.linkTitle],

                  style: TextStyle(

                      fontSize: 20.0,fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  document[Config.linkDescription],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(

                      fontSize: 18.0, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection(Config.users)
                    .document(document[Config.linkAdmin])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> docSnap) {
                  if (docSnap.hasData) {
                    DateTime updateDateTime = DateTime.fromMillisecondsSinceEpoch(
                        document[Config.createdOn].millisecondsSinceEpoch);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    width: 40.0,
                                    height: 40.0,
                                    fit: BoxFit.cover,
                                    imageUrl: docSnap.data[Config.profilePicUrl],
                                    placeholder: (context, url) =>
                                    new CircularProgressIndicator(),
                                    errorWidget: (context, url, ex) =>
                                    new Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width/2.5,
                                child: Text(
                                  docSnap.data[Config.fullNames],maxLines: 1,overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(timeago.format(updateDateTime)),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),

          ],
        ),
      ),
    );
  }
}
