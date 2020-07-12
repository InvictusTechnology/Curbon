import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
// INTRO: this file is used to store classes for the circular widget in HomePage

// Show the most transport being used within the last 7 days
// ignore: must_be_immutable
class MostTransport extends StatefulWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  MostTransport(this.tripList, this.onTapped, this.size);
  @override
  _MostTransportState createState() => _MostTransportState();
}

class _MostTransportState extends State<MostTransport>
    with TickerProviderStateMixin {
  int car = 0,
      bus = 0,
      tram = 0,
      train = 0,
      walking = 0,
      bicycle = 0,
      motorcycle = 0;
  List<int> totalTransport = [];
  int biggest = 0;
  String type;
  IconData icon;

  // Increment the transport chosen if that transport is in the list
  int getHighest() {
    for (var trip in widget.tripList) {
      String transport = trip.transport;
      if (transport == 'Car') {
        car++;
      } else if (transport == 'Bus') {
        bus++;
      } else if (transport == 'Tram') {
        tram++;
      } else if (transport == 'Train') {
        train++;
      } else if (transport == 'Bicycle') {
        bicycle++;
      } else if (transport == 'Walking') {
        walking++;
      } else if (transport == 'Motorcycle') {
        motorcycle++;
      }
    }
    totalTransport = [car, bus, tram, train, bicycle, walking, motorcycle];

    for (int i = 0; i <= totalTransport.length - 1; i++) {
      if (totalTransport[i] >= biggest) {
        biggest = totalTransport[i];
        switch (i) {
          case 0:
            {
              type = 'Car';
              icon = Icons.directions_car;
            }
            break;
          case 1:
            {
              type = 'Bus';
              icon = Icons.directions_bus;
            }
            break;
          case 2:
            {
              type = 'Tram';

              icon = Icons.tram;
            }
            break;
          case 3:
            {
              type = 'Train';
              icon = Icons.train;
            }
            break;
          case 4:
            {
              type = 'Bicycle';
              icon = Icons.directions_bike;
            }
            break;
          case 5:
            {
              type = 'Walking';
              icon = Icons.directions_walk;
            }
            break;
          case 6:
            {
              type = 'Motorcycle';
              icon = Icons.motorcycle;
            }
            break;
        }
      }
    }
    print('--- $biggest');
    return biggest;
  }

  @override
  void initState() {
    super.initState();
    getHighest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedSize(
            curve: Curves.easeOut,
            vsync: this,
            duration: Duration(milliseconds: 500),
            child: Container(
                height: widget.size,
                width: widget.size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF5ab2e8),
                        Color(0xFF9ad7fc),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ))),
          ),
          CircularText(
              children: [
                TextItem(
                  text: Text(
                    "MOST USED TRANSPORT".toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  space: 8,
                  startAngle: -90,
                  startAngleAlignment: StartAngleAlignment.center,
                  direction: CircularTextDirection.clockwise,
                ),
              ],
              radius: 160,
              position: CircularTextPosition.inside,
              backgroundPaint: Paint()..color = Colors.transparent),
          GestureDetector(
            onTap: widget.onTapped,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF1f316e)),
              width: 60,
              height: 60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    Text(
                      '${biggest}x',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Show the total trips taken in the last 7 days
// ignore: must_be_immutable
class TripsTotal extends StatefulWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  TripsTotal(this.tripList, this.onTapped, this.size);

  @override
  _TripsTotalState createState() => _TripsTotalState();
}

class _TripsTotalState extends State<TripsTotal> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 75,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedSize(
            curve: Curves.easeOut,
            vsync: this,
            duration: Duration(milliseconds: 500),
            child: Container(
                height: widget.size,
                width: widget.size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF5ab2e8),
                        Color(0xFF9ad7fc),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ))),
          ),
          CircularText(
              children: [
                TextItem(
                  text: Text(
                    "TOTAL TRIPS LAST 30 DAYS".toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  space: 8,
                  startAngle: -90,
                  startAngleAlignment: StartAngleAlignment.center,
                  direction: CircularTextDirection.clockwise,
                ),
              ],
              radius: 160,
              position: CircularTextPosition.inside,
              backgroundPaint: Paint()..color = Colors.transparent),
          GestureDetector(
            onTap: widget.onTapped,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF1f316e)),
              width: 60,
              height: 60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${widget.tripList.length}',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Trips',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Calculate the total carbon within the last 7 days
// ignore: must_be_immutable
class CarbonTotal extends StatefulWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  CarbonTotal(this.tripList, this.onTapped, this.size);
  @override
  _CarbonTotalState createState() => _CarbonTotalState();
}

class _CarbonTotalState extends State<CarbonTotal>
    with TickerProviderStateMixin {
  double getCalculate() {
    double carbonTotal = 0;
    for (int i = 0; i <= widget.tripList.length - 1; i++) {
      carbonTotal = carbonTotal + double.parse(widget.tripList[i].carbon);
    }
    return carbonTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 75,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedSize(
            curve: Curves.easeOut,
            vsync: this,
            duration: Duration(milliseconds: 500),
            child: Container(
              height: widget.size,
              width: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: const [
                    Color(0xFF5ab2e8),
                    Color(0xFF9ad7fc),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          CircularText(
              children: [
                TextItem(
                  text: Text(
                    "CARBON EMITTED 30 DAYS".toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  space: 8,
                  startAngle: -90,
                  startAngleAlignment: StartAngleAlignment.center,
                  direction: CircularTextDirection.clockwise,
                ),
              ],
              radius: 160,
              position: CircularTextPosition.inside,
              backgroundPaint: Paint()..color = Colors.transparent),
          GestureDetector(
            onTap: widget.onTapped,
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF1f316e)),
              width: 60,
              height: 60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${(getCalculate()).toStringAsFixed(2)}',
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'KG.CO2',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
