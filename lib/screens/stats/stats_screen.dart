import 'package:flutter/material.dart';
import 'package:myscout/screens/stats/baseball_screen.dart';
import 'package:myscout/screens/stats/basketball_screen.dart';
import 'package:myscout/screens/stats/coaching_screen.dart';
import 'package:myscout/screens/stats/defense_screen.dart';
import 'package:myscout/screens/stats/kicking_screen.dart';
import 'package:myscout/screens/stats/passing_screen.dart';
import 'package:myscout/screens/stats/punting_screen.dart';
import 'package:myscout/screens/stats/receiving_screen.dart';
import 'package:myscout/screens/stats/returns_screen.dart';
import 'package:myscout/screens/stats/rushing_screen.dart';
import 'package:myscout/screens/stats/soccer_screen.dart';
import 'package:myscout/screens/stats/tennis_screen.dart';

class StatScreen extends StatefulWidget {
   StatScreen({this.userId});
   final String userId;


  @override
  _StatScreenState createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("user Id is"+widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Stats",style: TextStyle(fontSize: 20.0),),

      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: InkWell(
               onTap: (){
                 Navigator.push(
                     context,
                     new MaterialPageRoute(
                       builder: (context) => DefenseScreen(userId: widget.userId,),
                     ));
               },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(title: Text("Defense",style: TextStyle(fontSize: 20),),)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => RushingScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(title: Text("Rushing",style: TextStyle(fontSize: 20),),)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => ReceivingScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(title: Text("Receiving",style: TextStyle(fontSize: 20),),)
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => PassingScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(title: Text("Passing",style: TextStyle(fontSize: 20),),),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => ReturnsScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text("Returns",style: TextStyle(fontSize: 20),),
                )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => KickingScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text("Kicking",style: TextStyle(fontSize: 20),),
                )
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => PuntingScreen(userId: widget.userId,),
                    ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: ListTile(
                  title: Text("Punting",style: TextStyle(fontSize: 20),),
                )
              ),
            ),
          ),

        ],
      ),
    );
  }
}
