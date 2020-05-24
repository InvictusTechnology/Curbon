import 'package:flutter/material.dart';

// Icon component for other usage (other than Home page)
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
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
