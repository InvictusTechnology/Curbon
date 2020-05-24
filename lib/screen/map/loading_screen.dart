import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/screen/map/maps_screen.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:location/location.dart';

// This screen is used to prepare for Map Screen
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  GooglePlayServicesAvailability _availability =
      GooglePlayServicesAvailability.unknown;

  // Checking GooglePlayServices
  Future<void> checkPlayServices([bool showDialog = false]) async {
    GooglePlayServicesAvailability playStoreAvailability;
    try {
      playStoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability(showDialog);
    } catch (e) {
      playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }
    if (!mounted) {
      return;
    }
    _availability = (playStoreAvailability);
    String _availableString = _availability.toString().split('.').last;
    _availableString == 'success' ? getCurrentLocation() : print('Error');
  }

  @override
  void initState() {
    super.initState();
    Platform.isIOS
        ? getCurrentLocation()
        : checkPlayServices(); // Check which platform user is using
  }

  // Get user's current location, then pass it to Map screen
  void getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          currentLat: _locationData.latitude,
          currentLng: _locationData.longitude,
        ),
      ),
    );
  }

  void _moveToHomeScreen(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _moveToHomeScreen(context);
        return;
      },
      child: Scaffold(
        bottomNavigationBar: BottomBar(
          selectedIndex: 1,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              color: Color(0xFF67ECAB),
              size: 100.0,
            ),
            if (Platform.isAndroid)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                child: Text(
                  'Make sure you have your Google Play Service available',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            if (Platform.isIOS)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                child: Text(
                  'Fetching user\'s current location',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
