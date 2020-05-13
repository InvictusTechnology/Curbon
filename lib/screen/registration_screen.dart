import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/constant.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool _obscureText = true;
  bool _showMinPasswordWarning = false;
  bool showSpinner = false;
  String _email;
  String _password;
  String errorMessage = ' ';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacementNamed(context, '/');
      },
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Color(0xFF1b1b1b),
          body: SafeArea(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      alignment: Alignment.topCenter,
                      margin:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  Text(
                    'Email: ',
                    style: kTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 7.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: TextField(
                        onChanged: (value) {
                          _email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldStyle.copyWith(
                            hintText: 'Enter an email address')),
                  ),
                  Text(
                    errorMessage == null ? ' ' : errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      'Password: ',
                      style: kTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 7.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: TextField(
                        onChanged: (value) {
                          checkPassword(value);
                          _password = value;
                        },
                        textAlign: TextAlign.center,
                        obscureText: _obscureText,
                        decoration: kTextFieldStyle.copyWith(
                            contentPadding:
                                EdgeInsets.only(top: 12, bottom: 12, left: 50),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: _toggle,
                            ),
                            hintText: 'Enter a password')),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Text(
                      _showMinPasswordWarning
                          ? 'Password should be at least 6 characters'
                          : ' ',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: _email.trim(),
                                password: _password.trim());

                        if (newUser != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('email', _email.trim());
                          createProfile();
                          Navigator.pushReplacementNamed(context, '/detail');
                        }
                      } catch (error) {
                        switch (error.message) {
                          case "The email address is already in use by another account.":
                            setState(() {
                              errorMessage = "Your email is already in use";
                              showSpinner = false;
                            });
                            break;
                          case "Given String is empty or null":
                            setState(() {
                              errorMessage =
                                  "Please make sure you have filled the required details";
                              showSpinner = false;
                            });
                            break;
                          default:
                            setState(() {
                              errorMessage = "Invalid email or password";
                              showSpinner = false;
                            });
                        }

                        throw error;
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Color(0xFF26CB7E),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account?',
                        style:
                            TextStyle(color: Color(0xFF26BC7E), fontSize: 14),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createProfile() async {
    await _firestore.collection('profile').document(_email).setData({
      'user': _email,
      'point': 0,
      'level': 1,
    });
  }

  void checkPassword(String password) {
    if (password.length < 6) {
      setState(() {
        _showMinPasswordWarning = true;
      });
    } else {
      setState(() {
        _showMinPasswordWarning = false;
      });
    }
  }
}
