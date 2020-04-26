import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  VehicleCard(
      {@required this.colour,
        @required this.cardChild,
        @required this.onPress});

  final Color colour;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Material(
          elevation: 10,
          color: colour,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                cardChild,
              ],
            ),
            width: 150,
          ),
        ),
      ),
    );
  }
}
