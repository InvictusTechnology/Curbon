import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Column(
                children: <Widget>[
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      child: Image.asset('assets/about_us.png')),
                  Text(
                    'We are a group of students from Monash University, Melbourne. We are aiming to help the world to reduce its carbon emissions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'We promise to give you our best abilities to provide you with the best experience and to motivate you to reach our goal together \nGo Net Zero!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
