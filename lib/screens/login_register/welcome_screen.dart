
import 'package:flutter/material.dart';
import 'package:myscout/screens/login_register/login_screen.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                        builder: (context) => LoginScreen(),
                      ),
                    );

                  },
                  color: Theme.of(context).primaryColorLight,
                  child: new Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text(
                        "Athlete Or Parent",
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
                     //  Navigator.of(context).pushReplacementNamed('/HomeScreen');
                     /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminSignIn(),
                      ),
                    );
                    */
                   },
                   color: Colors.white,
                   child: new Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: new Text(
                         "Coach Or Scout",
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
                     //  Navigator.of(context).pushReplacementNamed('/HomeScreen');
                     /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminSignIn(),
                      ),
                    );
                    */
                   },
                   color: Colors.white,
                   child: new Padding(
                     padding: const EdgeInsets.all(15.0),
                     child: new Text(
                         "Fan",
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
