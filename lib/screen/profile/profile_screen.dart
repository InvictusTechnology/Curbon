import 'dart:io';
import 'package:curbonapp/signin/signin_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  File _image;
  bool showSpinner = false;
  bool noUser = false;
  bool hasProfilePic = false;
  String userPhoto = 'assets/avatar.png';
  String name = '';
  String email = '';
  int point = 0;
  int level = 0;

  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://curbontest1.appspot.com');

  void startUpload(String userName) {
    StorageUploadTask _task;
    String filePath = 'images/$userName.png';

    setState(() {
      _task = _storage.ref().child(filePath).putFile(_image);
    });

    final ref = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${loggedInUser.email}.png');

    setState(() async {
      userPhoto = await ref.getDownloadURL() as String;
    });
  }

  Future chooseFile() async {
    setState(() {
      showSpinner = true;
    });
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();

      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
        });
      });
      startUpload(loggedInUser.email);
      updateInfo.photoUrl = _image.path;

      await loggedInUser.updateProfile(updateInfo);
      await loggedInUser.reload();
      loggedInUser = await _auth.currentUser();

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      throw e;
    }
  }

  void getUserProfile() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        var profile =
            await _firestore.collection('profile').document(user.email).get();
        point = profile.data['point'];
        level = profile.data['level'];
        name = user.displayName;
        email = user.email;
        if (user.photoUrl != null) userPhoto = user.photoUrl;
        final ref = FirebaseStorage.instance
            .ref()
            .child('images')
            .child('${loggedInUser.email}.png');
        try {
          userPhoto = await ref.getDownloadURL() as String;
          setState(() {
            showSpinner = false;
            hasProfilePic = true;
            print(userPhoto);
          });
        } catch (e) {
          setState(() {
            showSpinner = false;
          });
          throw e;
        }
      } else {
        setState(() {
          noUser = true;
          showSpinner = false;
        });
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Align detailText(String text) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, top: 5),
        child: Text(
          text,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1b1b1b),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  void initState() {
    showSpinner = true;
    super.initState();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacementNamed(
            context, loggedInUser != null ? 'loading_home' : '/');
      },
      child: Scaffold(
        backgroundColor: Color(0xFF26CB7E),
        bottomNavigationBar: BottomBar(selectedIndex: 3),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF58d178),
                        Color(0xFF26CB7E),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: !noUser,
                            child: Container(
                              width: 80,
                              child: GestureDetector(
                                onTap: () async {
                                  _auth.signOut();
                                  googleSignIn.signOut();
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('email');
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.exit_to_app,
                                      size: 22,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !noUser,
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  chooseFile();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Edit ',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          if (hasProfilePic)
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userPhoto)),
                        ],
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            detailText(name),
                            detailText(email),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/circle.png',
                                      height: 15,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Current Point',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                Text(
                                  point.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/circle.png',
                                      height: 15,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Current Level',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 130,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                Text(
                                  level.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.2),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                            offset: Offset(0, -5.0),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          linkButtons(
                              text: 'Introduction',
                              iconData: Icons.sentiment_very_satisfied,
                              onPress: () {
                                Navigator.pushNamed(context, '/intro_pages');
                              }),
                          linkButtons(
                              text: 'How this works',
                              iconData: Icons.info_outline),
                          linkButtons(text: 'About us', iconData: Icons.public),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget linkButtons({String text, IconData iconData, Function onPress}) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF26CB7E),
            ),
          ),
        ),
        child: GestureDetector(
          onTap: onPress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                iconData,
                size: 25,
                color: Color(0xFF26CB7E),
              ),
              SizedBox(width: 5),
              Text(text,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
