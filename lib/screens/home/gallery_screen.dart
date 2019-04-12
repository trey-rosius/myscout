import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/coaches/coach_screen.dart';
import 'package:myscout/screens/gallery/photo_screen.dart';

import 'package:myscout/screens/players/players_screen.dart';
class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();



  final List<Widget> _segmentChildren = [
    PhotoScreen(),
    CoachScreen()
  ];

  final Map<int, Widget> children =  <int, Widget>{
    0: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('Photos',style: TextStyle(fontSize: 20.0),),
    ),
    1: Container(
      padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
      child: Text('Videos',style: TextStyle(fontSize: 20.0),),
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

          title:Text("Gallery",style: TextStyle(fontSize: 20.0),),
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

      body:_segmentChildren[sharedValue],


    );
  }
}
