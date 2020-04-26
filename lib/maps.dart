import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';

const kGoogleApiKey = "AIzaSyDlVVdxGqt8Y_H--YJlvTDtw4X6wXl-MtI";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

//main() {
//  runApp(MapPage());
//}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My App",
        routes: {
          "/": (_) => MyMap(),
        },
      );
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _MyMapState extends State<MyMap> {
  GoogleMapController mapController;
  String searchAddr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(-37.8876668, 145.045961),
                  zoom: 13.0,
                  tilt: CAMERA_TILT,
                  bearing: CAMERA_BEARING,
                ),
                myLocationButtonEnabled: false,
              ),
            ),
            Container(
              height: 50.0,
              alignment: Alignment(50.0, 0.0),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                onTap: _handlePressButton,
                decoration: InputDecoration(
                    hintText: 'Enter Address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
//                        onPressed: searchandNavigate,
                        iconSize: 30.0)),
//                onChanged: (String str) {
//                  setState(() {
//                    searchAddr = str;
//                    searchandNavigate();
//                  });
//                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getCurrentLocation();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(position.latitude, position.longitude),
          zoom: 17.0,
        ),
      ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "au",
      components: [Component(Component.country, "au")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final double distance = await Geolocator()
          .distanceBetween(position.latitude, position.longitude, lat, lng);

      scaffold.showSnackBar(SnackBar(
        content: Text('The distance is: ${distance / 1000}'),
      ));
//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );
    }
  }
}
