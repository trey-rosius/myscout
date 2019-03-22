import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String userType;
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, _getUserType);
  }

  Future<Null>_getUserType() async {
    Navigator.of(context).pushReplacementNamed('/Welcome');
  }
/*
  Future<Null> _getUserType() async {
    String userType = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userType = prefs.getString('user_type');
    if (userType == "nonadmin") {
      print(userType);
      Navigator.of(context).pushReplacementNamed('/HomePatientsNonAdmin');
    } else if (userType == "admin") {
      print(userType);
      Navigator.of(context).pushReplacementNamed('/HomeAdmin');
    } else {
      Navigator.of(context).pushReplacementNamed('/Login');
    }
  }
  */

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/myscout.png',
              fit: BoxFit.cover,

            ),
            Padding(
              padding:  EdgeInsets.only(top:20.0),
              child: Text("Who's Watching Your Game ?",style: TextStyle(fontSize: 18.0,color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
