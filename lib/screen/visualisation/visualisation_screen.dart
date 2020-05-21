import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';

class VisualisationScreen extends StatefulWidget {
  @override
  _VisualisationScreenState createState() => _VisualisationScreenState();
}

class _VisualisationScreenState extends State<VisualisationScreen>
    with TickerProviderStateMixin {
  String chosen = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacementNamed(context, '/loading_home');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomBar(selectedIndex: 2),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  'Charts',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset('assets/vizz.png'),
              ),
              SizedBox(height: 30),
              linkButton(
                  'Australia\'s State and Territory CO2e Emissions per Capita',
                  () {
                setState(() {
                  chosen = 'vizz1';
                });
                Navigator.pushNamed(context, '/vizz1');
              }),
              linkButton('Transport Sector Greenhouse Gas Emissions', () {
                Navigator.pushNamed(context, '/vizz2');
              }),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Text(
                      'All charts were automatically generated based on open datasets.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget linkButton(String text, Function onTap) {
    return AnimatedSize(
      duration: Duration(seconds: 2),
      vsync: this,
      curve: Curves.bounceIn,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFF1c9c60),
            boxShadow: kBoxShadow),
        child: FlatButton(
          onPressed: onTap,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
