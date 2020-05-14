import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  bool showSpinner = false;
  String name = '';
  String email = '';
  int point = 0;
  int level = 0;

  void getUserProfile() async {
    final user = await _auth.currentUser();
    name = user.displayName;
    var profile =
        await _firestore.collection('profile').document(user.email).get();
    point = profile.data['point'];
    level = profile.data['level'];
    email = user.email;
    setState(() {
      showSpinner = false;
    });
  }

  Align infoText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 20, top: 5),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
      ),
    );
  }

  Align detailText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 20, top: 5),
        child: Text(
          text,
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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Color(0xFF26CB7E),
        bottomNavigationBar: BottomBar(selectedIndex: 3),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFF26CB7E),
                      Color(0xFF539970),
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
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              print('Logout Tapped');
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
                        Container(
                          margin: EdgeInsets.only(
                              left: 50, right: 50, top: 20, bottom: 10),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage('assets/earth.png'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10, top: 20),
                          child: GestureDetector(
                            onTap: () {
                              print('Edit Tapped');
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
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Column for the infoText
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            infoText('Display Name: '),
                            infoText('Email Address: '),
                            infoText('Current Point: '),
                            infoText('Current Level: '),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            detailText(name),
                            detailText(email),
                            detailText(point.toString()),
                            detailText(level.toString()),
                          ],
                        )
                      ],
                    ),
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
                        offset:
                            Offset(0, -5.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
