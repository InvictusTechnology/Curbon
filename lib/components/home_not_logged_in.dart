import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';

class HomeNotLoggedIn extends StatefulWidget {
  @override
  _HomeNotLoggedInState createState() => _HomeNotLoggedInState();
}

class _HomeNotLoggedInState extends State<HomeNotLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1b1b),
      bottomNavigationBar: BottomBar(
        selectedIndex: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'It seems that you have not logged in yet',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 10),
              child: RaisedButton(
                color: Colors.blue[600],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 10),
              child: RaisedButton(
                color: Color(0xFF26CB7E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/registration');
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    EdgeInsets.only(left: 50, right: 50, bottom: 50, top: 50),
                child: Align(
                    alignment: Alignment.center,
                    child: Image.asset('assets/not_logged_in.png')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
