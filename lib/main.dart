import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttermapapp/Homepage.dart';
import 'package:fluttermapapp/screen/home.dart';
import './maps.dart';
import './search.dart';
import './sample.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPage = 0;
  List _pageOptions = [
    home(),
    SamplePage(),
    SearchPage(),
  ];
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 2,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.map, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.pie_chart, size: 30),
          Icon(Icons.account_circle, size: 30),
        ],
        color: Colors.tealAccent[700],
        buttonBackgroundColor: Colors.tealAccent[700],
        backgroundColor: Colors.tealAccent[400],
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.amber,
              child: Center(
                child: Column(
                  children: <Widget>[
                    _pageOptions[_selectedPage],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
