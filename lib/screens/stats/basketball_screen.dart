import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class BasketBallScreen extends StatefulWidget {
  BasketBallScreen({this.userId});
  final String userId;

  @override
  _BasketBallScreenState createState() => _BasketBallScreenState();
}

class _BasketBallScreenState extends State<BasketBallScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.basketball)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            ppgController.text = snapshot[Config.ppg];
            rpgController.text = snapshot[Config.rpg];
            apgController.text = snapshot[Config.apg];

            spgController.text = snapshot[Config.spg];
            bpgController.text = snapshot[Config.bpg];
            fgPercentageController.text = snapshot[Config.fgPercentage];
            ftPercentageController.text = snapshot[Config.ftPercentage];

          });

    });
  }
  

  final ppgController = TextEditingController();
  final rpgController = TextEditingController();

  final apgController = TextEditingController();
  final spgController = TextEditingController();
  final bpgController = TextEditingController();
  final fgPercentageController = TextEditingController();
  final ftPercentageController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;

  void handleSubmitInfo()
  {
    setState(() {
      loading = true;
    });

    Map map = new Map<String, dynamic>();
    map[Config.ppg] = ppgController.text;
    map[Config.rpg] = rpgController.text;
    map[Config.apg] = apgController.text;
    map[Config.spg] = spgController.text;

    map[Config.bpg] = bpgController.text;
    map[Config.fgPercentage] = fgPercentageController.text;
    map[Config.ftPercentage] = ftPercentageController.text;

    map[Config.userId] = widget.userId;



    Firestore.instance.collection(Config.basketball).document(widget.userId).setData(map).then((_){



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


   ppgController.dispose();
   rpgController.dispose();
   apgController.dispose();
   spgController.dispose();
   bpgController.dispose();
   fgPercentageController.dispose();
   ftPercentageController.dispose();



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
                              controller: ppgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "PPG";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "PPG",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: rpgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "RPG";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "RPG",
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
                              controller: apgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "APG";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "APG",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: spgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "SPG";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "SPG",
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
                              controller: bpgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "BPG";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "BPG",
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
                              controller: fgPercentageController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "FG%";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "FG%",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: ftPercentageController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "FT%";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "FT%",
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
