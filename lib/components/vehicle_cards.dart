import 'package:curbonapp/constant.dart';
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
        width: 72,
        decoration: BoxDecoration(
          boxShadow: kBoxShadow,
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
