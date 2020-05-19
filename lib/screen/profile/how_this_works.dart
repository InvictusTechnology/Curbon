import 'package:flutter/material.dart';

class HowThisWorksWScreen extends StatelessWidget {
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
                      child: Image.asset('assets/how.png')),
                  Text(
                    'How we calculate the carbon emission for each type of transport is by accumulating data from several open datasets and the following supporting articles',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
