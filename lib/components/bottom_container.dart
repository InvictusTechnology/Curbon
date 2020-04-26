import 'package:flutter/material.dart';

class ResultContainer extends StatelessWidget {
  final String message;
  final String result;
  final String vehicle;
  ResultContainer({this.message, this.result, this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        height: 300,
        color: Color(0xFFf2fff6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color(0xFF9FFFD1),
                  borderRadius: BorderRadius.circular(10)),
              height: 75,
              width: 275,
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Did you know that bus has",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "the least amount of carbon emission?",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  Text(
                    'Distance: 200 km',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    result,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Calculation is done in kg CO2',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
