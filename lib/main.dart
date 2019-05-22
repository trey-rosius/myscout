import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myscout/screens/login_register/login_screen.dart';
import 'package:myscout/screens/splash_screen.dart';
import 'package:myscout/screens/login_register/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'myscout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        // is not restarted.
        primaryColorLight: Color(0xFF55b9b6),
         primaryColor: Color(0xFF757375),
        accentColor: Color(0xFFf49e23),
        primaryColorDark: Color(0xFF757375),

      ),
      routes: <String, WidgetBuilder>{

        '/Login': (BuildContext context) => LoginScreen(),

      },
      home: WelcomeScreen(),
    );
  }
}

