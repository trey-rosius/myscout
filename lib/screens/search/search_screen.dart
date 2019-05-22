
import 'package:flutter/material.dart';

import 'package:myscout/screens/awards/search_awards.dart';

import 'package:myscout/screens/search/search_card_screen.dart';
import 'package:myscout/screens/search/users_search.dart';


class SearchScreen extends StatefulWidget {
  SearchScreen({this.userId});
  final String userId;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLargeScreen = false;
  String filter;
  List<String> items;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (size.width < 412.0) {
      isLargeScreen = false;
    } else {
      isLargeScreen = true;
    }
    return DefaultTabController(
    length: 3,
        child: Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 34.0, 16.0, 10.0),

              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search cards, products or awards..',
                    hintStyle: TextStyle(color: Colors.white)
                ),
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontFamily: "Montserrat-Regular",
                  decoration: TextDecoration.none,
                ),
                onChanged: (String value) {
                  setState(() {
                    filter = value;
                  });
                },
              ),
            ),

                      _buildTabBar(),

                      // _buildContentContainer(viewportConstraints),






          ],
        ), preferredSize: Size(double.infinity, 120)),
      ),


      body:TabBarView(children: [
        filter == null || filter == "" ?Container():   SearchAwardsScreen(searchString: filter,),
        filter == null || filter == "" ?Container():   UsersScreen(searchString: filter,userId: widget.userId,),
        filter == null || filter == "" ?Container():   SearchCardScreen(searchString: filter,userId: widget.userId,),


      ])
    ));
  }



  Widget _buildTabBar() {
    return Stack(
      children: <Widget>[
         Positioned.fill(
          top: null,
          child: new Container(
            height: 2.0,
            color: new Color(0xFFEEEEEE),
          ),
        ),
         TabBar(
          tabs: [
            Tab(text: "Awards"),
            Tab(text: "Users"),
            Tab(text: "Cards"),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
           labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
           indicatorColor: Theme.of(context).accentColor,

        ),
      ],
    );
  }




}
