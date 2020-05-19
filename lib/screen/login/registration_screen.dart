import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/constant.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curbonapp/signin/signin_google.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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
                          'Register',
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
                        margin: EdgeInsets.only(top: 5, bottom: 7.5),
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
                              checkPassword(value);
                              _password = value;
                            },
                            textAlign: TextAlign.center,
                            obscureText: _obscureText,
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
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          _showMinPasswordWarning
                              ? 'Password should be at least 6 characters'
                              : ' ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ),
                      ),
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
                            final newUser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email.trim(),
                                    password: _password.trim());

                            if (newUser != null) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('email', _email.trim());
                              createProfile();
                              Navigator.pushReplacementNamed(
                                  context, '/detail');
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
                        color: Color(0xFF26BC7E),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 75, vertical: 12),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                letterSpacing: 0.8,
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: 50, height: 1, color: Colors.grey[300]),
                          Text('  OR  ',
                              style: TextStyle(color: Colors.grey[300])),
                          Container(
                              width: 50, height: 1, color: Colors.grey[300]),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _signInButton('Google', 'assets/google_logo.png', () {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              signInWithGoogle(context).whenComplete(() {
                                setState(() {
                                  showSpinner = false;
                                });
                              });
                            } catch (e) {
                              print('LMAOOOO');
                            }
                          }, 25, EdgeInsets.only(right: 10)),
                          _signInButton('Facebook', 'assets/facebook.png', () {
                            setState(() {
                              showSpinner = true;
                            });
                            signUpWithFacebook(context).whenComplete(() {
                              setState(() {
                                showSpinner = false;
                              });
                            });
                          }, 30, EdgeInsets.only(left: 10)),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Already have an account?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 14),
                                  ),
                                  Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF26BC7E), fontSize: 14),
                                  ),
                                ],
                              )))
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

  Widget _signInButton(String text, String image, Function onPress, double size,
      EdgeInsetsGeometry edge) {
    return Expanded(
      child: Container(
        margin: edge,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: FlatButton(
            onPressed: onPress,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(image, height: size),
                SizedBox(width: 10),
                Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey[800], fontSize: 18),
                )
              ],
            )),
      ),
    );
  }

  Future<void> signUpWithFacebook(BuildContext context) async {
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        createProfileGoogle(email: user.email, context: context);
        print('signed in ' + user.displayName);
        return user;
      }
    } catch (e) {
      print(e.message);
      if (e.message ==
          'An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.') {
        errorMessage =
            'You have previously used a different sign-in credential';
      }
      throw e;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);

      name = user.displayName;
      email = user.email;
      imageUrl = user.photoUrl;

      if (name.contains(" ")) {
        name = name.substring(0, name.indexOf(" "));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email.trim());
      createProfileGoogle(email: email, context: context, imgUrl: imageUrl);
    } catch (e) {
      throw e;
    }
  }

  void createProfileGoogle(
      {String email, BuildContext context, String imgUrl}) async {
    try {
      var profile =
          await _firestore.collection('profile').document(email).get();
      if (!profile.exists) {
        await _firestore.collection('profile').document(email).setData({
          'user': email,
          'point': 0,
          'level': 1,
        });
      }

      Navigator.pushReplacementNamed(context, '/detail');
    } catch (e) {
      throw e;
    }
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
