import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myscout/screens/gallery/view_image.dart';
import 'package:myscout/utils/Config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class PhotoItem extends StatefulWidget {
  PhotoItem ({this.document,this.userId});
  final DocumentSnapshot document;
  final String userId;

  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  Future<Null> deleteConfirmation(BuildContext context,String postsId) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: SingleChildScrollView(


                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Are you sure you want to delete this Post?",style: TextStyle(
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
                    Firestore.instance.collection(Config.posts).document(widget.document[Config.postId]).delete();
                    Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.userPosts).document(widget.document[Config.postId]).delete();


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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewImageScreen(tag:widget.document[Config.postId],imageUrl: widget.document[Config.postImageUrl],)),
          );
        },
        onLongPress: (){
          deleteConfirmation(context, widget.document[Config.postId]);
        },
        child: Hero(
          tag: widget.document[Config.postId],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: CachedNetworkImage(

              fit: BoxFit.cover,
              imageUrl: widget.document[Config.postImageUrl],
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
    );
  }
}
