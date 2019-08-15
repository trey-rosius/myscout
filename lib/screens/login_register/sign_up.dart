import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myscout/screens/profile/create_profile.dart';
import 'package:myscout/utils/Config.dart';
import 'package:myscout/utils/authentication.dart';
import 'package:myscout/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.scaffoldKey,this.userType,this.token});
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userType;
  final String token;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("notification token"+widget.token);
  }
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  ScrollController scrollController = new ScrollController();
  final fullNamesController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _autovalidate = false;
  bool _loading = false;
  UserAuth userAuth = new UserAuth();
  Validations validations = new Validations();
  void showInSnackBar(String value) {
    widget.scaffoldKey.currentState.showSnackBar(new SnackBar(
      content:  Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
      ),
      backgroundColor: Theme.of(context).accentColor,
    ));
  }
  _saveEmail(String _email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', _email);


  }

  _saveUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("saved userId to preferences");
    prefs.setString(Config.userType, userType);
  }
  _saveUid(String _uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(Config.userId, _uid);
  }
  UserData newUser = new UserData();

  String userKey;
  String name;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar("Fix Errors");
    } else {
      form.save();
      print("this is it"+newUser.email);
      _saveEmail(newUser.email);
      setState(() {
        _loading = true;
      });


      userAuth.createUser(newUser).then((onValue) {

        Future<FirebaseUser> user = firebaseAuth.currentUser();
        user.then((FirebaseUser firebaseUser){
          userKey = firebaseUser.uid;
          name = firebaseUser.displayName;
          print(userKey);

          var map = new Map<String, dynamic>();
          map[Config.userId] = firebaseUser.uid;
          map[Config.email] = firebaseUser.email;
          map[Config.admin] = false;
          map[Config.notificationToken] = widget.token;
          map[Config.fullNames] = fullNamesController.text;
          map[Config.userType] = widget.userType;

          map[Config.createdOn] = new DateTime.now().toString();
          Firestore.instance.collection(Config.users)
              .document(firebaseUser.uid)
              .setData(map)

              .then((_) {
            setState(() {
              _loading = false;
            });
            print("User Successfully registered");

            Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => CreateProfile(userId:firebaseUser.uid,),
                ));
            // showInSnackBar("Successful");
          });

          //save uid
          _saveUid(firebaseUser.uid);
          _saveUserType(widget.userType);
        });
        setState(() {
          _loading = false;
        });

        showInSnackBar(onValue);
      }).catchError((Object onError) {
        //    showInSnackBar(AppLocalizations.of(context).emailExist);
        showInSnackBar(onError.toString());
        print(onError.toString());
        setState(() {
          _loading = false;
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                key: formKey,
                autovalidate: _autovalidate,
                child: new Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Full Names";
                          }
                        },
                        onSaved: ((String value){
                          newUser.displayName = value.trim();
                        }),
                        controller:fullNamesController,

                        // enabled: false,
                        // keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            fillColor: Colors.white,
                            labelText: "Full Names",
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
                            return "Email";
                          }
                        },
                        onSaved: ((String value) {
                          newUser.email = value.trim();
                        }),
                        controller:emailController,

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
                          newUser.password = value.trim();
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(

                        validator: (value) {
                          if (value.trim() != passwordController.text) {
                            return "Passwords Don't Match";
                          }
                        },
                        controller: confirmPasswordController,

                        // enabled: false,
                        // keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: new InputDecoration(

                            fillColor: Colors.white,
                            labelText: "Confirm Password",
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
                        _loading == true
                            ? new CircularProgressIndicator() :
                        Container(
                          padding: EdgeInsets.only(top: 10.0),

                          width: size.width / 1.3,
                          //  color: Theme.of(context).primaryColor,

                          child: RaisedButton(
                            elevation: 0.0,
                            onPressed: () {
                              _handleSubmitted();
                            },
                            color: Theme.of(context).primaryColorLight,
                            child: new Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: new Text(
                                  "SIGN UP",
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Text("Already have an Account ?",style: TextStyle(color: Color(0xFFa7a6a7)),),
                  FlatButton(
                    onPressed: (){
                      setState(() {
                       // signUp = false;
                      });
                    },
                    child: Text("Log In",style: TextStyle(color: Colors.white),),
                  )
                ],
              )

            ],




    );
  }
}
