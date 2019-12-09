import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myscout/utils/Config.dart';
class ScheduleItem extends StatelessWidget {
  ScheduleItem({this.userId,this.document});
  final String userId;
  final DocumentSnapshot document;

  Future<Null> deleteConfirmation(BuildContext context,String scheduleId) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(

          child: AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,

            content: Container(
                height: 120.0,

                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/myscout.png'),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Are you sure you want to delete this Schedule ?",style: TextStyle(
                          color: Colors.white,fontSize: 18.0
                      ),),
                    )
                  ],
                )
            ),
            actions: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "No",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();


                    // checkUserType();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: new Text(
                    "Yes",
                    style: TextStyle(fontSize: 14.0,color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Firestore.instance.collection(Config.users).document(Config.userId).collection(Config.userSchedules).document(scheduleId).delete();
                    Firestore.instance.collection(Config.schedules).document(scheduleId).delete();


                    // checkUserType();
                  },
                ),
              ),

            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        if(userId == document[Config.scheduleAdmin])
          {
            deleteConfirmation(context, document[Config.scheduleId]);
          }
          else
            {

            }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(document[Config.scheduleDayName],style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColorLight),),
                  Text(document[Config.scheduleMonthName],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorLight),),
                  Text(document[Config.scheduleDay].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)

                ],
              ),
            ),
            Expanded(
              child:

               Material(
                 color: Colors.white,
                 elevation: 14.0,
                 borderRadius: BorderRadius.circular(10.0),
                 shadowColor: Color(0x802196F3),
                 child:Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(document[Config.scheduleStartTime] + "-" + document[Config.scheduleEndTime],style:
                                   TextStyle(fontSize: 16),),
                                   Text(document[Config.scheduleStatus],style: TextStyle(color: Theme.of(context).primaryColorLight,fontWeight: FontWeight.bold),)
                                 ],
                               ),
                               Divider(),
                               Padding(
                                 padding: const EdgeInsets.only(top:10.0),
                                 child: Text(document[Config.scheduleTitle],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorLight),),
                               ),
                               Text(document[Config.scheduleDescription],style: TextStyle(fontSize: 17,)),

                             ],
                           ),
                 ),
                       ),







            )
          ],
        ),
      ),
    );
  }
}

