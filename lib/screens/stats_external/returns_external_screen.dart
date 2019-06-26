import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class ReturnsExternalScreen extends StatefulWidget {
  ReturnsExternalScreen({this.userId});
  final String userId;

  @override
  _ReturnsExternalScreenState createState() => _ReturnsExternalScreenState();
}

class _ReturnsExternalScreenState extends State<ReturnsExternalScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.returns)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            attController.text = snapshot[Config.att];
            lngController.text = snapshot[Config.lng];


            ydsController.text = snapshot[Config.yds];
            tdController.text = snapshot[Config.td];
            avgController.text = snapshot[Config.avg];
            avgPuntsController.text = snapshot["punts_att"];
            ydsPuntsController.text = snapshot["punts_yds"];
            attPuntsController.text = snapshot["punts_att"];
            lngPuntsController.text = snapshot["punts_lng"];
            tdPuntsController.text = snapshot["punts_td"];


          });

    });
  }
  

  final attController = TextEditingController();
  final attPuntsController = TextEditingController();
  final avgController = TextEditingController();
  final avgPuntsController = TextEditingController();

  final lngController = TextEditingController();
  final lngPuntsController = TextEditingController();
  final ydsController = TextEditingController();
  final ydsPuntsController = TextEditingController();
  final tdController = TextEditingController();
  final tdPuntsController = TextEditingController();






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


   attController.dispose();
   ydsController.dispose();
   ydsPuntsController.dispose();
   lngController.dispose();
   avgController.dispose();
   tdController.dispose();
   tdPuntsController.dispose();
   avgPuntsController.dispose();
   attPuntsController.dispose();
   lngPuntsController.dispose();



  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Returns",style: TextStyle(fontSize: 20.0),),

      ),
      body: SingleChildScrollView(

        child:Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
              child:Text("KICKOFFS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                        padding: EdgeInsets.all(10),
                        child:Text("PUNTS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),

                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: <Widget>[
                         Container(
                           width: size.width/2,
                           margin: EdgeInsets.all(10),
                           child: new TextFormField(
                             controller: attPuntsController,
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
                           margin: EdgeInsets.all(10),
                           child: new TextFormField(
                             controller: ydsPuntsController,
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
                              controller: avgPuntsController,
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
                              controller: lngPuntsController,
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
                      Container(
                        margin:EdgeInsets.only(left: 25,right: 10) ,

                        child: new TextFormField(
                          controller: tdPuntsController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "TD";
                            }
                          },



                          enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "TD",
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
