import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
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
    createProfile(email, context, imageUrl);
  } catch (e) {
    throw e;
  }
}

void createProfile(String email, BuildContext context, String imgUrl) async {
  try {
    var profile = await _firestore.collection('profile').document(email).get();
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
