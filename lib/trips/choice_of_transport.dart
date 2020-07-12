import 'package:curbonapp/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'indicator.dart';
import 'trips_constructor.dart';

// The class is used to show the chart for how many times that particular transport is used
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

  void calculateTransport() {
    for (int i = 0; i <= widget.tripList.length - 1; i++) {
      String transport = widget.tripList[i].transport;
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
    }
    totalTransport = car + bus + tram + train + bicycle + walking + motorcycle;
  }

  @override
  void initState() {
    super.initState();
    calculateTransport();
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                'Choice of Transport',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                'Within the Last 30 Days',
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
                    aspectRatio: 1.3,
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
                          centerSpaceRadius: 35,
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
            title: car == 0 ? '' : car.toString(),
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
            title: bus == 0 ? '' : bus.toString(),
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
            title: tram == 0 ? '' : tram.toString(),
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
            title: train == 0 ? '' : train.toString(),
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
            title: bicycle == 0 ? '' : bicycle.toString(),
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
            title: walking == 0 ? '' : walking.toString(),
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
            title: motorcycle == 0 ? '' : motorcycle.toString(),
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
