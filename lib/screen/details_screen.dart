import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:curbonapp/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserDetailScreen extends StatefulWidget {
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String _name;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
      await loggedInUser.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Color(0xFF1b1b1b),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 50, top: 100),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'What do you want us to call you?',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                      onChanged: (value) {
                        _name = value;
                      },
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      textAlign: TextAlign.center,
                      decoration: kTextFieldStyle.copyWith(
                          hintText: 'Enter a preferred name')),
                ),
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    UserUpdateInfo updateInfo = UserUpdateInfo();
                    updateInfo.displayName = _name;
                    await loggedInUser.updateProfile(updateInfo);
                    await loggedInUser.reload();
                    loggedInUser = await _auth.currentUser();
                    if (loggedInUser.displayName == _name) {
                      Navigator.pushReplacementNamed(context, '/loading_home');
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xFF26CB7E),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 8),
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 120, right: 120, top: 50, bottom: 35),
                  child: Image.asset('assets/detail_screen.png'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                  child: Text(
                    'Thank you for being an integral part of the global mission towards Net Zero Carbon Emission. Our common objective is to help society reduce carbon emission',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.5,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
