import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myscout/screens/gallery/view_image.dart';
import 'package:myscout/utils/Config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class PhotoItem extends StatelessWidget {
  PhotoItem ({this.document});
  final DocumentSnapshot document;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewImageScreen(tag:document[Config.postId],imageUrl: document[Config.postImageUrl],)),
          );
        },
        child: Hero(
          tag: document[Config.postId],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: CachedNetworkImage(

              fit: BoxFit.cover,
              imageUrl: document[Config.postImageUrl],
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
