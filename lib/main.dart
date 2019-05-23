import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myscout/screens/home/home_screen.dart';
import 'package:myscout/screens/login_register/login_screen.dart';
import 'package:myscout/screens/splash_screen.dart';
import 'package:myscout/screens/login_register/welcome_screen.dart';
import 'package:myscout/utils/app_inherited_widget.dart';
import 'package:myscout/utils/app_settings.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main()async {
  final preferences = await StreamingSharedPreferences.instance;
  final settings = AppSettings(preferences);
  runApp(App(settings));
}

class App extends StatelessWidget {
  App(this.settings);
  final AppSettings settings;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return
      AppInheritedWidget(
      child:

      MaterialApp(
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
      home: HomeScreen(),
    ),
        settings: settings,

      );
  }
}

