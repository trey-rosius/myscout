import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';

import 'package:myscout/post/aspect_ratio.dart';
import 'package:myscout/post/dash_path_border.dart';

import 'package:image_picker/image_picker.dart';
import 'package:myscout/utils/Config.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:video_player/video_player.dart';
class CreatePost extends StatefulWidget {
  CreatePost({this.userId});
  final String userId;

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  FlutterVideoCompress _flutterVideoCompress = FlutterVideoCompress();
  Future<File> _imageFile;
  bool isVideo = false;
  VideoPlayerController _controller;
  VoidCallback listener;
  bool loading = false;
  File mainFile;
  bool isAward = false;
  File thumbnailFile;
  double progress = 0;
  Uint8List _image;
  Subscription _subscription;
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
    var uuid = new Uuid().v1();

    if(isVideo)
      {
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
      else
        {
          StorageReference ref = storage
              .ref()
              .child(Config.users)
              .child(Config.posts)
              .child(userId)
          .child("$uuid.jpg");

          StorageUploadTask uploadTask = ref.putFile(mediaFile);
          StorageTaskSnapshot storageTask = await uploadTask.onComplete;
          String downloadUrl = await storageTask.ref.getDownloadURL();
          return downloadUrl;
        }

  }
  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);

      _controller.removeListener(listener);

    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
      _subscription.unsubscribe();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progressPercent) {
          print('progress: $progressPercent');
          setState(() {
            progress = progressPercent/100;
          });
        });
    getUserId();
    listener = () {

      setState(() {});
    };
  }


  savePost()async {

    if(isVideo)
      {
        setState(() {
          loading = true;
        });
        final thumbnail = await _flutterVideoCompress.getThumbnailWithFile(
          mainFile.path,
          quality: 50,
        );
        print("original thumbnail"+thumbnail.toString());

        final MediaInfo info = await _flutterVideoCompress.startCompress(
          mainFile.path,
          deleteOrigin: false,
        );
        print(info.toJson());
        print("video path"+info.path);

        setState(() {
          mainFile = File(info.path);
          thumbnailFile = thumbnail;
        });
        print("thumbnail File"+thumbnailFile.toString());
        final FirebaseStorage storage = FirebaseStorage.instance;
        uploadMedia(mainFile, storage).then((String data) {


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

            uploadMedia(thumbnailFile, storage).then((String data) {
              Firestore.instance.collection(Config.posts).document(docRef.documentID).updateData({
                Config.postVideoThumbUrl:data
              });

              setState(() {
                loading = false;
                mainFile = null;
                _controller = null;
                _imageFile = null;
                progress = 0.0;
                _subscription = null;
                postController.text = "";
                isAward = false;
              });
            });

          });




        });

      }
      else
        {
          setState(() {
            loading = true;
          });
          final FirebaseStorage storage = FirebaseStorage.instance;
          uploadMedia(mainFile, storage).then((String data) {


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

      return  AspectRatioVideo(controller);

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
