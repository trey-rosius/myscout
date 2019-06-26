import 'package:flutter/material.dart';

import 'package:myscout/screens/stats_external/defense_external_screen.dart';
import 'package:myscout/screens/stats_external/kicking_external_screen.dart';
import 'package:myscout/screens/stats_external/passing_external_screen.dart';
import 'package:myscout/screens/stats_external/punting_external_screen.dart';
import 'package:myscout/screens/stats_external/receiving_external_screen.dart';
import 'package:myscout/screens/stats_external/returns_external_screen.dart';
import 'package:myscout/screens/stats_external/rushing_external_screen.dart';

class StatExternalScreen extends StatefulWidget {
  StatExternalScreen({this.userId});
   final String userId;


  @override
  _StatExternalScreenState createState() => _StatExternalScreenState();
}

class _StatExternalScreenState extends State<StatExternalScreen> {

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
                       builder: (context) => DefenseExternalScreen(userId: widget.userId,),
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
                      builder: (context) => RushingExternalScreen(userId: widget.userId,),
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
                      builder: (context) => ReceivingExternalScreen(userId: widget.userId,),
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
                      builder: (context) => PassingExternalScreen(userId: widget.userId,),
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
                      builder: (context) => ReturnsExternalScreen(userId: widget.userId,),
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
                      builder: (context) => KickingExternalScreen(userId: widget.userId,),
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
                      builder: (context) => PuntingExternalScreen(userId: widget.userId,),
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
