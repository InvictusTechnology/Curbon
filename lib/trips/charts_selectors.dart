import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MostTransport extends StatelessWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  MostTransport(this.tripList, this.onTapped, this.size);

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

  int getHighest() {
    for (var trip in tripList) {
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
  Widget build(BuildContext context) {
    getHighest();
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: size,
            width: size,
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
        GestureDetector(
          onTap: onTapped,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1f316e)),
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
    );
  }
}

// ignore: must_be_immutable
class TripsTotal extends StatelessWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  TripsTotal(this.tripList, this.onTapped, this.size);
  int totalTrips;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: size,
            width: size,
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
        GestureDetector(
          onTap: onTapped,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1f316e)),
            width: 60,
            height: 60,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${tripList.length}',
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
    );
  }
}

// ignore: must_be_immutable
class CarbonTotal extends StatelessWidget {
  List<Trips> tripList;
  Function onTapped;
  double size;
  CarbonTotal(this.tripList, this.onTapped, this.size);

  double getCalculate() {
    double carbonTotal = 0;
    for (int i = 0; i <= tripList.length - 1; i++) {
      carbonTotal = carbonTotal + double.parse(tripList[i].carbon);
    }
    return carbonTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: size,
            width: size,
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
        GestureDetector(
          onTap: onTapped,
          child: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1f316e)),
            width: 60,
            height: 60,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${getCalculate()}',
                    maxLines: 1,
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
    );
  }
}
