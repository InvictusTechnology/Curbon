import 'package:flutter/material.dart';
import 'package:curbonapp/components/first_page_dialog.dart';
import 'package:flutter/services.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        // ignore: missing_return, missing_return
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert!'),
                content: Text('This will close the app'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text('OK'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  )
                ],
              );
            });
      },
      child: Scaffold(
        backgroundColor: Color(0xFF1b1b1b),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  margin: EdgeInsets.only(top: 30, left: 50),
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 50, right: 30, top: 10, bottom: 10),
                child: Text(
                  'Welcome to Curbon',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 100),
                child: Text(
                  'Take the first step towards net-zero carbon emission',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 50),
                child: Image.asset('assets/welcome.png'),
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: "Create a new account",
                      description:
                          "You will be able to track your carbon footprint and check improvements.",
                      primaryButtonText: "Create My Account",
                      primaryButtonRoute: "/registration",
                      secondaryButtonText: "Not Now",
                      secondaryButtonRoute: "/loading",
                    ),
                  );
                },
                color: Color(0xFF26CB7E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                  child: Text(
                    'Let\'s Go NetZero',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Visualisation for Carbon Emission",
                        description:
                            "Take a look at a few visualisations to learn more about carbon emission in 2017",
                        primaryButtonText: "Carbon Emission in 2017",
                        primaryButtonRoute: "/viz1",
//                          secondaryButtonText:
//                              "Low and High Carbon Emitting States",
//                          secondaryButtonRoute: "/viz2",
                      ),
                    );
                  },
                  child: Text(
                    'Australian Carbon Emission History',
                    style: TextStyle(color: Color(0xFF26CB7E), fontSize: 15),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
