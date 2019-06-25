import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/models/defense_model.dart';
import 'package:myscout/utils/Config.dart';

class BaseBallScreen extends StatefulWidget {
  BaseBallScreen({this.userId});
  final String userId;

  @override
  _BaseBallScreenState createState() => _BaseBallScreenState();
}

class _BaseBallScreenState extends State<BaseBallScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();


  loadingInfomation(){

    Firestore.instance
        .collection(Config.baseball)
        .document(widget.userId)

        .get()
        .then((DocumentSnapshot snapshot) {
          setState(() {

            avgController.text = snapshot[Config.avg];
            rbisController.text = snapshot[Config.rbis];
            hrController.text = snapshot[Config.hr];



          });

    });
  }
  

  final avgController = TextEditingController();
  final rbisController = TextEditingController();

  final hrController = TextEditingController();

  bool autovalidate = false;
  bool loading = false;

  void handleSubmitInfo()
  {
    setState(() {
      loading = true;
    });

    Map map = new Map<String, dynamic>();
    map[Config.avg] = avgController.text;
    map[Config.rbis] = rbisController.text;
    map[Config.hr] = hrController.text;


    map[Config.userId] = widget.userId;



    Firestore.instance.collection(Config.baseball).document(widget.userId).setData(map,merge: true).then((_){


     showInSnackBar("Saved");
      setState(() {
        loading= false;
      });

    });



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


   avgController.dispose();
   rbisController.dispose();
   hrController.dispose();




  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
     appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("BaseBall",style: TextStyle(fontSize: 20.0),),

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
                              controller: avgController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "AVG";
                                }
                              },


                              // enabled: false,
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
                            child: new TextFormField(
                              controller: rbisController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "RBI'S";
                                }
                              },


                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "RBI's",
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
                              controller: hrController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "HR";
                                }
                              },



                              // enabled: false,
                              // keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                labelText: "HR",
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
