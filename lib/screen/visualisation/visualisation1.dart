import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:curbonapp/components/visualisation_components.dart';
import 'package:firebase_database/firebase_database.dart';

class VisualisationOne extends StatefulWidget {
  @override
  _VisualisationOneState createState() => _VisualisationOneState();
}

class _VisualisationOneState extends State<VisualisationOne> {
  final _storage = FirebaseDatabase.instance.reference();
  bool showSpinner = false;
  bool dataReady = false;
  String selectedChart = 'Australian Capital Territory';
  List<Widget> pageButtons = [];
  List<FlSpot> pointStarter = [];
  List nswList = [];
  List vicList = [];
  List qldList = [];
  List saList = [];
  List waList = [];
  List tasList = [];
  List ntList = [];
  List actList = [];
  int currentPageValue = 0;

  void parseJson() async {
    try {
      var jsonResult;
      await _storage.child('vizz1').once().then((DataSnapshot snapshot) {
        jsonResult = snapshot.value;
      });
      //After the app finish download, it will load the JSON file to the different states using if-statement
      for (int i = 0; i <= jsonResult.length - 1; i++) {
        if (jsonResult[i]['State'] == 'NSW') {
          nswList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'VIC') {
          vicList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'QLD') {
          qldList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'SA') {
          saList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'WA') {
          waList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'TAS') {
          tasList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else if (jsonResult[i]['State'] == 'NT') {
          ntList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        } else {
          actList.add(jsonResult[i]['CO2e emissions (tonnes per capita)']);
        }
      }
      setState(() {
        showSpinner = false;
        dataReady = true;
      });
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    for (int i = 0; i <= 28; i++) {
      pointStarter.add(FlSpot(i.toDouble() + 1, 0));
    }
    super.initState();
    showSpinner = true;
    for (int i = 0; i <= 28; i++) {
      pointStarter.add(FlSpot(i.toDouble() + 1, 0));
    }
    dataReady = false;
    parseJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomBar(selectedIndex: 2),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 40, top: 30, right: 40),
                    child: Text(
                      'Australia\'s State and Territory CO2e Emissions per Capita',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
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
                  label: '(1990 - 2017)'),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        chartButton(
                          onPress: () {
                            setState(() {
                              selectedChart = 'Australian Capital Territory';
                            });
                          },
                          text: 'Australian Capital Territory',
                          isSelected:
                              selectedChart == 'Australian Capital Territory'
                                  ? true
                                  : false,
                        ),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'New South Wales';
                              });
                            },
                            text: 'New South Wales',
                            isSelected: selectedChart == 'New South Wales'
                                ? true
                                : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'Northern Territory';
                              });
                            },
                            text: 'Northern Territory',
                            isSelected: selectedChart == 'Northern Territory'
                                ? true
                                : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'Queensland';
                              });
                            },
                            text: 'Queensland',
                            isSelected:
                                selectedChart == 'Queensland' ? true : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'South Australia';
                              });
                            },
                            text: 'South Australia',
                            isSelected: selectedChart == 'South Australia'
                                ? true
                                : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'Tasmania';
                              });
                            },
                            text: 'Tasmania',
                            isSelected:
                                selectedChart == 'Tasmania' ? true : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'Victoria';
                              });
                            },
                            text: 'Victoria',
                            isSelected:
                                selectedChart == 'Victoria' ? true : false),
                        chartButton(
                            onPress: () {
                              setState(() {
                                selectedChart = 'Western Australia';
                              });
                            },
                            text: 'Western Australia',
                            isSelected: selectedChart == 'Western Australia'
                                ? true
                                : false),
                        Container(
                          margin: EdgeInsets.only(bottom: 15, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('A link to the dataset can be found '),
                              InkWell(
                                onTap: () => launch(
                                  'https://data.gov.au/dataset/ds-dga-77726fe7-ac78-4e4d-a8f7-05c55b417858/distribution/dist-dga-7c13f590-a4c6-415c-af4d-9a8e982a0578/details?q=state%20and%20territory%20co2e',
                                ),
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

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  LineChartData stateData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        // ignore: missing_return
        horizontalInterval: (() {
          if (selectedChart == 'Northern Territory') {
            return 20.0;
          } else if (selectedChart == 'Western Australia' ||
              selectedChart == 'Queensland' ||
              selectedChart == 'Tasmania') {
            return 10.0;
          } else if (selectedChart == 'Australian Capital Territory') {
            return 1.0;
          } else {
            return 5.0;
          }
        }()),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[800],
            strokeWidth: 0.2,
          );
        },
      ),
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
              for (int i = 1; i <= 28; i++) {
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
              case 29:
                return '2018';
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
            if (selectedChart == 'Northern Territory') {
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
            } else if (selectedChart == 'Western Australia' ||
                selectedChart == 'Queensland' ||
                selectedChart == 'Tasmania') {
              switch (value.toInt()) {
                case 10:
                  return '10';
                case 20:
                  return '20';
                case 30:
                  return '30';
                case 40:
                  return '40';
                case 50:
                  return '50';
                case 60:
                  return '60';
                case 70:
                  return '70';
              }
              return '';
            } else if (selectedChart == 'Australian Capital Territory') {
              switch (value.toInt()) {
                case 2:
                  return '2';
                case 4:
                  return '4';
                case 6:
                  return '6';
                case 8:
                  return '8';
              }
              return '';
            } else {
              switch (value.toInt()) {
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
          case 'New South Wales':
            {
              return stateLineBarData(0);
            }
            break;
          case 'Victoria':
            {
              return stateLineBarData(1);
            }
            break;
          case 'Queensland':
            {
              return stateLineBarData(2);
            }
            break;
          case 'South Australia':
            {
              return stateLineBarData(3);
            }
            break;
          case 'Western Australia':
            {
              return stateLineBarData(4);
            }
            break;
          case 'Tasmania':
            {
              return stateLineBarData(5);
            }
            break;
          case 'Northern Territory':
            {
              return stateLineBarData(6);
            }
            break;
          case 'Australian Capital Territory':
            {
              return stateLineBarData(7);
            }
            break;
        }
      }()),
    );
  }

  List<LineChartBarData> stateLineBarData(int chosenData) {
    List<FlSpot> chosenPointList = [];

    switch (chosenData) {
      case 0:
        {
          chosenPointList.clear();
          for (int i = 0; i <= nswList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, nswList[i]));
          }
        }
        break;
      case 1:
        {
          chosenPointList.clear();
          for (int i = 0; i <= vicList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, vicList[i]));
          }
        }
        break;
      case 2:
        {
          chosenPointList.clear();
          for (int i = 0; i <= qldList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, qldList[i]));
          }
        }
        break;
      case 3:
        {
          chosenPointList.clear();
          for (int i = 0; i <= saList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, saList[i]));
          }
        }
        break;
      case 4:
        {
          chosenPointList.clear();
          for (int i = 0; i <= waList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, waList[i]));
          }
        }
        break;
      case 5:
        {
          chosenPointList.clear();
          for (int i = 0; i <= tasList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, tasList[i]));
          }
        }
        break;
      case 6:
        {
          chosenPointList.clear();
          for (int i = 0; i <= ntList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, ntList[i]));
          }
        }
        break;
      case 7:
        {
          chosenPointList.clear();
          for (int i = 0; i <= actList.length - 1; i++) {
            chosenPointList.add(FlSpot(i.toDouble() + 1, actList[i]));
          }
        }
        break;
    }

    return [
      LineChartBarData(
        spots: !dataReady ? pointStarter : chosenPointList,
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
