import 'package:flutter/material.dart';

// Constants for chart buttons color
const kInactiveChart = LinearGradient(
  colors: const [
    Color(0xFF2D4261),
    Color(0xFF1f316e),
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);
const kActiveChart = LinearGradient(
  colors: const [
    Color(0xFF5ab2e8),
    Color(0xFF9ad7fc),
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

// Constant for boxShadow
const kBoxShadow = [
  BoxShadow(
    color: Color(0xFFc9c9c9),
    blurRadius: 5.0,
    spreadRadius: 2.0,
    offset: Offset(
      0.0,
      2.0,
    ),
  )
];

// Constants for GoogleMaps in MapScreen
const googleAPIKey = "AIzaSyDlVVdxGqt8Y_H--YJlvTDtw4X6wXl-MtI";
const double cameraZoom = 13;
const double cameraTilt = 0;
const double cameraBearing = 30;

// Constants for the Green Theme Color
const themeColor = Color(0xFF1c9c60);

// Constants for colors
const inactiveColor = Colors.white;
const activeColor = Color(0xFF67ECAB);

// Constant for TextField Decoration
const kTextStyle = TextStyle(
    fontSize: 15,
    letterSpacing: 0.8,
    fontWeight: FontWeight.bold,
    color: Colors.white);
const kTextFieldStyle = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF26CB7E), width: 1),
      borderRadius: BorderRadius.all(Radius.circular(10))),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF67ECAB), width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10))),
  hintText: 'Enter a value',
);
