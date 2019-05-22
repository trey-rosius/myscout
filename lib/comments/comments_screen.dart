import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/comments/comments_item.dart';
import 'package:myscout/post/post_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';

class Comment{
  String commentText;

  Comment({this.commentText});

}
class CommentsScreen extends StatefulWidget {
  CommentsScreen({this.userId,this.postId,this.postAdminId});
  final String userId;
  final String postId;
  final String postAdminId;

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController textEditingController = new TextEditingController();

  Future<Null> help(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: Container(
                height: 190.0,

                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Press and hold a comment to delete. You can only delete a comment you created Or If the post belongs to You",style: TextStyle(
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
                    "Ok",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();


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


  Widget buildInput(BuildContext context) {
    return  Container(

        decoration: BoxDecoration(
            color:Colors.white,
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: EdgeInsets.all(10.0),

        child: Row(
          children: <Widget>[

            // Edit text
            Flexible(
              child: Container(
               margin: EdgeInsets.symmetric(horizontal: 8),
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: TextField(
                      maxLines: null,


                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Comment...',
                        hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: (){
                      if(textEditingController.text.toString().length >0){
                        Map map = Map<String,dynamic>();
                        map[Config.commentText] = textEditingController.text;
                        map[Config.commentAdminId] = widget.userId;
                        map[Config.postId] = widget.postId;
                        map[Config.postAdminId] = widget.postAdminId;
                        map[Config.createdOn] = FieldValue.serverTimestamp();

                        Firestore.instance.collection(Config.posts).document(widget.postId).collection(Config.comments).add(map)
                            .then((DocumentReference docRef){
                          Firestore.instance.collection(Config.posts).document(widget.postId).collection(Config.comments)
                              .document(docRef.documentID).updateData({

                            Config.commentId: docRef.documentID
                          }).then((_){
                            textEditingController.text = "";
                          });
                          if(widget.postAdminId != widget.userId)
                          {
                            Firestore.instance
                                .collection(Config.notifications)

                                .add({Config.senderId: widget.userId, Config.receiverId:widget.postAdminId,
                              Config.notificationText:" commented on your post",
                              Config.notificationType:"comment",
                              Config.commentId:docRef.documentID,
                              Config.postId:widget.postId,

                              Config.createdOn:FieldValue.serverTimestamp()}).then((DocumentReference docRef){
                              Firestore.instance
                                  .collection(Config.notifications).document(docRef.documentID).updateData({Config.notificationId:docRef.documentID});
                            });
                          }
                          else
                          {
                            print("this post belongs to you");
                          }


                        });

                      }else
                        {

                        }

                    },
                    color: Colors.white,
                  ),
                ),
              ),

            ),
          ],
        ),

    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Comments",style: TextStyle(fontSize: 20.0),),

        actions: <Widget>[
          InkWell(
            onTap: (){
              help(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right:20.0,top: 10.0),
              child: Icon(Icons.help_outline,color: Theme.of(context).primaryColorLight,),
            ),
          )
        ],

      ),
      body:

          Container(
      color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Flexible(
                  child:  StreamBuilder(
                      stream: Firestore.instance.collection(Config.posts).document(widget.postId).collection(Config.comments).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return LoadingScreen();

                        } else if (snapshot.hasData) {
                          return  ListView.builder(

                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (_, int index)
                              {
                                final DocumentSnapshot document = snapshot.data.documents[
                                index];
                                return CommentsItem(document: document,userId: widget.userId,postAdminId: widget.postAdminId,);
                              });



                        } else {
                          return  ErrorScreen(error: snapshot.error.toString(),
                          );
                        }
                      },
                    ),
                  ),

                Container(
                  color: Theme.of(context).primaryColor,
                   margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                    child: buildInput(context))

              ],
            ),
          ),

    );
  }
}
