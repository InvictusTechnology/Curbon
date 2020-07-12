import 'package:flutter/material.dart';

import 'package:curbonapp/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:curbonapp/trips/trips_constructor.dart';

// Constructor to get the day and carbon calculation
class MonthDays {
  int day;
  double carbon;
  MonthDays({this.day, this.carbon});
}

// This class is used to create the CarbonEmission chart in HomePage
// ignore: must_be_immutable
class CarbonEmission30DaysChart extends StatefulWidget {
  List<Trips> tripList;
  CarbonEmission30DaysChart({this.tripList});
  @override
  _CarbonEmission30DaysChartState createState() =>
      _CarbonEmission30DaysChartState();
}

class _CarbonEmission30DaysChartState extends State<CarbonEmission30DaysChart> {
  List<FlSpot> flSpots = [];
  double biggest; // to get the biggest carbon

  // Calculate carbon emission for the last 30 days
  void getPerDay() {
    for (int i = 0; i < 30; i++) {
      double _carbon = 0;
      var todayDate = DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day - i)
          .day; // get the number of today's date
      for (var trip in widget.tripList) {
        var tripDate = DateTime.fromMillisecondsSinceEpoch(trip.date).day;
        if (tripDate == todayDate) {
          _carbon = _carbon + double.parse(trip.carbon);
        }
      }
      if (_carbon > biggest) {
        biggest = _carbon;
      }
      flSpots.add(FlSpot(
          (30 - i).toDouble(), double.parse(_carbon.toStringAsFixed(2))));
    }
  }

  @override
  void initState() {
    super.initState();
    biggest = 0.0; // set biggest to 0
    getPerDay();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: kBoxShadow,
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2D4261),
              Color(0xFF405b82),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 12),
                Text(
                  'Your Carbon Emission',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Within the Last 30 Days',
                  style: TextStyle(
                    color: Color(0xFF768eb0),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      carbonEmission7Days(),
                      swapAnimationDuration: const Duration(milliseconds: 400),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData carbonEmission7Days() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == 0 || flSpot.x == 6) {
                return null;
              }

              return LineTooltipItem(
                '${flSpot.y}  KG.CO2',
                const TextStyle(color: Colors.white, fontSize: 14),
              );
            }).toList();
          },
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 30:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 0)
                        .day)
                    .toString();
              case 26:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 4)
                        .day)
                    .toString();
              case 21:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 9)
                        .day)
                    .toString();
              case 16:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 14)
                        .day)
                    .toString();
              case 11:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 19)
                        .day)
                    .toString();
              case 6:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 24)
                        .day)
                    .toString();
              case 1:
                return (DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day - 29)
                        .day)
                    .toString();
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          // ignore: missing_return
          getTitles: (value) {
            if (biggest <= 10) {
              switch (value.toInt()) {
                case 2:
                  return '2';
                case 4:
                  return '4';
                case 6:
                  return '6';
                case 8:
                  return '8';
                case 10:
                  return '10';
              }
              return '';
            } else if (biggest <= 100) {
              switch (value.toInt()) {
                case 20:
                  return '20';
                case 40:
                  return '40';
                case 60:
                  return '60';
                case 80:
                  return '80';
                case 100:
                  return '100';
              }
              return '';
            } else {
              switch (value.toInt()) {
                case 100:
                  return '100';
                case 200:
                  return '200';
                case 300:
                  return '300';
                case 400:
                  return '400';
                case 500:
                  return '500';
              }
              return '';
            }
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[400],
              width: 0.5,
            ),
            left: BorderSide(color: Colors.grey[400], width: 0.5),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 30,
      maxY: null,
      minY: 0,
      lineBarsData: carbonEmission7DaysData(),
    );
  }

  List<LineChartBarData> carbonEmission7DaysData() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: flSpots,
      isCurved: false,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }
}
