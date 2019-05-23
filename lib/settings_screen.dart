import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  _deletePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Null> _confirmSignOut(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title:  Text("Sign Out"),
          content: Container(
            child: Text(
              "Are you sure you wish to sign out ?",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          actions: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    child: new Text(
                      "no",
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    child: new Text(
                      "yes",
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _deletePreferences();

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/', (Route<dynamic> route) => false);
                      // checkUserType();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        title: Text("Settings",style: TextStyle(fontSize: 20),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Privacy Policy",style: TextStyle(color:Colors.black.withOpacity(0.7),fontSize: 20),),
              trailing: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).accentColor
                ),
                child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Terms Of Service",style: TextStyle(color:Colors.black.withOpacity(0.7),fontSize: 20),),
              trailing: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor
                ),
                child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Clear Cache",style: TextStyle(color:Colors.black.withOpacity(0.7),fontSize: 20),),
              trailing: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor
                ),
                child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
              ),
            ),
            Divider(),
            InkWell(
              onTap: ()=>_confirmSignOut(context),


              child: ListTile(
                title: Text("Logout",style: TextStyle(color:Colors.black.withOpacity(0.7),fontSize: 20),),
                trailing: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).accentColor
                  ),
                  child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                ),
              ),
            ),
            Divider(),

          ],
        ),
      ),
    );
  }
}

