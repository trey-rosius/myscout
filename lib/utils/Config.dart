import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
class Config{

  static final String storageBucket = "gs://cori-b6795.appspot.com/";



   ///  User constants

  static final String users = "Users";
  static final String admin = "admin";
  static final String address = "address";
  static final String userId = "userId";
  static final String profilePic = "profilePic";
  static final String profilePicUrl = "profilePicUrl";
  static final String fullNames = "fullNames";
  static final String dob = "dob";
  static final String location = "location";
  static final String shortBio = "shortBio";
  static final String schoolOrOrg = "schoolOrOrganisation";
  static final String gpa = "gpa";
  static final String actSat = "act_sat";
  static final String CLASS = "class";
  static final String selectSport = "selectSport";
  static final String position = "position";
  static final String height = "height";
  static final String weight = "weight";
  static final String createdOn = "createdOn";
  static final String url = "url";
  static final String athletes = "athletes";
  static final String coaches = "coaches";




  static final String email = "email";
  static final String phoneNumer= "phoneNumber";


  static Future<FirebaseApp> firebaseConfig() async {
    final FirebaseApp app = await FirebaseApp.configure(
      name: 'myscout',
      options: Platform.isIOS
          ? const FirebaseOptions(
          googleAppID: '1:848926512775:ios:561460bffabbaedc',
          gcmSenderID: '848926512775',
          apiKey: 'AIzaSyBtHK-FP-4OYoSRYzqlWHVTjLwUI-NgU3Q',
          projectID: 'myscout-c1383',
          bundleID: 'com.relevantsystems.myscout')
          : const FirebaseOptions(
        googleAppID: '1:848926512775:android:561460bffabbaedc',
        apiKey: 'AIzaSyBtHK-FP-4OYoSRYzqlWHVTjLwUI-NgU3Q',
        projectID: 'myscout-c1383',
      ),
    );
    return app;
  }
}