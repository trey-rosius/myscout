import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/comments/comments_screen.dart';
import 'package:myscout/post/view_post_item.dart';
import 'package:myscout/screens/profile/external_profile_screen.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatelessWidget {
  PostItem({this.document, this.size, this.isLargeScreen, this.userId});
  final DocumentSnapshot document;
  final Size size;
  final bool isLargeScreen;
  final String userId;

  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: isLargeScreen ? size.height / 2.2 : size.height / 1.7,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewPostItemScreen(tag:document[Config.postId],imageUrl: document[Config.postImageUrl],postText: document[Config.postText],)),
              );
            },
            child: Hero(
              tag: document[Config.postId],
              child: Container(
                padding: EdgeInsets.all(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: document[Config.postImageUrl],
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
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                document[Config.postText],
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(

                    fontSize: 18.0, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection(Config.users)
                  .document(document[Config.postAdminId])
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
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExternalProfileScreen(userId: document[Config.postAdminId],)),
                                );
                              },
                              child: Padding(
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
                            ),
                            InkWell(
                              onTap:(){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExternalProfileScreen(userId: document[Config.postAdminId],)),
                                );

                },
                              child: Text(
                                docSnap.data[Config.fullNames],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      StreamBuilder<DocumentSnapshot>(
                          stream: Firestore.instance
                              .collection(Config.users)
                              .document(userId)
                              .collection(Config.likedPosts)
                              .document(document[Config.postId])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> docSnap) {
                            if (docSnap.hasData && docSnap.data.exists) {
                              return InkWell(
                                onTap: () {
                                  Firestore.instance
                                      .collection(Config.posts)
                                      .document(document[Config.postId])
                                      .collection(Config.likes)
                                      .document(userId)
                                      .delete();
                                  Firestore.instance
                                      .collection(Config.users)
                                      .document(userId)
                                      .collection(Config.likedPosts)
                                      .document(document[Config.postId])
                                      .delete();
                                },
                                child: Icon(
                                  Icons.favorite,
                                  size: 30.0,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  //save notification if the post doesn't belong to you
                                  if(document[Config.postAdminId] != userId)
                                    {
                                      Firestore.instance
                                          .collection(Config.notifications)

                                          .add({Config.senderId: userId, Config.receiverId:document[Config.postAdminId],
                                        Config.postId:document[Config.postId],
                                        Config.notificationText:" liked your post",
                                        Config.notificationType:"like",
                                        Config.createdOn:FieldValue.serverTimestamp()}).then((DocumentReference docRef){
                                        Firestore.instance
                                            .collection(Config.notifications).document(docRef.documentID).updateData({Config.notificationId:docRef.documentID});
                                      });
                                    }
                                    else
                                      {
                                        print("this post belongs to you");
                                      }
                                  Firestore.instance
                                      .collection(Config.posts)
                                      .document(document[Config.postId])
                                      .collection(Config.likes)
                                      .document(userId)
                                      .setData({Config.userId: userId});
                                  Firestore.instance
                                      .collection(Config.users)
                                      .document(userId)
                                      .collection(Config.likedPosts)
                                      .document(document[Config.postId])
                                      .setData({
                                    Config.postId: document[Config.postId]
                                  });
                                },
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 30.0,
                                ),
                              );
                            }
                          }),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection(Config.posts)
                              .document(document[Config.postId])
                              .collection(Config.likes)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.documents.length == 0
                                    ? ""
                                    : snapshot.data.documents.length.toString(),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColorLight),
                              );
                            } else {
                              return Text(
                                "",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColorLight),
                              );
                            }
                          })
                    ],
                  )),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              userId: userId,
                              postId: document[Config.postId],
                              postAdminId: document[Config.postAdminId],
                            ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.mode_comment,
                        size: 30.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection(Config.posts)
                              .document(document[Config.postId])
                              .collection(Config.comments)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      snapshot.data.documents.length == 0
                                          ? ""
                                          : snapshot.data.documents.length
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Comment(s)",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Comment(s)",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme.of(context)
                                              .primaryColorLight),
                                    ),
                                  )
                                ],
                              );
                            }
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
