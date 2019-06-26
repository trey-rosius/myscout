import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class RushingExternalScreen extends StatefulWidget {
  RushingExternalScreen({this.userId});
  final String userId;

  @override
  _RushingExternalScreenState createState() => _RushingExternalScreenState();
}

class _RushingExternalScreenState extends State<RushingExternalScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.rushing)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            attController.text = snapshot[Config.att];
            ydsController.text = snapshot[Config.yds];
            avgController.text = snapshot[Config.avg];

            lngController.text = snapshot[Config.lng];
            tdController.text = snapshot[Config.td];
            ydsgController.text = snapshot[Config.ydsg];

          });

    });
  }
  

  final attController = TextEditingController();
  final ydsController = TextEditingController();

  final avgController = TextEditingController();
  final lngController = TextEditingController();
  final tdController = TextEditingController();
  final ydsgController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;



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


   attController.dispose();
   ydsgController.dispose();
   ydsController.dispose();
   avgController.dispose();
   lngController.dispose();
   tdController.dispose();



  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Defense",style: TextStyle(fontSize: 20.0),),

      ),
      body: SingleChildScrollView(

        child:Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
              child:Text("TACKLES",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),


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
                              controller: attController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "ATT";
                                }
                              },


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "ATT",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: ydsController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "YDS";
                                }
                              },


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "YDS",
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
                              controller: avgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AVG";
                                }
                              },



                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AVG",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: lngController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "LNG";
                                }
                              },



                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "LNG",
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
                              controller: tdController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "TD";
                                }
                              },


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "TD",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: ydsgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "YDS/G";
                                }
                              },



                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "YDS/G",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
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
