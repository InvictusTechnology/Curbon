import 'package:flutter/material.dart';

class IconContent extends StatelessWidget {
  IconContent({this.icon, this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 30.0,
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
