import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/card_item.dart';
import 'package:myscout/screens/cards/card_screen_scroller.dart';
import 'package:myscout/screens/cards/new_card_scroller.dart';
import 'package:myscout/screens/cards/popular_card_scroller.dart';
import 'package:myscout/screens/categories/category_data.dart';
import 'package:myscout/screens/categories/category_item.dart';
import 'package:myscout/screens/players/player_item.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/error_screen.dart';
import 'package:myscout/utils/loading_screen.dart';
class HomePage extends StatefulWidget {
  HomePage({this.userId});
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLargeScreen = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


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
            Text("VIEW ALL",style: TextStyle(


                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0)),
          ])
    )),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              height: size.height/2.5,
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
                Text("VIEW ALL",style: TextStyle(


                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
              ])
      )),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: size.height/2.5,
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
                Text("VIEW ALL",style: TextStyle(


                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
              ])
      )),
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: size.height/2.5,
          child: CardScreenScroller(userId: widget.userId,),
        ),
      )

        ],
      )
    );
  }
}
