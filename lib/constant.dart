import 'package:flutter/material.dart';

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
  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
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
