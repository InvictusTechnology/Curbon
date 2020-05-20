import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curbonapp/screen/home/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:intl/intl.dart';

class LoadingHomeScreen extends StatefulWidget {
  @override
  _LoadingHomeScreenState createState() => _LoadingHomeScreenState();
}

class _LoadingHomeScreenState extends State<LoadingHomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;

  List<Trips> tripList = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDocument(String name) async {
    // Get the millisecondsSinceEpoch to limit the day since last 7 days only
    var time = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 6)
        .millisecondsSinceEpoch;

    var currentUser = loggedInUser.email;

    // Implement the time var to limit the retrieve to end only after D-7
    final pastTrips = await _firestore
        .collection('past_trips')
        .where('user', isEqualTo: currentUser)
        .orderBy('createdTime', descending: true)
        .endAt([time]).getDocuments();

    for (var trip in pastTrips.documents) {
      tripList.add(
        Trips(
          destination: trip.data['to'],
          starting: trip.data['from'],
          transport: trip.data['transport'],
          carbon: trip.data['carbon'],
          distance: trip.data['distance'],
          user: trip.data['user'],
          date: trip.data['createdTime'],
        ),
      );
    }
    if (tripList.isNotEmpty) {
      int epochNumber = tripList[0].date;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochNumber);
      var format = DateFormat('MMM d, yyyy');
      var formatHour = DateFormat('H:mm');
      var dateString = format.format(dateTime);
      var hourString = formatHour.format(dateTime);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            hasLoggedIn: true,
            name: name,
            date: dateString,
            hour: hourString,
            tripList: tripList,
          ),
        ),
      );
    } else {
      List<Trips> tripList = [
        Trips(
          destination: 'No record of any address yet',
          starting: 'No record of any address yet',
          transport: '',
          distance: '0',
          carbon: '0',
        )
      ];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            hasLoggedIn: true,
            name: name,
            date: 'You have no record of any trip',
            hour: '-',
            tripList: tripList,
          ),
        ),
      );
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      final name = user.displayName;
      if (user != null) {
        loggedInUser = user;
        if (loggedInUser.displayName == null) {
          Navigator.pushReplacementNamed(context, '/detail');
        } else {
          getDocument(name);
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              hasLoggedIn: false,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            hasLoggedIn: false,
          ),
        ),
      );
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(
        selectedIndex: 0,
      ),
      body: Center(
        child: SpinKitRing(
          color: Color(0xFF67ECAB),
          size: 100,
        ),
      ),
    );
  }
}
