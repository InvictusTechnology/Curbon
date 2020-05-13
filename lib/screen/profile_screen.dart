import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(selectedIndex: 3),
      body: SafeArea(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
