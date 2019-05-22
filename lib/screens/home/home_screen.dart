import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:myscout/news/news_screen.dart';
import 'package:myscout/post/create_post.dart';
import 'package:myscout/post/post_screen.dart';
import 'package:myscout/screens/awards/awards_screen.dart';

import 'package:myscout/screens/chats/conversation_list_screen.dart';
import 'package:myscout/screens/coaches/coach_screen.dart';
import 'package:myscout/screens/home/gallery_screen.dart';
import 'package:myscout/screens/home/home_page.dart';

import 'package:myscout/screens/home/placeholder.dart';
import 'package:myscout/screens/notifications/notification_screen.dart';
import 'package:myscout/screens/players/players_screen.dart';

import 'package:myscout/screens/profile/edit_profile.dart';
import 'package:myscout/screens/profile/profile_screen.dart';
import 'package:myscout/screens/schedule/schedule_screen.dart';
import 'package:myscout/screens/search/search_screen.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({this.userId});
  final String userId;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  int _currentIndex = 0;



  final List<Widget> _segmentChildren = [
    PlayerScreen(),
    CoachScreen()
  ];

  final Map<int, Widget> children =  <int, Widget>{
    0: Container(
       padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('Athletes',style: TextStyle(fontSize: 20.0),),
    ),
    1: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('Coaches',style: TextStyle(fontSize: 20.0),),
    ),

  };



  int sharedValue = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final List<Widget> _children = [
      HomePage(userId: widget.userId,),
      PlaceholderWidget(Colors.white),
      CreatePost(),
      NotificationScreen(userId: widget.userId,),
      ProfileScreen(userId: widget.userId,)
    ];
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: InkWell(onTap: ()=>_scaffoldKey.currentState.openDrawer(),


          child: Image.asset('assets/images/ham.png'),
        ),
        title: _currentIndex==0 ? Text("Home") : _currentIndex==1 ? Text("Network") :_currentIndex ==2 ? Text("Post") :
            _currentIndex ==3 ? Text("Notifications") : Text("Profile"),
        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => EditProfile(userId:widget.userId),
                  ));
            },
            child: _currentIndex ==4 ?
                Image.asset('assets/images/edit.png') : Container(),
          )
        ],
        bottom: _currentIndex == 1 ? PreferredSize(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    color: Theme.of(context).primaryColor,
                    child: CupertinoSegmentedControl(
                        selectedColor: Theme.of(context).primaryColorLight,
                        borderColor: Theme.of(context).primaryColorLight,

                        children: children,
                        groupValue: this.sharedValue,
                        onValueChanged: (value) {
                          this.setState(() => sharedValue = value);
                        }),
                  ),
                )
              ],
            ),
            preferredSize: Size(double.infinity, 60)) :
           _currentIndex ==0 ?
           PreferredSize(child: InkWell(
             onTap: (){

              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => SearchScreen(userId: widget.userId,),
                ),
              );


             },
             child: Container(
               margin: EdgeInsets.all(10),
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(10)),
               child: TextField(
                 enabled: false,
                 decoration: InputDecoration(
                   border: InputBorder.none,
                   contentPadding: EdgeInsets.only(top: 14.0),
                   hintText: 'Search cards, products or awards..',
                   hintStyle:
                   TextStyle(fontFamily: 'Montserrat', fontSize: 14.0),

                   prefixIcon: Icon(Icons.search, color: Colors.grey),
                 ),
               ),
             ),


           ), preferredSize: Size(double.infinity, 60))
           :


        PreferredSize(child: Container(), preferredSize: null)
      ),

      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
           decoration: BoxDecoration(
               color: Theme.of(context).primaryColorLight,

           ),


          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(

                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => GalleryScreen(),
                      ));

                },
                child: Container(

                  width: size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("GALLERY",style: TextStyle(color: Colors.white),)),
                ),
              ),
              Divider(color: Colors.white,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("STATS",style: TextStyle(color: Colors.white)),
              ),
              Divider(color: Colors.white,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => NewsScreen(userId: widget.userId,),
                      ));
                },
                child: Container(

                  width: size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("NEWS",style: TextStyle(color: Colors.white))),
                ),
              ),
              Divider(color: Colors.white,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => ConversationListScreen(),
                      ));
                },
                child: Container(

                  width: size.width,
                  padding:  EdgeInsets.all(8.0),
                  child: Center(child: Text("CHATS",style: TextStyle(color: Colors.white))),
                ),
              ),
              Divider(color: Colors.white,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                       MaterialPageRoute(
                        builder: (context) => AwardsScreen(),
                      ));
                },
                child:Container(

                  width: size.width,
                  padding:  EdgeInsets.all(8.0),
                  child: Center(child: Text("AWARDS",style: TextStyle(color: Colors.white))),
                ),
              ),
              Divider(color: Colors.white,),
              InkWell(
                onTap: (){

                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) =>  PostScreen(userId: widget.userId,),
                      ));
                },
                child:Container(

                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("SOCIAL FEED",style: TextStyle(color: Colors.white))),
                ),
              ),
              Divider(color: Colors.white,),
              InkWell(
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) =>  SchedulesScreen(),
                      ));
                },
                child:Container(

                  width: size.width,
                  padding:  EdgeInsets.all(8.0),
                  child: Center(child: Text("SCHEDULE",style: TextStyle(color: Colors.white))),
                ),
              ),
              Divider(color: Colors.white,),
              Container(

                width: size.width,
                padding:  EdgeInsets.all(8.0),
                child: Center(child: Text("SETTINGS",style: TextStyle(color: Colors.white))),
              ),

            ],
          ),
        ),
      ),
      body:_currentIndex == 1 ? _segmentChildren[sharedValue] : _children[_currentIndex] ,

       bottomNavigationBar: Theme(
         data: Theme.of(context).copyWith(
           // sets the background color of the `BottomNavigationBar`
           //  canvasColor: Colors.green,

             // sets the active color of the `BottomNavigationBar` if `Brightness` is light
             primaryColor: Theme.of(context).primaryColorLight,
             textTheme: Theme
                 .of(context)
                 .textTheme
                 .copyWith(caption:  TextStyle(color: Colors.black))),
         child: BottomNavigationBar(
           onTap: onTabTapped, // new
           currentIndex: _currentIndex,
           type: BottomNavigationBarType.fixed,

           // n this will be set when a new tab is tapped
           items: [

             BottomNavigationBarItem(
               activeIcon:Image.asset('assets/images/home.png',color: Theme.of(context).primaryColorLight,) ,

               icon:  Image.asset('assets/images/home.png'),
               title:  Text('Home'),
             ),
             BottomNavigationBarItem(
               activeIcon:Image.asset('assets/images/network.png',color: Theme.of(context).primaryColorLight,) ,
               icon: Image.asset('assets/images/network.png'),
               title: new Text('Network'),
             ),
             BottomNavigationBarItem(
                 activeIcon:Image.asset('assets/images/post.png',color: Theme.of(context).primaryColorLight,) ,
                 icon: Image.asset('assets/images/post.png'),
                 title: Text('Post')
             ),
             BottomNavigationBarItem(
                 activeIcon:Image.asset('assets/images/notification.png',color: Theme.of(context).primaryColorLight,) ,
                 icon: Image.asset('assets/images/notification.png'),
                 title: Text('Notifications')
             ),
             BottomNavigationBarItem(
                 activeIcon:Image.asset('assets/images/profile.png',color: Theme.of(context).primaryColorLight,) ,
                 icon: Image.asset('assets/images/profile.png'),
                 title: Text('Profile')
             )
           ],
         ),
       ),
    );
  }
}
