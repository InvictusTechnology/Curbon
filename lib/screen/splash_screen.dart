import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  Future<void> mainStart() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(
          context, email == null ? '/' : '/loading_home');
    });
  }

  @override
  void initState() {
    super.initState();
    mainStart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1b1b),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(120),
              child: Image.asset('assets/logo.png'),
            ),
            Container(
                margin: EdgeInsets.all(100),
                child: Image.asset('assets/invic.png')),
          ],
        ),
      ),
    );
  }
}
