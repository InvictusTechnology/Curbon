import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';

import 'package:curbonapp/calculator/distance.dart';
import 'package:curbonapp/screen/map/result_screen.dart';
import 'package:curbonapp/constant.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/components/vehicle_cards.dart';
import 'package:curbonapp/components/icon_content.dart';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class MapScreen extends StatefulWidget {
  final double currentLat;
  final double currentLng;
  const MapScreen({this.currentLat, this.currentLng});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleAPIKey);
  GoogleMapController mapController;
  Distance distClass = Distance();
  Position position;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String startingMessage = 'Enter starting address';
  String destinationMessage = 'Enter destination address';
  LatLng sourceLocation;
  LatLng destLocation;
  CameraPosition initialLocation;
  bool _visibleCalculate = false;
  bool _visibleTransport = false;
  bool _hasLoggedIn;
  String selectedVehicle;
  int userChoice;

  void _moveToHomeScreen(BuildContext context) =>
      Navigator.pushReplacementNamed(
          context, _hasLoggedIn == true ? '/loading_home' : '/');

  Future<void> getStartingMessage() async {
    final coordinates = new Coordinates(widget.currentLat, widget.currentLng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      startingMessage = first.addressLine;
    });
    sourceLocation = LatLng(widget.currentLat, widget.currentLng);
  }

  @override
  void initState() {
    super.initState();
    getStartingMessage();
    initialLocation = CameraPosition(
        zoom: cameraZoom,
        bearing: cameraBearing,
        tilt: cameraTilt,
        target: LatLng(widget.currentLat, widget.currentLng));
  }

  void checkUserLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    email != null ? _hasLoggedIn = true : _hasLoggedIn = false;

    _moveToHomeScreen(context);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> displayPrediction(
      Prediction p, int i, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));

      setState(() {
        if (i == 1) {
          startingMessage = '${p.description}';
          sourceLocation = LatLng(lat, lng);
        } else {
          destinationMessage = '${p.description}';
          destLocation = LatLng(lat, lng);
          _onAddMarker(destLocation);
        }
      });

      setPolylines();
    }
  }

  void _onAddMarker(LatLng _mapDest) async {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(_mapDest.toString()),
          position: _mapDest,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  setPolylines() async {
    final double distance = await Geolocator().distanceBetween(
      sourceLocation.latitude,
      sourceLocation.longitude,
      destLocation.latitude,
      destLocation.longitude,
    );

    distClass.setDistance(distance);
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        sourceLocation.latitude,
        sourceLocation.longitude,
        destLocation.latitude,
        destLocation.longitude);
    if (result.isNotEmpty) {
      polylineCoordinates.clear();
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      _polylines.add(polyline);

      _visibleTransport = true;
    });
  }

  _getLocationButton() async {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        checkUserLoggedIn(context);
        return;
      },
      child: Scaffold(
        bottomNavigationBar: BottomBar(
          selectedIndex: 1,
        ),
        floatingActionButton: AnimatedSize(
          curve: Curves.elasticInOut,
          vsync: this,
          duration: Duration(seconds: 1),
          child: Container(
            height: _visibleCalculate ? 50 : 0,
            child: FloatingActionButton.extended(
              heroTag: 'calculate',
              backgroundColor: themeColor,
              onPressed: () {
                double newDistance = distClass.getDistance();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      distance: newDistance,
                      destination: destinationMessage,
                      starting: startingMessage,
                      vehicle: selectedVehicle.toString(),
                      userChoice: userChoice,
                    ),
                  ),
                );
              },
              label: Text(
                'Calculate',
                style: TextStyle(
                    color:
                        _visibleCalculate ? Colors.white : Colors.transparent,
                    fontWeight: FontWeight.w600),
              ),
              icon: Icon(
                Icons.add_circle_outline,
                color: _visibleCalculate ? Colors.white : Colors.transparent,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                  myLocationEnabled: true,
                  tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                  onMapCreated: onMapCreated),
              Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFc7c7c7)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () async {
                          Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleAPIKey,
                            mode: Mode.overlay,
                          );
                          displayPrediction(p, 1, homeScaffoldKey.currentState);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(right: 12),
                                child: Text(
                                  startingMessage,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF474747)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: themeColor,
                            )
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFc7c7c7)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Colors.white,
                    ),
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () async {
                          Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleAPIKey,
                            mode: Mode.overlay,
                          );
                          displayPrediction(p, 2, homeScaffoldKey.currentState);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(right: 12),
                                child: Text(
                                  destinationMessage,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF474747)),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: themeColor,
                            )
                          ],
                        )),
                  ),
                  AnimatedSize(
                    duration: Duration(seconds: 1),
                    vsync: this,
                    curve: Curves.elasticInOut,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: _visibleTransport ? 75 : 0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Car';
                                userChoice = 0;
                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Car'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.directions_car,
                              label: 'Car',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Bus';
                                userChoice = 1;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Bus'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.directions_bus,
                              label: 'Bus',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Tram';
                                userChoice = 2;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Tram'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.tram,
                              label: 'Tram',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Train';
                                userChoice = 3;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Train'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.train,
                              label: 'Train',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Bicycle';
                                userChoice = 4;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Bicycle'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.directions_bike,
                              label: 'Bicycle',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Walking';
                                userChoice = 5;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Walking'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.directions_walk,
                              label: 'Walking',
                            ),
                          ),
                          VehicleCard(
                            onPress: () {
                              setState(() {
                                selectedVehicle = 'Motorcycle';
                                userChoice = 6;

                                _visibleCalculate = true;
                              });
                            },
                            colorBorder: activeColor,
                            colorInside: selectedVehicle == 'Motorcycle'
                                ? activeColor
                                : inactiveColor,
                            cardChild: IconContent(
                              icon: Icons.motorcycle,
                              label: 'Motorcycle',
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10),
                  child: FloatingActionButton(
                    onPressed: _getLocationButton,
                    backgroundColor: themeColor,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                    heroTag: 'btn2',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
