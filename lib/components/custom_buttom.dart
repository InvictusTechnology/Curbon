import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({this.title, this.colour, this.onPressed});

  final String title;
  final Color colour;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: onPressed,
          height: 50,
          minWidth: 200,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        ),
      ),
    );
  }
}
