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
  static final String isAward = "isAward";
  static final String awardYear = "awardYear";


  static final String posts = "posts";
  static final String postId = "postId";
  static final String postText = "postText";
  static final String isVideoPost = "isVideoPost";
  static final String postVideoUrl = "postVideoUrl";
  static final String postVideoThumbUrl = "postVideoUrl";
  static final String postImageUrl = "postImageUrl";
  static final String postAdminId = "postAdminId";
  static final String userPosts = "userPosts";
  static final String likedPosts = "likedPosts";
  static final String likes = "likes";
  static final String like = "like";


  static final String comments = "comments";
  static final String comment = "comment";
  static final String commentId = "commentId";
  static final String commentText = "commentText";
  static final String commentAdminId = "commentAdminId";


  static final String notifications = "notifications";
  static final String notificationId = "notificationId";
  static final String notificationType= "notificationType";
  static final String notificationText = "notificationText";
  static final String senderId = "senderId";
  static final String receiverId = "receiverId";



  static final String linkId= "linkId";
  static final String linkTitle = "linkTitle";
  static final String linkImage = "linkImage";
  static final String linkDescription= "linkDesc";
  static final String linkUrl= "linkUrl";
  static final String linkAdmin= "linkAdmin";
  static final String news= "news";
  static final String linkPreviewAccessKey = "5cb391178d1789407be1bd4c5f4d01dd9b1a971290160";


  static final String chats= "chats";
  static final String typing= "typing...";
  static final String imageUrl= "imageUrl";
  static final String messageType= "messageType";
  static final String messageId= "messageId";
  static final String message= "message";
  static final String text= "text";
  static final String image= "image";
  static final String chatThread= "chatThread";
  static final String receiver= "chatThread";
  static final String visible= "visible";
  static final String chatList= "chatList";

  static final String schedules= "schedules";
  static final String userSchedules= "userSchedules";
  static final String scheduleDayName= "scheduleDayName";
  static final String scheduleDay= "scheduleDay";
  static final String scheduleMonth= "scheduleMonth";
  static final String scheduleMonthName= "scheduleMonthName";
  static final String scheduleYear= "scheduleYear";
  static final String scheduleId= "scheduleId";
  static final String scheduleAdmin= "scheduleAdmin";
  static final String scheduleStartTime= "scheduleStartTime";
  static final String scheduleDate= "scheduleDate";
  static final String scheduleEndTime= "scheduleEndTime";
  static final String scheduleTitle= "scheduleTitle";
  static final String scheduleDescription= "scheduleDescription";
  static final String scheduleStatus= "scheduleStatus";
  static final String private= "private";
  static final String public= "public";








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