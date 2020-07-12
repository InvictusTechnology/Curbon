import 'package:curbonapp/trips/carbon_emission_30days.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/trips/total_trips.dart';
import 'package:curbonapp/trips/choice_of_transport.dart';
import 'package:curbonapp/trips/trips_constructor.dart';

// This component is called in Home page if user has data to be shown in the chart
// ignore: must_be_immutable
class ShowChart extends StatefulWidget {
  List<Trips> tripList;
  List<Trips> tripList30Days;
  String selectedChart;
  ShowChart({this.tripList, this.selectedChart, this.tripList30Days});
  @override
  _ShowChartState createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 0),
      child: (() {
        if (widget.selectedChart == 'Chart 1') {
          return TotalTrips(tripList: widget.tripList30Days);
        } else if (widget.selectedChart == 'Chart 2') {
          return TransportChoiceChart(tripList: widget.tripList30Days);
        } else {
          return CarbonEmission30DaysChart(tripList: widget.tripList30Days);
        }
      }()),
    );
  }
}
