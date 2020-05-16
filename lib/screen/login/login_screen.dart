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
    return ModalProgressHUD(
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
                    margin: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                Text(
                  'Email: ',
                  style: kTextStyle,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
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
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                      onChanged: (value) {
                        _password = value;
                      },
                      obscureText: _obscureText,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldStyle.copyWith(
                          contentPadding:
                              EdgeInsets.only(top: 12, bottom: 12, left: 50),
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
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
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
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/forgot');
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Color(0xFF26BC7E), fontSize: 14),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/registration');
                    },
                    child: Text(
                      'Does not have an account yet?',
                      style: TextStyle(color: Color(0xFF26BC7E), fontSize: 14),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
