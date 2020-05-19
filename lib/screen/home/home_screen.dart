import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/components/yes_chart_container.dart';
import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:curbonapp/components/previous_trip_card.dart';
import 'package:flutter/services.dart';
import 'package:curbonapp/components/no_chart_container.dart';
import 'package:curbonapp/components/home_not_logged_in.dart';
import 'package:curbonapp/screen/home/triphistory_screen.dart';

const kInactiveChart = Color(0xFF4f5a70);
const kActiveChart = Color(0xFF4373d1);

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  // For the user initial details
  bool hasLoggedIn;
  // For the user's initial last trip
  String name;
  String date;
  String hour;

  List<Trips> tripList;

  HomeScreen(
      {this.hasLoggedIn, this.name, this.date, this.hour, this.tripList});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String _selectedChart = 'Chart 1';

  Widget infoText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(
            color: Colors.grey[100],
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
            height: 1.6),
      ),
    );
  }

  Widget resultText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 15.5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.6),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasLoggedIn == false) {
      return HomeNotLoggedIn();
    } else {
      return WillPopScope(
        onWillPop: () {
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
          return;
        },
        child: Scaffold(
          bottomNavigationBar: BottomBar(
            selectedIndex: 0,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 30, right: 10, top: 15),
                  child: Text(
                    'Hello ${widget.name}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: Text(
                    'Let\'s see your previous trip:',
                    style: TextStyle(fontSize: 17.5, color: Colors.grey[700]),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30, top: 7.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.date,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        widget.hour,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (widget.tripList[0].transport != '') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripHistoryScreen(
                              tripList: widget.tripList,
                            ),
                          ),
                        );
                      }
                    },
                    child: PreviousTripCard(
                      destination: widget.tripList[0].destination,
                      starting: widget.tripList[0].starting,
                      distance: widget.tripList[0].distance,
                      transport: widget.tripList[0].transport,
                      carbon: widget.tripList[0].carbon,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    changeChartButton(
                      onTapped: () {
                        setState(() {
                          _selectedChart = 'Chart 1';
                        });
                      },
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      selectChart: _selectedChart == 'Chart 1'
                          ? kActiveChart
                          : kInactiveChart,
                      title: 'Trips',
                    ),
                    changeChartButton(
                        onTapped: () {
                          setState(() {
                            _selectedChart = 'Chart 2';
                          });
                        },
                        selectChart: _selectedChart == 'Chart 2'
                            ? kActiveChart
                            : kInactiveChart,
                        title: 'Transport'),
                    changeChartButton(
                        onTapped: () {
                          setState(() {
                            _selectedChart = 'Chart 3';
                          });
                        },
                        selectChart: _selectedChart == 'Chart 3'
                            ? kActiveChart
                            : kInactiveChart,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        title: 'Carbon'),
                  ],
                ),
                widget.tripList[0].destination == 'No record of any address yet'
                    ? ShowNoChart()
                    : ShowChart(
                        tripList: widget.tripList,
                        selectedChart: _selectedChart),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget changeChartButton(
      {Function onTapped,
      Color selectChart,
      BorderRadius borderRadius,
      String title}) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        width: 100,
        margin: EdgeInsets.only(top: 20, bottom: 0),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6.5),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: selectChart,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
