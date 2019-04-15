import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myscout/comments/comments_screen.dart';
import 'package:myscout/post/view_post_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:timeago/timeago.dart' as timeago;
class ViewCompletePost extends StatelessWidget {
  ViewCompletePost({this.userId,this.postId});
  final String postId;
  final String userId;
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(size.width < 412)
    {
      isLargeScreen = false;
    }
    else
    {
      isLargeScreen = true;
    }
    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("View Post",style: TextStyle(fontSize: 20.0),),


      ),
      body: StreamBuilder<DocumentSnapshot>(
    stream: Firestore.instance
        .collection(Config.posts)
        .document(postId)
        .snapshots(),
    builder: (BuildContext context,
    AsyncSnapshot<DocumentSnapshot> document) {
    if (document.hasData)
    {
      return  Container(
        width: size.width,
        height: isLargeScreen ? size.height / 2 : size.height / 1.7,
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
                      builder: (context) => ViewPostItemScreen(tag:document.data[Config.postId],imageUrl: document.data[Config.postImageUrl],postText: document.data[Config.postText],)),
                );
              },
              child: Hero(
                tag: document.data[Config.postId],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: document.data[Config.postImageUrl],
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
                  document.data[Config.postText],
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
                    .document(document.data[Config.postAdminId])
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> docSnap) {
                  if (docSnap.hasData) {
                    DateTime updateDateTime = DateTime.fromMillisecondsSinceEpoch(
                        document.data[Config.createdOn].millisecondsSinceEpoch);

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
                              Text(
                                docSnap.data[Config.fullNames],
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
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
                                .document(document.data[Config.postId])
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> docSnap) {
                              if (docSnap.hasData && docSnap.data.exists) {
                                return InkWell(
                                  onTap: () {
                                    Firestore.instance
                                        .collection(Config.posts)
                                        .document(document.data[Config.postId])
                                        .collection(Config.likes)
                                        .document(userId)
                                        .delete();
                                    Firestore.instance
                                        .collection(Config.users)
                                        .document(userId)
                                        .collection(Config.likedPosts)
                                        .document(document.data[Config.postId])
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
                                    if(document.data[Config.postAdminId] != userId)
                                    {
                                      Firestore.instance
                                          .collection(Config.notifications)

                                          .add({Config.senderId: userId, Config.receiverId:document.data[Config.postAdminId],
                                        Config.postId:document.data[Config.postId],
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
                                        .document(document.data[Config.postId])
                                        .collection(Config.likes)
                                        .document(userId)
                                        .setData({Config.userId: userId});
                                    Firestore.instance
                                        .collection(Config.users)
                                        .document(userId)
                                        .collection(Config.likedPosts)
                                        .document(document.data[Config.postId])
                                        .setData({
                                      Config.postId: document.data[Config.postId]
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
                                .document(document.data[Config.postId])
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
                            postId: document.data[Config.postId],
                            postAdminId: document.data[Config.postAdminId],
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
                                .document(document.data[Config.postId])
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
    else
      {
        return Container();
      }
    }),
    );
  }
}
