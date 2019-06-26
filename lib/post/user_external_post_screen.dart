import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/post/post_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserExternalPostScreen extends StatefulWidget {
  UserExternalPostScreen({this.userId,this.visitorId});
  final String userId;
  final String visitorId;
  @override
  _UserExternalPostScreenState createState() => _UserExternalPostScreenState();
}

class _UserExternalPostScreenState extends State<UserExternalPostScreen> {


  Future<Null> help(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: Container(
                height: 150.0,

                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Press and hold a post to delete. You can only delete a post you created",style: TextStyle(
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

  bool isLargeScreen = false;
/*
  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }
*/

  @override
  void initState() {
    // TODO: implement initState

   // getUserId();
    print("user Id is" + widget.userId);
    print("visitor Id is" + widget.visitorId);
    super.initState();
  }
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

        title:Text("User Posts",style: TextStyle(fontSize: 20.0),),

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
        child: StreamBuilder(
          stream: Firestore.instance.collection(Config.posts).orderBy(Config.createdOn,descending: true).where(Config.postAdminId,isEqualTo: widget.userId).snapshots(),
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
                        return PostItem(document: document,size:size,isLargeScreen:isLargeScreen,userId:widget.visitorId);
                      });



            } else {
              return  ErrorScreen(error: snapshot.error.toString(),
              );
            }
          },
        ),
      ),
    );
  }
}
