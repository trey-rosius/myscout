import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/gallery/photo_item.dart';
import 'package:myscout/screens/gallery/photo_item_scroller.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {



  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}



class _ProfileScreenState extends State<ProfileScreen> {

  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }


  @override
  void initState() {
    // TODO: implement initState

    getUserId();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection(Config.users)
                .document(userId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(

                      child: Container(
                         height: size.height/3.5,
                        width: size.width,
                        color: Theme.of(context).primaryColor,

                        child: Column(
                          children: <Widget>[
                         Container(
                        decoration: BoxDecoration(
                        border: Border.all(color: Colors.white,width: 5),
                          borderRadius: BorderRadius.circular(80)
                            
                      ),
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(80),

                                    child: CachedNetworkImage(
                                        width: 120.0,
                                        height: 120.0,
                                        fit: BoxFit.cover,
                                        imageUrl: snapshot.data[Config.profilePicUrl]?? "",
                                        placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                        errorWidget: (context, url, ex) => CircleAvatar(
                                          backgroundColor: Theme.of(context).accentColor,
                                          radius: 100.0,
                                          child: Icon(
                                            Icons.account_circle,
                                            color: Colors.white,
                                            size: 100.0,

                                        )),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(snapshot.data[Config.fullNames],style: TextStyle(color: Colors.white,fontSize: 20.0),),
                            )
                          ],
                        ),
                      )
                    ),

                   SliverToBoxAdapter(
                     child: Container(
                       padding: EdgeInsets.only(top: 20.0,left: 10.0),
                       child: Row(


                         children: <Widget>[
                           Expanded(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                       Padding(

                       padding: const EdgeInsets.only(bottom:10.0),
                       child: Text("POSITION", style: TextStyle(

                             fontFamily: 'Montserrat',
                             color: Theme.of(context).primaryColor,
                             fontWeight: FontWeight.bold,
                             fontSize: 18.0)),

                   ),
                       Text(snapshot.data[Config.position]??"", style: TextStyle(
                             fontFamily: 'Montserrat',
                             color: Colors.grey,
                             fontWeight: FontWeight.bold,
                             fontSize: 16.0)),


                               ],
                             ),
                           ),
                           Expanded(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Padding(
                                   padding: const EdgeInsets.only(bottom:10.0),
                                   child: Text("HEIGHT", style: TextStyle(

                                       fontFamily: 'Montserrat',
                                       color: Theme.of(context).primaryColor,
                                       fontWeight: FontWeight.bold,
                                       fontSize: 18.0)),

                                 ),
                                 Text(snapshot.data[Config.height]??"", style: TextStyle(
                                     fontFamily: 'Montserrat',
                                     color: Colors.grey,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 16.0)),




                               ],
                             ),
                           )

                         ],
                       ),
                     ),
                   ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0,left: 10.0),
                        child: Row(


                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(

                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("WEIGHT", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(snapshot.data[Config.weight]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("CLASS", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(snapshot.data[Config.CLASS]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),




                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0,left: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,

                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0,right: 5.0),
                                    child: Text("HOMETOWN", style: TextStyle(

                                          fontFamily: 'Montserrat',
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0)),
                                  ),

                                  
                                  Text(snapshot.data[Config.location]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),


                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom:10.0),
                                    child: Text("HIGH SCHOOL", style: TextStyle(

                                        fontFamily: 'Montserrat',
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0)),

                                  ),
                                  Text(snapshot.data[Config.schoolOrOrg]??"", style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),




                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("BIO",style: TextStyle(

                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(snapshot.data[Config.shortBio]??""),
                      ),
                    ),
                    SliverToBoxAdapter(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("PHOTOS",style: TextStyle(

                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),),

                    StreamBuilder(
                      stream: Firestore.instance.collection(Config.posts).where(Config.postAdminId,isEqualTo:userId).where(Config.isVideoPost,isEqualTo: false).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: LoadingScreen(),
                          );
                        } else if (snapshot.hasData) {
                          return SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20.0),
                              height: size.height/3.5,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (_, int index)
                                  {
                                    final DocumentSnapshot document = snapshot.data.documents[
                                    index];
                                    return PhotoItemScroller(document: document);
                                  }),
                            ),
                          );

                        } else {
                          return SliverToBoxAdapter(
                            child: ErrorScreen(error: snapshot.error.toString()),
                          );
                        }
                      },
                    ),
                    SliverToBoxAdapter(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("HIGHLIGHTS",style: TextStyle(

                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                    ),),
                    SliverToBoxAdapter(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("MY CARDS",style: TextStyle(

                              fontFamily: 'Montserrat',
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0)),
                          Text("CREATE NEW",style: TextStyle(

                              fontFamily: 'Montserrat',
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0)),
                        ],
                      ),
                    ),),





                  ],
                );
              }

              else {

                return  Center(
                  child: Container(
                      child: Text("Loading .."),

                  ),
                );

              }
            })
    );
  }
}
