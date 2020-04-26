import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission/permission.dart';
import 'package:fluttermapapp/distance.dart';
import 'package:fluttermapapp/calculator/calculator.dart';

const kGoogleApiKey = "AIzaSyDlVVdxGqt8Y_H--YJlvTDtw4X6wXl-MtI";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
GoogleMapPolyline _googleMapPolyline =
    new GoogleMapPolyline(apiKey: kGoogleApiKey);

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class SamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MySample();
  }
}

class MySample extends StatefulWidget {
  @override
  _MySampleState createState() => _MySampleState();
}

class _MySampleState extends State<MySample> {
  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  LatLng _destinationLocation = LatLng(-37.8847841, 144.9770287);

  static const LatLng _center = const LatLng(-37.8876668, 145.045961);
  bool _loading = false;

  final Set<Marker> _markers = {};

  GoogleMapController mapController;

  List<LatLng> latlng = [
    LatLng(-37.8876668, 145.045961),
    LatLng(-37.8847841, 144.9770287),
  ];

  _getPolylinesWithLocation(_lastMapPosition) async {
    _setLoadingMenu(true);
    List<LatLng> _coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: _center,
            destination: _lastMapPosition,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 777,
              child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: onMapCreated,
                polylines: Set<Polyline>.of(_polylines.values),
                zoomControlsEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.0,
                  tilt: CAMERA_TILT,
                  bearing: CAMERA_BEARING,
                ),
                markers: _markers,
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
            Container(
              child: Positioned(
                bottom: 18,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.my_location),
                ),
              ),
            ),
            Container(
              child: Positioned(
                bottom: 80,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    _onAddMarkerpressed(_center);
                  },
                  backgroundColor: Colors.red,
                  child: Icon(Icons.add_location),
                ),
              ),
            ),
//            Container(
//              child: Positioned(
//                bottom: 160,
//                right: 10,
//                child: FloatingActionButton(
//                  onPressed: () {
//                    _getPolylinesWithLocation(_center);
//                  },
//                  backgroundColor: Colors.blue,
//                  child: Icon(Icons.add_location),
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  void _onAddMarkerpressed(LatLng _lastMapPosition) async {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
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

      LatLng _lastMapPosition = LatLng(lat, lng);
      _onAddMarkerpressed(_lastMapPosition);

      _getPolylinesWithLocation(_lastMapPosition);

      print(distance);

//      scaffold.showSnackBar(
//        SnackBar(content: Text("${p.description} - $lat/$lng")),
//      );

    }
  }
}
