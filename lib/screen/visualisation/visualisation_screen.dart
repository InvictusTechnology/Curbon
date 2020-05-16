import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class VisualisationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomBar(selectedIndex: 2),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Image.asset('assets/vizz.png')),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                    child: Text(
                      'Check out our very own generated charts based on open datasets that we found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF1c9c60),
                        Color(0xFF58d178),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87.withOpacity(0.2),
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                        offset: Offset(0, -5.0),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      linkButtons(
                          text:
                              'State and Territory CO2e Emissions per Capita (Australia)',
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          onPress: () {
                            Navigator.pushReplacementNamed(context, '/vizz1');
                          }),
                      linkButtons(
                          text: 'Transport Sector Greenhouse Gas Emissions')
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget linkButtons({String text, Border border, Function onPress}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 35),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: border,
        ),
        child: GestureDetector(
          onTap: onPress,
          child: Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
