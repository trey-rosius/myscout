import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myscout/post/video_player_screen.dart';
import 'package:myscout/screens/gallery/view_image.dart';
import 'package:myscout/utils/Config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class VideoItem extends StatelessWidget {
  VideoItem ({this.document});
  final DocumentSnapshot document;


  @override
  Widget build(BuildContext context) {
    return Container(

     padding: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(document[Config.postVideoUrl])),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(

              child: AspectRatio(
                aspectRatio: 16/ 9,

                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: document[Config.postVideoThumbUrl] ?? "",
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
            Icon(Icons.play_circle_filled,color: Theme.of(context).primaryColorLight,size: 100,)
          ],
        ),
      ),
    );
  }
}
