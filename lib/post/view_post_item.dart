import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class ViewPostItemScreen extends StatelessWidget {
  ViewPostItemScreen({this.tag,this.imageUrl,this.postText});
  final String tag;
  final String imageUrl;
  final String postText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("View Post Item",style: TextStyle(fontSize: 20.0),),

      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Hero(tag: tag, child:CachedNetworkImage(

              fit: BoxFit.cover,
              imageUrl: imageUrl,
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
            ),),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(postText, style: TextStyle(

                  fontSize: 20.0, color: Theme.of(context).primaryColor),),
            ),
          )
        ],
      )
    );
  }
}
