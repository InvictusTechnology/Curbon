import 'package:curbonapp/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'trips_constructor.dart';

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

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int d1 = 0, d2 = 0, d3 = 0, d4 = 0, d5 = 0, d6 = 0, d7 = 0;

  @override
  void initState() {
    super.initState();
    getPerDay();

    // Assigning the result of calculation to the charts
    final barGroup1 = makeGroupData(0, d7.toDouble());
    final barGroup2 = makeGroupData(1, d6.toDouble());
    final barGroup3 = makeGroupData(2, d5.toDouble());
    final barGroup4 = makeGroupData(3, d4.toDouble());
    final barGroup5 = makeGroupData(4, d3.toDouble());
    final barGroup6 = makeGroupData(5, d2.toDouble());
    final barGroup7 = makeGroupData(6, d1.toDouble());
    // Organising them into the bar items
    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  String getDay(DateTime dateTime) {
    var format = DateFormat('E');
    var dayString = format.format(dateTime);
    return dayString;
  }

  void getPerDay() {
    var dayMinOne =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var dayMinTwo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    var dayMinThree = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);
    var dayMinFour = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 3);
    var dayMinFive = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 4);
    var dayMinSix = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 5);
    var dayMinSeven = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 6);

    for (int i = 0; i <= widget.tripList.length - 1; i++) {
      int epochNumber = widget.tripList[i].date;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochNumber);
      var newDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      if (newDate == dayMinOne) {
        d1++;
      } else if (newDate == dayMinTwo) {
        d2++;
      } else if (newDate == dayMinThree) {
        d3++;
      } else if (newDate == dayMinFour) {
        d4++;
      } else if (newDate == dayMinFive) {
        d5++;
      } else if (newDate == dayMinSix) {
        d6++;
      } else if (newDate == dayMinSeven) {
        d7++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
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
                        fontSize: 22,
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
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 6));
                              case 1:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 5));
                              case 2:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 4));
                              case 3:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 3));
                              case 4:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 2));
                              case 5:
                                return getDay(DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 1));
                              case 6:
                                return getDay(DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day));
                              default:
                                return '';
                            }
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
              const SizedBox(
                height: 12,
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
