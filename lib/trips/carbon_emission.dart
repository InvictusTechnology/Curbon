import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:curbonapp/trips/trips_constructor.dart';
import 'package:intl/intl.dart';

class MonthDays {
  int day;
  double carbon;
  MonthDays({this.day, this.carbon});
}

// ignore: must_be_immutable
class CarbonEmissionChart extends StatefulWidget {
  List<Trips> tripList;
  CarbonEmissionChart({this.tripList});
  @override
  _CarbonEmissionChartState createState() => _CarbonEmissionChartState();
}

class _CarbonEmissionChartState extends State<CarbonEmissionChart> {
  double c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0;

  String getDay(DateTime dateTime) {
    var format = DateFormat('E');
    var dayString = format.format(dateTime);
    return dayString;
  }

  void getPerDay() {
    var dayMinOne = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    var dayMinTwo = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);
    var dayMinThree = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 3);
    var dayMinFour = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 4);
    var dayMinFive = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 5);
    var dayMinSix = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 6);
    var dayMinSeven = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);

    for (int i = 0; i <= widget.tripList.length - 1; i++) {
      int epochNumber = widget.tripList[i].date;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochNumber);
      var newDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      if (newDate == dayMinOne) {
        c1 = c1 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinTwo) {
        c2 = c2 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinThree) {
        c3 = c3 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinFour) {
        c4 = c4 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinFive) {
        c5 = c5 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinSix) {
        c6 = c6 + double.parse(widget.tripList[i].carbon);
      } else if (newDate == dayMinSeven) {
        c7 = c7 + double.parse(widget.tripList[i].carbon);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPerDay();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800],
              spreadRadius: 3.5,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
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
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'Within the Last 7 Days',
                  style: TextStyle(
                    color: Color(0xFF768eb0),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 37,
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
            var dateNow = DateTime.now();
            switch (value.toInt()) {
              case 1:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 7));
              case 3:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 6));
              case 5:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 5));
              case 7:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 4));
              case 9:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 3));
              case 11:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 2));
              case 13:
                return getDay(
                    DateTime(dateNow.year, dateNow.month, dateNow.day - 1));
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
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
              case 30:
                return '30';
              case 35:
                return '35';
              case 40:
                return '40';
              case 45:
                return '45';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: null,
      minY: 0,
      lineBarsData: carbonEmission7DaysData(),
    );
  }

  List<LineChartBarData> carbonEmission7DaysData() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, double.parse(c7.toDouble().toStringAsFixed(2))),
        FlSpot(3, double.parse(c6.toDouble().toStringAsFixed(2))),
        FlSpot(5, double.parse(c5.toDouble().toStringAsFixed(2))),
        FlSpot(7, double.parse(c4.toDouble().toStringAsFixed(2))),
        FlSpot(9, double.parse(c3.toDouble().toStringAsFixed(2))),
        FlSpot(11, double.parse(c2.toDouble().toStringAsFixed(2))),
        FlSpot(13, double.parse(c1.toDouble().toStringAsFixed(2))),
      ],
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
