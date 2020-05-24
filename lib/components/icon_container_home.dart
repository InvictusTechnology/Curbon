import 'package:flutter/material.dart';

// Simple class for icon of vehicle in the HomeScreen, designed only to fit Home page
// ignore: must_be_immutable
class IconContainer extends StatelessWidget {
  String transport;
  IconContainer(this.transport);

  Icon setIcon() {
    IconData transportIcon;
    switch (transport) {
      case 'Car':
        {
          transportIcon = Icons.directions_car;
        }
        break;
      case 'Bus':
        {
          transportIcon = Icons.directions_bus;
        }
        break;
      case 'Tram':
        {
          transportIcon = Icons.tram;
        }
        break;
      case 'Train':
        {
          transportIcon = Icons.train;
        }
        break;
      case 'Bicycle':
        {
          transportIcon = Icons.directions_bike;
        }
        break;
      case 'Walking':
        {
          transportIcon = Icons.directions_walk;
        }
        break;
      case 'Motorcycle':
        {
          transportIcon = Icons.motorcycle;
        }
        break;
      default:
        {
          transportIcon = Icons.error_outline;
        }
    }

    return Icon(
      transportIcon,
      size: 30,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            setIcon(),
            Text(
              transport,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[200]),
            )
          ],
        ),
      ),
    );
  }
}
