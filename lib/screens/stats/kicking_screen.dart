import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class KickingScreen extends StatefulWidget {
  KickingScreen({this.userId});
  final String userId;

  @override
  _KickingScreenState createState() => _KickingScreenState();
}

class _KickingScreenState extends State<KickingScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.kicking)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            fgmController.text = snapshot[Config.fgm];
            fgaController.text = snapshot[Config.fga];
            pctController.text = snapshot[Config.pct];

            lngController.text = snapshot[Config.lng];
            xpmController.text = snapshot[Config.xpm];
            xpaController.text = snapshot[Config.xpa];
            pct2Controller.text = snapshot["PCT_2"];

          });

    });
  }
  

  final fgmController = TextEditingController();
  final fgaController = TextEditingController();

  final pctController = TextEditingController();
  final lngController = TextEditingController();
  final xpmController = TextEditingController();
  final xpaController = TextEditingController();
  final pct2Controller = TextEditingController();

  bool autovalidate = false;
  bool loading = false;

  void handleSubmitInfo()
  {
    setState(() {
      loading = true;
    });

    Map map = new Map<String, dynamic>();
    map[Config.fgm] = fgmController.text;
    map[Config.fga] = fgaController.text;
    map[Config.pct] = pctController.text;
    map[Config.lng] = lngController.text;

    map[Config.xpm] = xpmController.text;
    map[Config.xpa] = xpaController.text;
    map["PCT_2"] = pct2Controller.text;

    map[Config.userId] = widget.userId;



    Firestore.instance.collection(Config.kicking).document(widget.userId).setData(map).then((_){



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


   fgmController.dispose();
   fgaController.dispose();
   pctController.dispose();
   lngController.dispose();
   xpmController.dispose();
   xpaController.dispose();
   pct2Controller.dispose();



  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Kicking",style: TextStyle(fontSize: 20.0),),

      ),
      body: SingleChildScrollView(

        child:Column(
          children: <Widget>[

            Container(
              padding: EdgeInsets.all(10),
              child:Text("Field Goals",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                              controller: fgmController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "FGM";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "FGM",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                          Container(

                            width: size.width/3,
                            child: new TextFormField(
                              controller: fgaController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "FGA";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "FGA",
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
                              controller: pctController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "PCT";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "PCT",
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



                              // enabled: false,
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
                              controller: xpmController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "XPM";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "XPM",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width/3,
                            margin: EdgeInsets.all(10),
                            child: new TextFormField(
                              controller: xpaController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "XPA";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "XPA",
                                contentPadding: new EdgeInsets.all(10.0),
                                filled: false,
                              ),
                            ),
                          ),

                        ],
                      ),

                      Container(
                        width: size.width/3,
                        margin: EdgeInsets.all(10),
                        child: new TextFormField(
                          controller: pct2Controller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "PCT";
                            }
                          },



                          // enabled: false,
                          // keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                            labelText: "PCT",
                            contentPadding: new EdgeInsets.all(10.0),
                            filled: false,
                          ),
                        ),
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
