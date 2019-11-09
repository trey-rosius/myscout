import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:myscout/post/aspect_ratio.dart';
import 'package:myscout/post/dash_path_border.dart';

import 'package:image_picker/image_picker.dart';
import 'package:myscout/utils/Config.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui show Image;
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
class CreatePost extends StatefulWidget {
  CreatePost({this.userId});
  final String userId;

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  Future<File> _imageFile;
  bool isVideo = false;
  VideoPlayerController _controller;
  VoidCallback listener;
  bool loading = false;
  File mainFile;
  bool isAward = false;
  File thumbnailFile;
  double progress = 0;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  ImageFormat _format = ImageFormat.JPEG;
  int _quality = 50;
  int _size = 0;
  int _timeMs = 0;



  int _imageFileSize;


  String _tempDir;


  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      if (_controller != null) {
        _controller.setVolume(0.0);
        _controller.removeListener(listener);
      }
      if (isVideo) {
        ImagePicker.pickVideo(source: source).then((File file) async{
          if (file != null && mounted)  {


            setState(() {
              mainFile = file;
              print("main file is"+mainFile.toString());
             print("video file is "+file.path.substring(7));
              _controller = VideoPlayerController.file(file)
                ..addListener(listener)
                ..setVolume(1.0)
                ..initialize()
                ..setLooping(true)
                ..play();
            });
          }
        });
      } else {
        _imageFile = ImagePicker.pickImage(source: source);
      }
    });
  }

  String userId;

  getUserId() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.get(Config.userId);
    });
  }




  //upload media
  Future<String> uploadMedia(var mediaFile, FirebaseStorage storage) async {

    print("gotten"+mediaFile.toString());
    var uuid = new Uuid().v1();

        StorageReference ref = storage
            .ref()
            .child(Config.users)
            .child(Config.posts)
            .child(userId)
            .child("$uuid.mp4");


        StorageUploadTask uploadTask = ref.putFile(mediaFile);
        StorageTaskSnapshot storageTask = await uploadTask.onComplete;
        String downloadUrl = await storageTask.ref.getDownloadURL();
        return downloadUrl;


  }

  //upload media
  Future<String> uploadImageMedia(var mediaFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();

    StorageReference ref = storage
        .ref()
        .child(Config.users)
        .child(Config.posts)
        .child(userId)
        .child("$uuid.mp4");


    StorageUploadTask uploadTask = ref.putFile(mediaFile);
    StorageTaskSnapshot storageTask = await uploadTask.onComplete;
    String downloadUrl = await storageTask.ref.getDownloadURL();
    return downloadUrl;


  }

  //upload media
  Future<String> uploadThumbnailMedia(var mediaFile, FirebaseStorage storage) async {
    var uuid = new Uuid().v1();

      StorageReference ref = storage
          .ref()
          .child(Config.users)
          .child(Config.posts)
          .child(userId)
          .child("$uuid.jpg");

      StorageUploadTask uploadTask = ref.putData(mediaFile);
      StorageTaskSnapshot storageTask = await uploadTask.onComplete;
      String downloadUrl = await storageTask.ref.getDownloadURL();
      return downloadUrl;


  }
  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);

      _controller.removeListener(listener);

    }
    super.deactivate();
  }

  void logCallback(int level, String message) {
    print("this is log message"+message);
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();

    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getTemporaryDirectory().then((d) => _tempDir = d.path);

    getUserId();
    listener = () {

      if(!mounted){
        return;
      }else
        {
          setState(() {});
        }

    };
  }


  savePost()async {



    if(isVideo)
      {
        setState(() {
          loading = true;
        });

        final thumbnail = await VideoThumbnail.thumbnailData(
            video: Platform.isIOS ? mainFile.path.substring(7) : mainFile.path,
            imageFormat: _format,
           // maxHeightOrWidth: _size,
            timeMs: _timeMs,
            quality: _quality);




        setState(() {
          /*
          if(Platform.isIOS)
            {
              mainFile = File(mainFile.path.substring(7));

            }else
              {
                mainFile = mainFile;
              }
              */

         // thumbnailFile = file;
        });
     //   var dir = await path_provider.getApplicationDocumentsDirectory();
     //   var uuid = new Uuid().v1();
       // var targetPath = dir.absolute.path + "/temp.mp4";
        Directory appDocDir = await getTemporaryDirectory();
        String targetPath = appDocDir.path+"/temp.mp4";
        _flutterFFmpeg.enableLogCallback(this.logCallback);
        var arguments = ["-i", mainFile.path, "-c:v", "mpeg4", targetPath];
        _flutterFFmpeg.executeWithArguments(arguments).then((rc){
          if(rc == 0)
            {


              final FirebaseStorage storage = FirebaseStorage.instance;
              uploadMedia(File(targetPath), storage).then((String data) {


                Map userInfo = new Map<String, dynamic>();
                userInfo[Config.postText] = postController.text;
                userInfo[Config.isVideoPost] = isVideo;
                userInfo[Config.isAward] = isAward;
                userInfo[Config.postVideoUrl] = data;
                userInfo[Config.createdOn] =FieldValue.serverTimestamp();
                userInfo[Config.postAdminId] = userId;
                userInfo[Config.awardYear] = yearController.text;

                Firestore.instance.collection(Config.posts).add(userInfo).then((DocumentReference docRef){
                  String id = docRef.documentID;
                  print("post Id "+id);
                  Firestore.instance.collection(Config.posts).document(docRef.documentID).updateData({
                    Config.postId:docRef.documentID
                  });

                  Firestore.instance.collection(Config.users).document(userId).collection(Config.userPosts).document(id).setData({
                    Config.postId:id
                  });

                  uploadThumbnailMedia(thumbnail, storage).then((String data) {
                    Firestore.instance.collection(Config.posts).document(docRef.documentID).updateData({
                      Config.postVideoThumbUrl:data
                    });

                    setState(() {
                      loading = false;
                      mainFile = null;
                      targetPath = null;
                      _controller = null;
                      _imageFile = null;
                      progress = 0.0;

                      postController.text = "";
                      isAward = false;
                    });
                  });

                });




              });

            }else
              {
                print('ffmpeg finished with rc code $rc');
              }
        });



        print("file is"+ mainFile.path);

/*
        _flutterFFmpeg.getMediaInformation(targetPath).then((info) {
          print("Media Information");

          print("Path: ${info['path']}");
          print("Format: ${info['format']}");
          print("Duration: ${info['duration']}");
          print("Start time: ${info['startTime']}");
          print("Bitrate: ${info['bitrate']}");


        });

*/


      }
      else
        {
          setState(() {
            loading = true;
          });
          final FirebaseStorage storage = FirebaseStorage.instance;
          uploadImageMedia(mainFile, storage).then((String data) {


            Map userInfo = new Map<String, dynamic>();
            userInfo[Config.postText] = postController.text;
            userInfo[Config.isVideoPost] = isVideo;
            userInfo[Config.isAward] = isAward;
            isVideo ? userInfo[Config.postVideoUrl] = data : userInfo[Config.postImageUrl] = data;
            userInfo[Config.createdOn] =FieldValue.serverTimestamp();
            userInfo[Config.postAdminId] = userId;
            userInfo[Config.awardYear] = yearController.text;

            Firestore.instance.collection(Config.posts).add(userInfo).then((DocumentReference docRef){
              String id = docRef.documentID;
              print("post Id "+id);
              Firestore.instance.collection(Config.posts).document(docRef.documentID).updateData({
                Config.postId:docRef.documentID
              });

              Firestore.instance.collection(Config.users).document(userId).collection(Config.userPosts).document(id).setData({
                Config.postId:id
              });

            });


            setState(() {
              loading = false;
              mainFile = null;
              _controller = null;
              _imageFile = null;
              postController.text="";
              isAward = false;
            });



          });
        }




  }
  Widget _previewVideo(VideoPlayerController controller) {
    if (controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    } else if (controller.value.initialized) {

      return AspectRatioVideo(controller);

    } else {
      return const Text(
        'Error Loading Video',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {

              mainFile = snapshot.data;


            return Image.file(snapshot.data);
          } else if (snapshot.error != null) {
            return const Text(
              'Error picking image.',
              textAlign: TextAlign.center,
            );
          } else {
            return Center(
              child: Text(
                'Upload Image/Video/Award',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Theme.of(context).primaryColorLight),
              ),
            );
          }
        });
  }
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final postController = TextEditingController();
  final yearController = TextEditingController();
  bool autovalidate = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
     key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child:
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF55b9b6).withOpacity(0.2),
                    border: DashPathBorder.all(
                      dashArray: CircularIntervalList<double>(<double>[5.0, 2.5])

                    ),
                  ),
                padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  height: size.height/3,
                  child: isVideo ? _previewVideo(_controller) : _previewImage()),

          ),
           isVideo ? SliverToBoxAdapter(
             child: Container(),
           ) :
           SliverToBoxAdapter(
             child: Container(
               child: CheckboxListTile(value: isAward, onChanged: ((bool value){
                 setState(() {
                   isAward = value;
                   print(value);
                 });
               }),title: Text("Is Selected Image An Award ?",style: TextStyle(fontSize: 17.0),),),
             ),

           ),
           /*
           isVideo ?SliverToBoxAdapter(
             child: Padding(padding: EdgeInsets.all(10),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: Text("Video Compressing...",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                 ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LinearPercentIndicator(
                         width: MediaQuery.of(context).size.width/1.5,
                         lineHeight: 14.0,
                         percent: progress == 0 ? 0 : double.parse(progress.toStringAsFixed(1)),
                         center: Text(progress.toStringAsFixed(1)),
                         backgroundColor: Colors.grey,
                         progressColor: Colors.blue,

                 ),
                    ],
                  ),
               ],
             ),),
           ): SliverToBoxAdapter(
           child: Container(),
           ),
           */
           SliverToBoxAdapter(
             child: Padding(
               padding: const EdgeInsets.only(top:20.0,left: 10.0),
               child: Text("Write Post",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
             ),
             
           ),

           SliverToBoxAdapter(
             child: Container(
               padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
               child: Form(
                key: formKey,
                autovalidate: autovalidate,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isAward ?
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {

                          if (value.isEmpty) {
                            return "Award Year";
                          }
                        },
                        maxLength: 4,
                        controller: yearController,

                        decoration: new InputDecoration(
                            labelText: "Award Year",

                            contentPadding: new EdgeInsets.all(12.0),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ) :
                        Container(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0.0),
                      child: new TextFormField(

                        validator: (value) {

                          if (value.isEmpty) {
                            return "Please Write a Post";
                          }
                        },

                        controller: postController,
                         maxLines: 10,
                        decoration: new InputDecoration(
                            labelText: "Write Post..",

                            contentPadding: new EdgeInsets.all(12.0),
                            border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  width: 2.0, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
          ),
             ),
           ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                loading == true
                    ? new CircularProgressIndicator()
                    : Container(
                  padding: EdgeInsets.only(top: 20.0,bottom: 20.0),

                  width: size.width / 1.5,
                  //  color: Theme.of(context).primaryColor,

                  child: RaisedButton(
                    elevation: 0.0,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                         savePost();
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
          ),
      ]),


      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              isVideo = false;
              _onImageButtonPressed(ImageSource.gallery);
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.image),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
             
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.gallery);
              },
              heroTag: 'video0',
              tooltip: 'Pick Video from gallery',
              child: const Icon(Icons.videocam),
            ),
          ),

        ],
      ),
    );
  }
}
