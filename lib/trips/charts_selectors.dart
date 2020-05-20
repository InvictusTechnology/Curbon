import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:flutter/material.dart';

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
