import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool _obscureText = true;
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
            child: Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.9),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        'Email',
                        style: kTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Password',
                          style: kTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 7.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextField(
                            onChanged: (value) {
                              _password = value;
                            },
                            obscureText: _obscureText,
                            textAlign: TextAlign.center,
                            decoration: kTextFieldStyle.copyWith(
                                contentPadding: EdgeInsets.only(
                                    top: 12, bottom: 12, left: 50),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.green[400],
                                  ),
                                  onPressed: _toggle,
                                ),
                                hintText: 'Enter a password')),
                      ),
                      Text(
                        errorMessage == null ? ' ' : errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      SizedBox(height: 40),
                      RaisedButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (_email == null || _password == null) {
                            setState(() {
                              errorMessage = 'You have not entered any value';
                              showSpinner = false;
                            });
                          }
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: _email.trim(), password: _password);
                            print(user);
                            if (user != null) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('email', _email.trim());
                              Navigator.pushReplacementNamed(
                                  context, '/loading_home');
                            }
                          } catch (error) {
                            print(error.message);
                            print('^^^^^^^^');
                            switch (error.message) {
                              case "The password is invalid or the user does not have a password.":
                                setState(() {
                                  errorMessage = "Please check your password";
                                  showSpinner = false;
                                });
                                break;
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
                              case "There is no user record corresponding to this identifier. The user may have been deleted.":
                                setState(() {
                                  errorMessage = "Invalid email or password";
                                  showSpinner = false;
                                });
                                break;
                              default:
                                setState(() {
                                  print('=======');
                                  errorMessage = "Invalid email or password";
                                  showSpinner = false;
                                });
                            }
                            throw error;
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color(0xFF26BC7E),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 75, vertical: 12),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/forgot');
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Color(0xFF26BC7E), fontSize: 14),
                          )),
                      SizedBox(height: 30),
                      FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/registration');
                          },
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Does not have an account yet?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                              ),
                              Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF26BC7E), fontSize: 14),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
