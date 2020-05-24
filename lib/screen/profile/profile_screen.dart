import 'dart:io';
import 'package:curbonapp/signin/signin_model.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  File _image;
  bool showSpinner;
  bool noUser;
  bool hasProfilePic;
  bool hasUpdatedPhoto;
  bool hasVerified;
  String userPhoto;
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

  void chooseFile() async {
    setState(() {
      showSpinner = true;
    });
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();

      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
          hasUpdatedPhoto = true;
        });
        startUpload(loggedInUser.email);
        updateInfo.photoUrl = _image.path;
      });
      await loggedInUser.updateProfile(updateInfo);
      await loggedInUser.reload();
      loggedInUser = await _auth.currentUser();

      setState(() async {
        hasUpdatedPhoto = true;
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
        try {
          var profile =
              await _firestore.collection('profile').document(user.email).get();
          point = profile.data['point'];
          level = profile.data['level'];
        } catch (e) {
          await _firestore
              .collection('profile')
              .document(loggedInUser.email)
              .setData({
            'user': loggedInUser.email,
            'point': 0,
            'level': 1,
          });
        }

        hasVerified = loggedInUser.isEmailVerified;
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
      setState(() {
        showSpinner = false;
      });
      throw e;
    }
  }

  @override
  void initState() {
    showSpinner = true;
    super.initState();
    userPhoto = 'assets/avatar.png';
    hasProfilePic = false;
    noUser = false;
    hasUpdatedPhoto = false;
    hasVerified = true;
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(
            context, loggedInUser != null ? '/loading_home' : '/');
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
                  margin: EdgeInsets.only(left: 30, top: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Profile',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8),
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
                                backgroundColor: Colors.grey[200],
                                backgroundImage: NetworkImage(userPhoto)),
                          if (hasUpdatedPhoto)
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_image),
                            ),
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 15),
                                ),
                                (() {
                                  try {
                                    if (loggedInUser.isEmailVerified) {
                                      return Icon(
                                        Icons.verified_user,
                                        size: 13,
                                        color: themeColor,
                                      );
                                    } else {
                                      return Text('');
                                    }
                                  } catch (e) {
                                    return Text('');
                                  }
                                }())
                              ],
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/intro_pages');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
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
                      GestureDetector(
                        onTap: () {
                          launch(
                              'http://34.86.96.123/2020/05/24/how-it-works/');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help_outline,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'How it works',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          launch('http://34.86.96.123/');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
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
                      GestureDetector(
                        onTap: () {
                          launch(
                              'http://34.86.96.123/2020/05/24/ethical-and-social-responsibilities/');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.star_border,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Ethical and social responsibilities',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/tips_list');
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.filter_list,
                                color: themeColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'List of tips',
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
                if (!hasVerified)
                  Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text('You have not verified your email'),
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            await loggedInUser.sendEmailVerification();
                            showToast();
                          } catch (e) {
                            print(e);
                            showErrorToast();
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        child: Text(
                          'Verify Email',
                          style: TextStyle(
                              color: themeColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                if (noUser)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        'You have not logged in yet 😓',
                        style: TextStyle(fontSize: 15),
                      ),
                      FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: themeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 0.2),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showErrorToast() {
    Fluttertoast.showToast(
      msg: 'You have sent too many requests, try again later',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Color(0x991b1b1b),
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "An email verification has been sent to ${loggedInUser.email}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0x991b1b1b),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
