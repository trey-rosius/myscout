import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:myscout/utils/Config.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CreateSchedule extends StatefulWidget {
  @override
  _CreateScheduleState createState() => _CreateScheduleState();
}

class _CreateScheduleState extends State<CreateSchedule> {
  DateTime date;
  DateTime date1;
  DateTime date2;
  bool autovalidate = false;
  bool loading = false;
  bool isPrivate = false;
  List<String> weekDays = ['Mon','Tues','Wed','Thurs','Fri','Sat','Sun'];
  List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

  DateTime presentDate = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final dateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final scheduleTitleController = TextEditingController();
  final scheduleDescriptionController = TextEditingController();
  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }

   showInSnackBar(String value) {
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
   dateController.dispose();
   endTimeController.dispose();
   startTimeController.dispose();
   scheduleTitleController.dispose();
   scheduleDescriptionController.dispose();
    super.dispose();
  }


  saveSchedule(){
     setState(() {
       loading = true;
     });




      Map userInfo = new Map<String, dynamic>();
      userInfo[Config.scheduleTitle] = scheduleTitleController.text;
      userInfo[Config.scheduleDescription] = scheduleDescriptionController.text;
      userInfo[Config.scheduleStartTime] = startTimeController.text;
      userInfo[Config.scheduleEndTime] = endTimeController.text;
      userInfo[Config.scheduleDate] = dateController.text;
      userInfo[Config.scheduleDayName] = weekDays[date.weekday-1];
      userInfo[Config.scheduleDay] = date.day;
      userInfo[Config.scheduleMonth] = date.month;
      userInfo[Config.scheduleMonthName] = months[date.month-1];
      userInfo[Config.scheduleYear] = date.year;
      userInfo[Config.scheduleAdmin] = userId;
      isPrivate ? userInfo[Config.scheduleStatus] = Config.private : userInfo[Config.scheduleStatus] = Config.public;


      Firestore.instance.collection(Config.schedules).add(userInfo).then((DocumentReference docRef){
        String id = docRef.documentID;
        print("schedule Id "+id);
        Firestore.instance.collection(Config.schedules).document(docRef.documentID).updateData({
          Config.scheduleId:docRef.documentID
        });

        Firestore.instance.collection(Config.users).document(userId).collection(Config.userSchedules).document(id).setData({
          Config.scheduleId:id
        });

        setState(() {
          loading = false;
          isPrivate = false;

        });

        Navigator.of(context).pop();

      });









  }
  @override
  void initState() {
    super.initState();
    getUserId();

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
        appBar:
        AppBar(
        centerTitle: true,
        elevation: 0.0,

        title:Text("Create Schedule",style: TextStyle(fontSize: 20.0),),
        ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                child:  Form(
    key: formKey,
    autovalidate: autovalidate,
    child:

                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DateTimePickerFormField(

                        inputType: InputType.date,
                        format: DateFormat('yyyy-MM-dd'),
                        editable: true,
                        controller: dateController,


                        decoration: InputDecoration(

                            labelText: 'Select Date', hasFloatingPlaceholder: true,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                        onChanged: (dt) => setState((){

                          date = dt;


                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DateTimePickerFormField(
                        inputType: InputType.time,
                        format: DateFormat("HH:mm"),
                        editable: true,
                        controller: startTimeController,
                        decoration: InputDecoration(
                            labelText: 'Select Start Time', hasFloatingPlaceholder: false,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                        onChanged: (dt) => setState(() => date1 = dt),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DateTimePickerFormField(
                        inputType: InputType.time,
                        format: DateFormat("HH:mm"),
                        editable: true,
                        controller: endTimeController,
                        decoration: InputDecoration(
                            labelText: 'Select End Time', hasFloatingPlaceholder: false,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                        onChanged: (dt) => setState(() => date2 = dt),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: new TextFormField(
                        controller: scheduleTitleController,
                        maxLines: 2,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Title";
                          }
                        },


                        // enabled: false,
                        // keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          labelText: "Title",
                          contentPadding: new EdgeInsets.all(10.0),
                          filled: false,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: new TextFormField(
                        controller: scheduleDescriptionController,
                        maxLines: 5,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Description";
                          }
                        },


                        // enabled: false,
                        // keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          labelText: "Description",
                          contentPadding: new EdgeInsets.all(10.0),
                          filled: false,
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )
                        ),
                      ),
                    ),

                    Container(
                      child: CheckboxListTile(value: isPrivate, onChanged: ((bool value){
                        setState(() {
                          isPrivate = value;
                          print(value);
                        });
                      }),title: Text("Private ?",style: TextStyle(fontSize: 17.0),),),
                    ),
                    Column(
                      children: <Widget>[
                        loading == true
                            ? new CircularProgressIndicator()
                            : Container(
                          padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                          width: size.width / 1.3,
                          //  color: Theme.of(context).primaryColor,

                          child: RaisedButton(
                            elevation: 0.0,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                if(startTimeController.text == endTimeController.text){
                                  showInSnackBar("Start Time Equals End Time");
                                } else if((date.month < presentDate.month)|| (date.year < presentDate.year)){
                                  print(date.day);
                                  print(presentDate.day);
                                  print(date.month);
                                  print(presentDate.month);
                                  print(date.year);
                                  print(presentDate.year);
                                  showInSnackBar("Date is in the past. Please Choose a future date");
                                } else
                                  {
                                    print("this is ok");
                                    saveSchedule();
                                  }

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
                )
              ),
            ) ,
    );

  }
}
