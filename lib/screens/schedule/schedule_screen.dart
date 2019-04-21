import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/coaches/coach_screen.dart';
import 'package:myscout/screens/gallery/photo_screen.dart';

import 'package:myscout/screens/players/players_screen.dart';
import 'package:myscout/screens/schedule/all_schedules.dart';
import 'package:myscout/screens/schedule/create_schedule.dart';
import 'package:myscout/screens/schedule/upcomming_screen.dart';
class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();



  final List<Widget> _segmentChildren = [
    UpcomingScreen(),
    AllScreen(),

  ];

  final Map<int, Widget> children =  <int, Widget>{
    0: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('Upcoming',style: TextStyle(fontSize: 20.0),),
    ),
    1: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('all',style: TextStyle(fontSize: 20.0),),
    ),

  };



  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,

          title:Text("Schedules",style: TextStyle(fontSize: 20.0),),
          bottom: PreferredSize(
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
              preferredSize: Size(double.infinity, 60))
      ),

      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => CreateSchedule(),
            ));
      },
      child: Icon(Icons.schedule,),),

      body:_segmentChildren[sharedValue],


    );
  }
}
