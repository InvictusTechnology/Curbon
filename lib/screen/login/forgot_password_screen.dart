import 'package:flutter/material.dart';
import 'package:curbonapp/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool resetIsSent = false;
  bool errorMessage = false;
  bool showSpinner = false;
  String _email;

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
                if (resetIsSent)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'An instruction on how to reset the password has been sent to $_email',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 35),
                RaisedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (_email == null) {
                      setState(() {
                        errorMessage = true;
                        showSpinner = false;
                      });
                    } else {
                      try {
                        await _auth.sendPasswordResetEmail(email: _email);
                        setState(() {
                          resetIsSent = true;
                          errorMessage = false;
                          showSpinner = false;
                        });
                      } catch (e) {
                        throw e;
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xFF26CB7E),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 15),
                  child: errorMessage
                      ? Text(
                          'You have not entered any email address',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      : Text(''),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Login Page',
                      style: TextStyle(color: Color(0xFF26BC7E), fontSize: 18),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
