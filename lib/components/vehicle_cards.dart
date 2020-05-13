import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  VehicleCard(
      {@required this.colorBorder,
      @required this.colorInside,
      @required this.cardChild,
      @required this.onPress});

  final Color colorBorder;
  final Color colorInside;
  final Widget cardChild;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        width: 65,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),  
              blurRadius: 1.0,
              spreadRadius: 0.2,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          color: colorInside,
          border: Border.all(color: colorBorder),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            cardChild,
          ],
        ),
      ),
    );
  }
}
