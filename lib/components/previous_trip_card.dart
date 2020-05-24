import 'package:curbonapp/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/components/icon_container_home.dart';

// This is a component to be called in the Home page showing the previous trip
// ignore: must_be_immutable
class PreviousTripCard extends StatelessWidget {
  String destination;
  String starting;
  String distance;
  String transport;
  String carbon;
  PreviousTripCard(
      {this.destination,
      this.transport,
      this.carbon,
      this.starting,
      this.distance});

  EdgeInsetsGeometry _marginContainer =
      EdgeInsets.only(left: 14, right: 14, top: 2.5);

  Widget resultText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 15.5,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color(0xFF1c9c60),
            Color(0xFF1d965e),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: kBoxShadow,
      ),
      margin: _marginContainer,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To:',
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            height: 1.6),
                      ),
                      Text(
                        'From:',
                        style: TextStyle(
                            color: Colors.grey[200],
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                            height: 1.6),
                      )
                    ],
                  )),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      resultText(destination),
                      resultText(starting),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconContainer(transport),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        distance,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.5),
                      ),
                      Text(
                        'KM',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        carbon,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.5),
                      ),
                      Text(
                        'KG.CO2',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[200],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
