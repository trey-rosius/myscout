import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myscout/screens/cards/card_screen.dart';
import 'package:myscout/screens/cards/card_screen_scroller.dart';
import 'package:myscout/screens/cards/new_card_scroller.dart';
import 'package:myscout/screens/cards/popular_card_scroller.dart';
import 'package:myscout/screens/categories/category_data.dart';
import 'package:myscout/screens/categories/category_item.dart';
import 'package:myscout/screens/chats/chat_screen.dart';
import 'package:myscout/screens/notifications/full_notification_screen.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({this.userId});
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLargeScreen = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    print("userId is "+widget.userId);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        //  _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {

        print("onLaunch: $message");
/*
        if(message['data']['receiverId'] != null)
          {

            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    senderId:message['data']['senderId'],
                    receiverId: message['data']['receiverId'],

                  ),
                ));
          }else
            {
              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => FullNotificationScreen(userId: widget.userId),
                ),
              );
            }
*/
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        if(message['data']['receiverId'] != null)
        {
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => ChatScreen(
                  senderId:message['data']['receiverId'],
                  receiverId: message['data']['senderId'],

                ),
              ));

        }else
        {
          Navigator.push(
            context,
            MaterialPageRoute(

              builder: (context) => FullNotificationScreen(userId: widget.userId),
            ),
          );
        }
        //  _navigateToItemDetail(message);
      },
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);

    return Scaffold(

      body: CustomScrollView(
        slivers: <Widget>[
      SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Popular Cards",style: TextStyle(


                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0)),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => CardScreen(userId: widget.userId,cardType: Config.popularCards,),
                    ));
              },
              child: Text("VIEW ALL",style: TextStyle(


                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0)),
            ),
          ])
    )),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: ScreenUtil.instance.setHeight(620),
              child: PopularCardScroller(userId: widget.userId,),
            ),
          ),
      SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Sports Category",style: TextStyle(


                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
                Text("VIEW ALL",style: TextStyle(


                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
              ])
      )),
      SliverToBoxAdapter(

        child: Container(
          height: 140,
          width: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context,index){
                return CategoryItem(item: categories[index],userId:widget.userId);
              }),
        ),
      ),
      SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("New Cards",style: TextStyle(


                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => CardScreen(userId: widget.userId,cardType: Config.newCards,),
                        ));
                  },
                  child: Text("VIEW ALL",style: TextStyle(


                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
                ),
              ])
      )),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: ScreenUtil.instance.setHeight(620),
          child: NewCardScroller(userId: widget.userId,),
        ),
      ),
      SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("My Cards",style: TextStyle(


                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => CardScreen(userId: widget.userId,cardType: Config.myCards,),
                        ));
                  },
                  child: Text("VIEW ALL",style: TextStyle(


                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
                ),
              ])
      )),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: ScreenUtil.instance.setHeight(620),
          child: CardScreenScroller(userId: widget.userId,),
        ),
      )

        ],
      )
    );
  }
}
