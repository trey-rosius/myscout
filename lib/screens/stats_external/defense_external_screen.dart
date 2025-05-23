import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class DefenseExternalScreen extends StatefulWidget {
  DefenseExternalScreen({this.userId});
  final String userId;

  @override
  _DefenseExternalScreenState createState() => _DefenseExternalScreenState();
}

class _DefenseExternalScreenState extends State<DefenseExternalScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.defense)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            soloController.text = snapshot[Config.solo];
            astController.text = snapshot[Config.ast];
            totalController.text = snapshot[Config.total];
            avgController.text = snapshot[Config.avg];
            tflController.text = snapshot[Config.tfl];
            sacksController.text = snapshot[Config.sacks];
            pbuController.text = snapshot[Config.pbu];
            intController.text = snapshot[Config.ints];
            ffController.text = snapshot[Config.ff];
            recController.text = snapshot[Config.rec];
          });

    });
  }
  
  Defense defense = Defense();
  final soloController = TextEditingController();
  final astController = TextEditingController();
  final totalController = TextEditingController();
  final avgController = TextEditingController();
  final tflController = TextEditingController();
  final sacksController = TextEditingController();
  final pbuController = TextEditingController();
  final intController = TextEditingController();
  final ffController = TextEditingController();
  final recController = TextEditingController();
  bool autovalidate = false;
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

   soloController.dispose();
   astController.dispose();
   totalController.dispose();
   avgController.dispose();
   tflController.dispose();
   sacksController.dispose();
   pbuController.dispose();
   intController.dispose();
   ffController.dispose();
   recController.dispose();


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
                              controller: soloController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "SOLO";
                                }
                              },
                              onSaved: ((String value){
                                defense.solo = int.parse(value.trim());
                              }),

                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "SOLO",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: astController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AST";
                                }
                              },
                              onSaved: ((String value){
                                defense.ast = int.parse(value.trim());
                              }),

                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AST",
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
                              controller: totalController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "TOTAL";
                                }
                              },
                              onSaved: ((String value){
                                defense.total= int.parse(value.trim());
                              }),


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "TOTAL",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: avgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AVG";
                                }
                              },
                              onSaved: ((String value){
                                defense.avg= int.parse(value.trim());
                              }),


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "AVG",
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
                              controller: tflController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "TFL";
                                }
                              },
                              onSaved: ((String value){
                                defense.tfl = int.parse(value.trim());
                              }),

                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "TFL",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: sacksController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "SACKS";
                                }
                              },
                              onSaved: ((String value){
                                defense.sacks= int.parse(value.trim());
                              }),


                               enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "SACKS",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                        ],
                      ),

                      Container(
                        margin:EdgeInsets.only(left: 25,right: 10) ,
                        child: new TextFormField(
                          controller: pbuController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "PBU'S";
                            }
                          },
                          onSaved: ((String value){
                            defense.pbus= int.parse(value.trim());
                          }),


                           enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "PBU'S",
                            contentPadding: new EdgeInsets.all(10.0),
                            filled: false,
                          ),
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.only(left: 25,right: 10) ,
                        child: new TextFormField(
                          controller: intController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "INT'S";
                            }
                          },
                          onSaved: ((String value){
                            defense.ints= int.parse(value.trim());
                          }),


                           enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "INT'S",
                            contentPadding: new EdgeInsets.all(10.0),
                            filled: false,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text("FUMBLES",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),

                      Container(
                        margin:EdgeInsets.only(left: 25,right: 10) ,
                        child: new TextFormField(
                          controller: ffController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "FF";
                            }
                          },
                          onSaved: ((String value){
                            defense.ff= int.parse(value.trim());
                          }),


                           enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "FF",
                            contentPadding: new EdgeInsets.all(10.0),
                            filled: false,
                          ),
                        ),
                      ),
                      Container(

                        margin:EdgeInsets.only(left: 25,right: 10) ,
                        child: new TextFormField(
                          controller: recController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "REC";
                            }
                          },
                          onSaved: ((String value){
                            defense.rec= int.parse(value.trim());
                          }),


                           enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "REC",
                            contentPadding: new EdgeInsets.all(10.0),
                            filled: false,
                          ),
                        ),
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
