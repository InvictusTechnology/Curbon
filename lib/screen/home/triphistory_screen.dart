import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/components/previous_trip_card.dart';
import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class TripHistoryScreen extends StatefulWidget {
  List<Trips> tripList;
  TripHistoryScreen({this.tripList});

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  Widget infoText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(
            color: Colors.grey[100],
            fontSize: 17.5,
            fontWeight: FontWeight.w600,
            height: 1.6),
      ),
    );
  }

  Widget resultText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 17.5,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.6),
      ),
    );
  }

  String getTime(int epochNumber) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochNumber);
    var formatHour = DateFormat('H:mm');
    var hourString = formatHour.format(dateTime);
    return hourString;
  }

  String getDate(int epochNumber) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochNumber);
    var format = DateFormat('MMM d, yyyy');
    var dateString = format.format(dateTime);
    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(selectedIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          child: ListView(
            children: <Widget>[
              for (int i = 0; i <= widget.tripList.length - 1; i++)
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 12.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              getDate(widget.tripList[i].date),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            getTime(widget.tripList[i].date),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    PreviousTripCard(
                      destination: widget.tripList[i].destination,
                      starting: widget.tripList[i].starting,
                      distance: widget.tripList[i].distance,
                      carbon: widget.tripList[i].carbon,
                      transport: widget.tripList[i].transport,
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
