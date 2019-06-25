import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class SoccerScreen extends StatefulWidget {
  SoccerScreen({this.userId});
  final String userId;

  @override
  _SoccerScreenState createState() => _SoccerScreenState();
}

class _SoccerScreenState extends State<SoccerScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.soccer)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            goalsController.text = snapshot[Config.goals];
            assistController.text = snapshot[Config.assist];
            savesController.text = snapshot[Config.saves];



          });

    });
  }
  

  final goalsController = TextEditingController();
  final assistController = TextEditingController();

  final savesController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;

  void handleSubmitInfo()
  {
    setState(() {
      loading = true;
    });

    Map map = new Map<String, dynamic>();
    map[Config.goals] = goalsController.text;
    map[Config.assist] = assistController.text;
    map[Config.saves] = savesController.text;


    map[Config.userId] = widget.userId;



    Firestore.instance.collection(Config.soccer).document(widget.userId).setData(map,merge: true).then((_){


showInSnackBar("Saved");
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


   goalsController.dispose();
   assistController.dispose();
   savesController.dispose();




  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Soccer",style: TextStyle(fontSize: 20.0),),

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
                              controller: goalsController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "GOALS";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "GOALS",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: assistController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "ASSISTS";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "ASSISTS",
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
                              controller: savesController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "SAVES";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "SAVES",
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
