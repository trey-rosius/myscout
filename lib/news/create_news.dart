import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/news/api.dart';
import 'package:myscout/news/news_model.dart';
import 'package:myscout/utils/Config.dart';
class CreateNews extends StatefulWidget {
  CreateNews({this.userId});
  final String userId;
  @override
  _CreateNewsState createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final linkController = TextEditingController();
  bool autovalidate = false;
  bool loading = false;

  @override
  void dispose() {
    linkController.dispose();
    super.dispose();
  }

  saveLinkToDb(String linkUrl) async {
    setState(() {
      loading = true;
    });

    await Api.fetchCompleteLinkData(linkUrl)
    .then((News news){

      Map map = Map<String,dynamic>();
      map[Config.linkTitle] =news.title;
      map[Config.linkDescription] =news.desc;
      map[Config.linkImage] =news.image;
      map[Config.linkUrl] =news.url;
      map[Config.linkAdmin] =widget.userId;
      map[Config.createdOn] =FieldValue.serverTimestamp();


      Firestore.instance.collection(Config.news).add(map)
      .then((DocumentReference docRef){
        Firestore.instance.collection(Config.news).document(docRef.documentID).updateData({
          Config.linkId: docRef.documentID
        });
        Firestore.instance.collection(Config.users).document(widget.userId).collection(Config.news)
        .document(docRef.documentID).setData({
          Config.linkId:docRef.documentID
        });
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop();
      });
      print(news.image);
      print(news.title);
    });




  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Post A News Link",style: TextStyle(fontSize: 20.0),),

      ),
      body:CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top:20.0,left: 10.0),
              child: Text("Paste a Link",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
            ),

          ),

          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child: Form(
                key: formKey,
                autovalidate: autovalidate,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(

                        validator: (value) {

                          if (value.isEmpty) {
                            return "Paste a News Link";
                          }
                        },

                        controller: linkController,
                        maxLines: 10,
                        decoration: new InputDecoration(
                            labelText: "Paste a News Link",

                            contentPadding: new EdgeInsets.all(12.0),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                loading == true
                    ? new CircularProgressIndicator()
                    : Container(
                  padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                  width: size.width / 1.5,
                  //  color: Theme.of(context).primaryColor,

                  child: RaisedButton(
                    elevation: 0.0,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                       saveLinkToDb(linkController.text);
                      }
                    },
                    color: Theme.of(context).primaryColorLight,
                    child: new Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: new Text("Submit",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ) ,
    );
  }
}
