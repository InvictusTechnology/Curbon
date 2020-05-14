import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';
import 'trips_constructor.dart';

// ignore: must_be_immutable
class TransportChoiceChart extends StatefulWidget {
  List<Trips> tripList;
  TransportChoiceChart({this.tripList});
  @override
  _TransportChoiceChartState createState() => _TransportChoiceChartState();
}

class _TransportChoiceChartState extends State<TransportChoiceChart> {
  int touchedIndex;
  int car = 0,
      bus = 0,
      tram = 0,
      train = 0,
      walking = 0,
      bicycle = 0,
      motorcycle = 0;
  int totalTransport;

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
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinTwo) {
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinThree) {
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinFour) {
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinFive) {
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinSix) {
        calculateTransport(widget.tripList[i].transport);
      } else if (newDate == dayMinSeven) {
        calculateTransport(widget.tripList[i].transport);
      }
    }
    totalTransport = car + bus + tram + train + bicycle + walking + motorcycle;
  }

  void calculateTransport(String transport) {
    if (transport == 'Car') {
      car++;
    } else if (transport == 'Bus') {
      bus++;
    } else if (transport == 'Tram') {
      tram++;
    } else if (transport == 'Train') {
      train++;
    } else if (transport == 'Bicycle') {
      bicycle++;
    } else if (transport == 'Walking') {
      walking++;
    } else if (transport == 'Motorcycle') {
      motorcycle++;
    }
    print(motorcycle);
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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700],
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            colors: const [
              Color(0xFF2D4261),
              Color(0xFF405b82),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                'Choice of Transport',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                'Within the Last 7 Days',
                style: TextStyle(
                    color: Color(0xff77839a),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1.23,
                    child: PieChart(
                      PieChartData(
                          pieTouchData:
                              PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse.touchInput
                                      is FlLongPressEnd ||
                                  pieTouchResponse.touchInput is FlPanEnd) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex =
                                    pieTouchResponse.touchedSectionIndex;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections()),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: Color(0xFFF97370),
                      text: 'Car',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xFFFC9F53),
                      text: 'Bus',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff13d38e),
                      text: 'Tram',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xFF00ab44),
                      text: 'Train',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Indicator(
                      color: Color(0xFF3442BF),
                      text: 'Bicycle',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Indicator(
                      color: Color(0xff845bef),
                      text: 'Walking',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Indicator(
                      color: Color(0xFFed64d6),
                      text: 'Motorcycle',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(7, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 22 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xFFF97370),
            value: (car / totalTransport) * 100,
            title: isTouched ? car.toString() : car.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xFFFC9F53),
            value: (bus / totalTransport) * 100,
            title: isTouched ? bus.toString() : bus.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: (tram / totalTransport) * 100,
            title: isTouched ? tram.toString() : tram.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFF00ab44),
            value: (train / totalTransport) * 100,
            title: isTouched ? train.toString() : train.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: Color(0xFF3442BF),
            value: (bicycle / totalTransport) * 100,
            title: isTouched ? bicycle.toString() : bicycle.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 5:
          return PieChartSectionData(
            color: Color(0xff845bef),
            value: (walking / totalTransport) * 100,
            title: isTouched ? walking.toString() : walking.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 6:
          return PieChartSectionData(
            color: Color(0xFFed64d6),
            value: (motorcycle / totalTransport) * 100,
            title: isTouched ? motorcycle.toString() : motorcycle.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
