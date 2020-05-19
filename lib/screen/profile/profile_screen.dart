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
import 'package:curbonapp/constant.dart';

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
        backgroundColor: Colors.grey[100],
        bottomNavigationBar: BottomBar(selectedIndex: 3),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                        ),
                      ),
                      Visibility(
                        visible: !noUser,
                        child: Container(
                          width: 80,
                          child: GestureDetector(
                            onTap: () async {
                              _auth.signOut();
                              googleSignIn.signOut();
                              facebookLogin.logOut();
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
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: themeColor,
                            backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                          if (hasProfilePic)
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userPhoto)),
                          Visibility(
                            visible: !noUser,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(top: 80, left: 80),
                                child: GestureDetector(
                                  onTap: () {
                                    chooseFile();
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8),
                            ),
                            Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Level $level',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '$point Points',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[400]))),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/intro_pages');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.sentiment_satisfied,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Introduction',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[400]))),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/how');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help_outline,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'How this works',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/about');
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.info_outline,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'About us',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (noUser)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text('You have not logged in yet 😓'),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: themeColor,
                                fontSize: 16,
                                letterSpacing: 0.5),
                          )),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
