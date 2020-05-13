import 'package:flutter/material.dart';

class ShowNoChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[600],
          ),
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2D4261),
              Color(0xFF405b82),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700],
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No charts can be displayed',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Start recording your trips by going to the Map!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFa6cbff),
              ),
              child: IconButton(
                  icon: Icon(
                    Icons.map,
                    color: Colors.black87,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/loading');
                  }),
            )
          ],
        ),
      ),
    );
  }
}
