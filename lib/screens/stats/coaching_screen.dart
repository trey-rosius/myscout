import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class CoachingScreen extends StatefulWidget {
  CoachingScreen({this.userId});
  final String userId;

  @override
  _CoachingScreenState createState() => _CoachingScreenState();
}

class _CoachingScreenState extends State<CoachingScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.coaching)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            gamesController.text = snapshot[Config.games];
            winsController.text = snapshot[Config.wins];
            lossesController.text = snapshot[Config.losses];

            percentageController.text = snapshot[Config.percentage];
            appreController.text = snapshot[Config.appre];
            appostController.text = snapshot[Config.appost];
            aphighController.text = snapshot[Config.aphigh];

          });

    });
  }
  

  final gamesController = TextEditingController();
  final winsController = TextEditingController();

  final lossesController = TextEditingController();
  final percentageController = TextEditingController();
  final appreController = TextEditingController();
  final appostController = TextEditingController();
  final aphighController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;

  void handleSubmitInfo()
  {
    setState(() {
      loading = true;
    });

    Map map = new Map<String, dynamic>();
    map[Config.games] = gamesController.text;
    map[Config.wins] = winsController.text;
    map[Config.losses] = lossesController.text;
    map[Config.percentage] = percentageController.text;

    map[Config.appre] = appreController.text;
    map[Config.aphigh] = aphighController.text;
    map[Config.appost] = appostController.text;

    map[Config.userId] = widget.userId;



    Firestore.instance.collection(Config.coaching).document(widget.userId).setData(map).then((_){



      setState(() {
        loading= false;
      });

    });



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("user id"+widget.userId);

    loadingInfomation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


   gamesController.dispose();
   winsController.dispose();
   lossesController.dispose();
   percentageController.dispose();
   appreController.dispose();
   aphighController.dispose();
   appostController.dispose();



  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("BasketBall",style: TextStyle(fontSize: 20.0),),

      ),
      body: SingleChildScrollView(

        child:Column(
          children: <Widget>[



           Container(

                child: Form(
                  key: formKey,
                  autovalidate: autovalidate,
                  child: new Column(
                    children: <Widget>[



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            width: size.width/2,
                            child: new TextFormField(
                              controller: gamesController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "GAMES";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "GAMES",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: winsController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "WINS";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "WINS",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),


                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Container(
                            width: size.width/2,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: lossesController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "LOSSES";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "LOSSES",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: percentageController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "%";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "%",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),


                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: appreController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AP PRE";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AP PRE",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: size.width/2,
                            child: new TextFormField(
                              controller: aphighController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AP HIGH";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AP HIGH",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: appostController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AP POST";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AP POST",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                        ],
                      ),



                      Column(
                        children: <Widget>[
                          loading == true
                              ?  Padding(
                            padding: EdgeInsets.only(top: 20.0,bottom: 20.0),
                            child: CircularProgressIndicator(),
                          )
                              : Container(
                            padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                            width: size.width / 1.3,
                            //  color: Theme.of(context).primaryColor,

                            child: RaisedButton(
                              elevation: 0.0,
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                    handleSubmitInfo();
                                }
                              },
                              color: Theme.of(context).primaryColorLight,
                              child: new Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: new Text("Submit",
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
              ),


          ],
        )

)

    );
  }
}
