import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curbonapp/components/visualisation_components.dart';

class VisualisationTwo extends StatefulWidget {
  @override
  _VisualisationTwoState createState() => _VisualisationTwoState();
}

class _VisualisationTwoState extends State<VisualisationTwo> {
  final _storage = FirebaseDatabase.instance.reference();
  bool showSpinner = false;
  bool dataReady = false;
  String selectedChart = 'Cars';
  int currentPageValue = 0;
  var jsonData;
  List<FlSpot> pointStarter = [];
  List domAvi = [];
  List cars = [];
  List lightVehicles = [];
  List heavyTrucks = [];
  List motorcycles = [];
  List railways = [];
  List navigation = [];
  List others = [];

  void getData() async {
    await _storage.child('vizz2').once().then((DataSnapshot snapshot) {
      jsonData = snapshot.value;
    });
    for (int i = 1990; i <= 2016; i++) {
      int index = 0;
      domAvi.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 1;
      cars.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 2;
      lightVehicles.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 3;
      heavyTrucks.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 4;
      motorcycles.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 5;
      railways.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 6;
      navigation.add(jsonData[index]['$i']);
    }
    for (int i = 1990; i <= 2016; i++) {
      int index = 7;
      others.add(jsonData[index]['$i']);
    }
    setState(() {
      showSpinner = false;
      dataReady = true;
    });
  }

  @override
  void initState() {
    showSpinner = true;
    super.initState();
    for (int i = 0; i <= 27; i++) {
      pointStarter.add(FlSpot(i.toDouble() + 1, 0));
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(selectedIndex: 2),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 30, right: 30),
                    child: Text(
                      'Transport Sector Greenhouse Gas Emission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }))
                ],
              ),
              chartWidget(
                  selectedChart: selectedChart,
                  lineChartData: stateData(),
                  label: '(1990-2016)'),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Cars';
                            });
                          },
                          text: 'Cars',
                          isSelected: selectedChart == 'Cars' ? true : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Domestic Aviation';
                            });
                          },
                          text: 'Domestic Aviation',
                          isSelected: selectedChart == 'Domestic Aviation'
                              ? true
                              : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Heavy Duty Trucks and Buses';
                            });
                          },
                          text: 'Heavy Duty Trucks and Buses',
                          isSelected:
                              selectedChart == 'Heavy Duty Trucks and Buses'
                                  ? true
                                  : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Light Commercial Vehicles';
                            });
                          },
                          text: 'Light Commercial Vehicles',
                          isSelected:
                              selectedChart == 'Light Commercial Vehicles'
                                  ? true
                                  : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Motorcycles';
                            });
                          },
                          text: 'Motorcycles',
                          isSelected:
                              selectedChart == 'Motorcycles' ? true : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Navigation';
                            });
                          },
                          text: 'Navigation',
                          isSelected:
                              selectedChart == 'Navigation' ? true : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Others';
                            });
                          },
                          text: 'Others',
                          isSelected: selectedChart == 'Others' ? true : false,
                        ),
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Railways';
                            });
                          },
                          text: 'Railways',
                          isSelected:
                              selectedChart == 'Railways' ? true : false,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('A link to the dataset can be found '),
                              InkWell(
                                onTap: () => launch(
                                    'https://www.data.qld.gov.au/dataset/32710aab-dc32-40a6-a09e-6e937632eda7'),
                                child: Text(
                                  'here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData stateData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              if (flSpot.x == 0 || flSpot.x == 6) {
                return null;
              }
              var label;
              for (int i = 1; i <= 27; i++) {
                if (flSpot.x == i) {
                  label = i + 1989;
                }
              }
              return LineTooltipItem(
                '${(flSpot.y).toStringAsFixed(1)}  CO2e \n$label',
                TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
          horizontalInterval: (() {
            if (selectedChart == 'Cars') {
              return 2.0;
            } else if (selectedChart == 'Light Commercial Vehicles' ||
                selectedChart == 'Domestic Aviation') {
              return 0.5;
            } else if (selectedChart == 'Heavy Duty Trucks and Buses') {
              return 1.0;
            } else {
              return 0.1;
            }
          }()),
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[800], strokeWidth: 0.2);
          }),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1990';
              case 5:
                return '1994';
              case 9:
                return '1998';
              case 13:
                return '2002';
              case 17:
                return '2006';
              case 21:
                return '2010';
              case 25:
                return '2014';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          // ignore: missing_return
          getTitles: (value) {
            if (selectedChart == 'Cars') {
              switch (value.toInt()) {
                case 2:
                  return '2';
                case 4:
                  return '4';
                case 6:
                  return '6';
                case 8:
                  return '4';
                case 10:
                  return '10';
              }
              return '';
            } else if (selectedChart == 'Domestic Aviation' ||
                selectedChart == 'Light Commercial Vehicles' ||
                selectedChart == 'Heavy Duty Trucks and Buses') {
              switch (value.toInt()) {
                case 1:
                  return '1';
                case 2:
                  return '2';
                case 3:
                  return '3';
                case 4:
                  return '4';
                case 5:
                  return '5';
              }
              return '';
            } else {
              switch (value.toInt() * 10) {
                case 1:
                  return '1';
                case 2:
                  return '2';
                case 3:
                  return '3';
                case 4:
                  return '4';
                case 5:
                  return '5';
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
              width: 2,
            ),
            left: BorderSide(
              color: Colors.grey[400],
            ),
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
      // ignore: missing_return
      lineBarsData: (() {
        switch (selectedChart) {
          case 'Domestic Aviation':
            {
              return transportLineBarData(0);
            }
            break;
          case 'Cars':
            {
              return transportLineBarData(1);
            }
            break;
          case 'Light Commercial Vehicles':
            {
              return transportLineBarData(2);
            }
            break;
          case 'Heavy Duty Trucks and Buses':
            {
              return transportLineBarData(3);
            }
            break;
          case 'Motorcycles':
            {
              return transportLineBarData(4);
            }
            break;
          case 'Railways':
            {
              return transportLineBarData(5);
            }
            break;
          case 'Navigation':
            {
              return transportLineBarData(6);
            }
            break;
          case 'Others':
            {
              return transportLineBarData(7);
            }
            break;
        }
      }()),
    );
  }

  List<LineChartBarData> transportLineBarData(int chosenData) {
    List<FlSpot> chosenPointList = [];
    switch (chosenData) {
      case 0:
        {
          chosenPointList.clear();
          for (int i = 0; i <= domAvi.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, domAvi[i]));
          }
        }
        break;
      case 1:
        {
          chosenPointList.clear();
          for (int i = 0; i <= cars.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, cars[i]));
          }
        }
        break;
      case 2:
        {
          chosenPointList.clear();
          for (int i = 0; i <= lightVehicles.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, lightVehicles[i]));
          }
        }
        break;
      case 3:
        {
          chosenPointList.clear();
          for (int i = 0; i <= heavyTrucks.length - 1; i++) {
            chosenPointList
                .add(FlSpot(i.toDouble() + 1, heavyTrucks[i].toDouble()));
          }
        }
        break;
      case 4:
        {
          chosenPointList.clear();
          for (int i = 0; i <= motorcycles.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, motorcycles[i]));
          }
        }
        break;
      case 5:
        {
          chosenPointList.clear();
          for (int i = 0; i <= railways.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, railways[i]));
          }
        }
        break;
      case 6:
        {
          chosenPointList.clear();
          for (int i = 0; i <= navigation.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, navigation[i]));
          }
        }
        break;
      case 7:
        {
          chosenPointList.clear();
          for (int i = 0; i <= others.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, others[i]));
          }
        }
        break;
    }

    return [
      LineChartBarData(
        spots: dataReady ? chosenPointList : pointStarter,
        isCurved: true,
        curveSmoothness: 0,
        colors: const [
          Color(0xFF58d178),
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }
}
