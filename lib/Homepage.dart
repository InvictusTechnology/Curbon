import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 775,
              child: ListView(
                padding: EdgeInsets.only(left: 15.0),
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Welcome, Nadia',
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF473D3A))),
                      Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Container(
                            height: 40.0,
                            width: 40.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 45.0),
                    child: Container(
                      child: Text(
                        'Let\'s select the best mode of transport for your next Trip!',
                        style: TextStyle(
                            fontFamily: 'nunito',
                            fontSize: 17.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFB0AAA7)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                      margin: EdgeInsets.fromLTRB(0, 16, 16, 16),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 50, 50),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'This Month',
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Carbon Emissions',
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '300 Kg Co2',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select mode of transport',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 150,
                          color: Colors.blueGrey,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[Image.asset('assets/Car.png')],
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 150,
                          color: Colors.blueGrey,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/Bike.png'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 150,
                          color: Colors.blueGrey,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/Tram.png'),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Container(
                          width: 150,
                          color: Colors.blueGrey,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Image.asset('assets/Train.png'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text('Calculate your emission here',
                        style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
