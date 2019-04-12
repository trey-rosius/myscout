import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/cards/create_card.dart';
import 'package:myscout/screens/login_register/sign_up.dart';
import 'package:myscout/screens/profile/create_profile.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/authentication.dart';
import 'package:myscout/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> formKey =  GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  ScrollController scrollController =  ScrollController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserData user = UserData();
  UserAuth userAuth =  UserAuth();

  Validations validations = new Validations();
  bool loading = false;
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content:  Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
      ),
      backgroundColor: Theme.of(context).accentColor,
    ));
  }
  bool signUp = false;
  bool autovalidate = false;

  _saveUserId(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saved userId to preferences");
    prefs.setString(Config.userId, uid);
  }

  void _handleFormSubmission() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar("Fix Error");
    } else {
      form.save();
      setState(() {
        loading = true;
      });



      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: user.email, password: user.password)
          .then((onValue) {
        Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
        user.then((FirebaseUser user) async {
          if (user != null) {
            print(user.email);
            print(user.displayName);
            print(user.uid);
            _saveUserId(user.uid);

              setState(() {
                loading = false;


                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => CreateProfile(userId:user.uid),
                    ));

            /*
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) =>  CreateCard(),
                    ));
                    */
              });



          } else {
            showInSnackBar("Something Went Wrong");
            setState(() {
              loading = false;
            });
          }
        });
      }).catchError((e) {
        // showInSnackBar(AppLocalizations.of(context).acountNonExist);
        showInSnackBar(e.toString());
        print(e);
        setState(() {
          loading = false;
        });
      });
    }
  }






  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Scaffold(
      key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColorDark,
      body:SingleChildScrollView(
        child: Container(

          padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: size.height/12),
                child: Image.asset(
                  'assets/images/myscout.png',
                  fit: BoxFit.cover,

                ),
              ),
              Container(
                padding: EdgeInsets.only(top: size.height/10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //padding: EdgeInsets.only(top: 30.0),
                      height: 50.0,
                      width: size.width / 2.5,
                      //  color: Theme.of(context).primaryColor,
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).accentColor,width: 2.0)
                      ),
                      child: RaisedButton(
                       elevation: 0.0,
                        onPressed: () {
                          setState(() {
                            signUp = false;
                          });
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
                        color: signUp ? Theme.of(context).primaryColorDark :Theme.of(context).accentColor,
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text(
                              "LOGIN",
                              style: new TextStyle(

                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    Container(

                      //padding: EdgeInsets.only(top: 30.0),
                        width: size.width / 2.5,
                      height: 50.0,
                      //  color: Theme.of(context).primaryColor,
                      decoration: BoxDecoration(

                        border: Border.all(color: Theme.of(context).accentColor,width: 2.0)
                      ),

                      child: RaisedButton(
                        elevation: 0.0,
                        onPressed: () {
                          setState(() {
                            signUp = true;
                          });
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
                        color: signUp ? Theme.of(context).accentColor :Theme.of(context).primaryColorDark,

                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new Text(
                              "SIGN UP",
                              style: new TextStyle(

                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),


              ),
              signUp ? SignUpScreen(scaffoldKey: _scaffoldKey,):  Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Form(
                      key: formKey,
                      autovalidate: autovalidate,
                      child: new Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 0.0),
                            child: new TextFormField(

                              controller:emailController,
                              validator: (value) {
                                validations.validateEmail(value);
                                if (value.isEmpty) {
                                  return "Email";
                                } else {
                                  final RegExp nameExp =
                                  new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
                                  if (!nameExp.hasMatch(value))
                                    return "InValid Email";
                                }
                              },
                              onSaved: ((String value) {
                                user.email = value.trim();
                              }),
                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                  fillColor: Colors.white,
                                  labelText: "Email",
                                  contentPadding: new EdgeInsets.all(18.0),
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 2.0, color: Colors.white),
                                  )),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 0.0),
                            child: new TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password";
                                }
                              },
                              onSaved: ((String value) {
                                user.password = value.trim();
                              }),
                              controller: passwordController,

                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: new InputDecoration(
                                 fillColor: Colors.white,
                                  labelText: "Password",
                                  contentPadding: new EdgeInsets.all(18.0),
                                  filled: true,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: 2.0, color: Colors.white),
                                  )),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              loading == true
                                  ? new CircularProgressIndicator() :

                              Container(
                                padding: EdgeInsets.only(top: 10.0),

                                width: size.width / 1.3,
                                //  color: Theme.of(context).primaryColor,

                                child: RaisedButton(
                                  elevation: 0.0,
                                  onPressed: () {

                                    _handleFormSubmission();




                                  },
                                  color: Theme.of(context).primaryColorLight,
                                  child: new Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: new Text(
                                        "LOGIN",
                                        style: new TextStyle(

                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0,vertical: 40.0),
                      child: Text("Forgot Password ?",style: TextStyle(color: Colors.white),),
                    ),
                    Container(
                     // padding: EdgeInsets.only(top: 10.0),

                      width: size.width / 1.3,
                      //  color: Theme.of(context).primaryColor,

                      child: RaisedButton(
                        elevation: 0.0,
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
                        color: Theme.of(context).primaryColorLight,
                        child: new Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: new Text(
                              "Login with Facebook",
                              style: new TextStyle(

                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        Text("Don't have an Account ?",style: TextStyle(color: Color(0xFFa7a6a7)),),
                        FlatButton(
                          onPressed: (){
                            setState(() {
                              signUp = true;
                            });

                          },
                          child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                        )
                      ],
                    )

                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
