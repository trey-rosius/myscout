
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/login_register/login_screen.dart';
import 'package:myscout/utils/Config.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String notificationToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //  _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //  _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        notificationToken = token;
      });

      print(notificationToken);


    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: size.width,
            height: size.height,

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Container(
                padding: EdgeInsets.only(top: 30.0),
                width: size.width / 1.3,
                //  color: Theme.of(context).primaryColor,

                child: RaisedButton(

                  onPressed: () {
                  //  Navigator.of(context).pushReplacementNamed('/HomeScreen');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(userType: Config.athleteOrParent,token: notificationToken,),
                      ),
                    );

                  },
                  color: Theme.of(context).primaryColorLight,
                  child: new Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                        Config.athleteOrParent,
                        style: new TextStyle(

                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
               new Container(
                 padding: EdgeInsets.only(top: 30.0),
                 width: size.width / 1.3,
                 //  color: Theme.of(context).primaryColor,

                 child: RaisedButton(

                   onPressed: () {

                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => LoginScreen(userType: Config.coachScout,token: notificationToken,),
                       ),
                     );

                   },
                   color: Colors.white,
                   child: new Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: new Text(
                         Config.coachScout,
                         style: new TextStyle(

                             color: Theme.of(context).primaryColorLight,
                             fontSize: 17.0,
                             fontWeight: FontWeight.w600)),
                   ),
                 ),
               ),
               new Container(
                 padding: EdgeInsets.only(top: 30.0),
                 width: size.width / 1.3,
                 //  color: Theme.of(context).primaryColor,

                 child: RaisedButton(

                   onPressed: () {

                     Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => LoginScreen(userType: Config.fan,token: notificationToken,),
                       ),
                     );
                   },
                   color: Colors.white,
                   child: new Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: new Text(
                         Config.fan,
                         style: new TextStyle(

                             color: Theme.of(context).primaryColorLight,
                             fontSize: 17.0,
                             fontWeight: FontWeight.w600)),
                   ),
                 ),
               )

            ],
          )

        ],
      ),
    );
  }
}
