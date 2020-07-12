import 'package:curbonapp/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'trips_constructor.dart';

// Calculate the total trips each day within 7 days
// ignore: must_be_immutable
class TotalTrips extends StatefulWidget {
  List<Trips> tripList;
  TotalTrips({this.tripList});
  @override
  State<StatefulWidget> createState() => TotalTripsState();
}

class TotalTripsState extends State<TotalTrips> {
  final Color leftBarColor = const Color(0xFF67ECAB);
  final double width = 18;

  List<BarChartGroupData> showingBarGroups = [];

  @override
  void initState() {
    super.initState();
    getPerDay();
  }

  String getDay(DateTime dateTime) {
    var format = DateFormat('E');
    var dayString = format.format(dateTime);
    return dayString;
  }

  void getPerDay() {
    for (int i = 0; i < 30; i++) {
      int _numberTrip = 0;
      var todayDate = DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day - 29 + i)
          .day; // get the number of today's date
      print(todayDate);
      for (var trip in widget.tripList) {
        var tripDate = DateTime.fromMillisecondsSinceEpoch(trip.date).day;
        if (tripDate == todayDate) {
          _numberTrip++;
        }
      }
      showingBarGroups.add(makeGroupData(1 + i, _numberTrip.toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: kBoxShadow,
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2D4261),
              Color(0xFF405b82),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Number of Trips',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Within the Last 7 Days',
                    style: TextStyle(
                        color: Color(0xff77839a),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: null,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String message = 'Trips';
                          return BarTooltipItem(
                            (rod.y).toStringAsFixed(0) + ' ' + message,
                            TextStyle(color: Colors.yellow, fontSize: 14),
                          );
                        },
                      )),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 29:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 0)
                                        .day)
                                    .toString();
                              case 25:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 4)
                                        .day)
                                    .toString();
                              case 20:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 9)
                                        .day)
                                    .toString();
                              case 15:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 14)
                                        .day)
                                    .toString();
                              case 10:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 19)
                                        .day)
                                    .toString();
                              case 5:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 24)
                                        .day)
                                    .toString();
                              case 1:
                                return (DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day - 29)
                                        .day)
                                    .toString();
                            }
                            return '';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: TextStyle(
                              color: const Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 25,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '';
                            } else if (value == 2) {
                              return '2';
                            } else if (value == 4) {
                              return '4';
                            } else if (value == 6) {
                              return '6';
                            } else if (value == 8) {
                              return '8';
                            } else if (value == 10) {
                              return '10';
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[400],
                              width: 0.5,
                            ),
                            left:
                                BorderSide(color: Colors.grey[400], width: 0.5),
                            right: BorderSide(
                              color: Colors.transparent,
                            ),
                            top: BorderSide(
                              color: Colors.transparent,
                            ),
                          )),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        color: leftBarColor,
        width: width,
      ),
    ]);
  }
}
