import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class VisualisationOne extends StatefulWidget {
  @override
  _VisualisationOneState createState() => _VisualisationOneState();
}

class _VisualisationOneState extends State<VisualisationOne> {
  PageController _pageController;
  bool showSpinner = false;
  bool dataReady = false;
  String selectedChart = 'New South Wales';
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
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/chart2.json");
    final jsonResult = json.decode(data);
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
  }

  @override
  void initState() {
    super.initState();
    showSpinner = true;
    for (int i = 0; i <= 28; i++) {
      pointStarter.add(FlSpot(i.toDouble() + 1, 0));
    }
    pageButtons = [columnOne(), columnTwo()];
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Text(
                  'State and Territory CO2e Emissions per Capita (Australia)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: AspectRatio(
                  aspectRatio: 1.23,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xFF0d6cbf),
                          Color(0xFF013461),
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
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "$selectedChart",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '(1990 - 2017)',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, left: 6.0),
                                child: LineChart(
                                  stateData(),
                                  swapAnimationDuration:
                                      const Duration(milliseconds: 250),
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
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: pageButtons.length,
                      onPageChanged: (int page) {
                        getChangedPageAndMoveBar(page);
                      },
                      controller: _pageController,
                      itemBuilder: (context, index) {
                        return pageButtons[index];
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 50),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < pageButtons.length; i++)
                                  if (i == currentPageValue) ...[
                                    circleBar(true)
                                  ] else
                                    circleBar(false),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () => launch(
                            'https://data.gov.au/dataset/ds-dga-77726fe7-ac78-4e4d-a8f7-05c55b417858/distribution/dist-dga-7c13f590-a4c6-415c-af4d-9a8e982a0578/details?q=state%20and%20territory%20co2e',
                          ),
                          child: Text(
                            'This information was obtained from here',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column columnOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        chartButton(
          onPress: 'New South Wales',
          text: 'New South Wales',
        ),
        chartButton(
          onPress: 'Victoria',
          text: 'Victoria',
        ),
        chartButton(
          onPress: 'Queensland',
          text: 'Queensland',
        ),
        chartButton(
          onPress: 'South Australia',
          text: 'South Australia',
        ),
      ],
    );
  }

  Column columnTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        chartButton(
          onPress: 'Western Australia',
          text: 'Western Australia',
        ),
        chartButton(
          onPress: 'Tasmania',
          text: 'Tasmania',
        ),
        chartButton(
          onPress: 'Northern Territory',
          text: 'Northern Territory',
        ),
        chartButton(
          onPress: 'Australian Capital Territory',
          text: 'Australian Capital Territory',
        ),
      ],
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF459fed) : Color(0xFFadc4b9),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  Container chartButton({String onPress, String text}) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
      decoration: BoxDecoration(
        color: Color(0xFF013461),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FlatButton(
          onPressed: () {
            setState(() {
              selectedChart = onPress;
            });
          },
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1),
          )),
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

              return LineTooltipItem(
                '${(flSpot.y).toStringAsFixed(1)}  CO2e',
                const TextStyle(color: Colors.white, fontSize: 13),
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
            color: Colors.grey[300],
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
                return '2017';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.grey[300],
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
              color: Colors.white70,
              width: 2,
            ),
            left: BorderSide(
              color: Colors.white70,
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
              return nswLineBarData();
            }
            break;
          case 'Victoria':
            {
              return vicLineBarData();
            }
            break;
          case 'Queensland':
            {
              return qldLineBarData();
            }
            break;
          case 'South Australia':
            {
              return saLineBarData();
            }
            break;
          case 'Western Australia':
            {
              return waLineBarData();
            }
            break;
          case 'Tasmania':
            {
              return tasLineBarData();
            }
            break;
          case 'Northern Territory':
            {
              return ntLineBarData();
            }
            break;
          case 'Australian Capital Territory':
            {
              return actLineBarData();
            }
            break;
        }
      }()),
    );
  }

  List<LineChartBarData> nswLineBarData() {
    List<FlSpot> nswPointList = [];
    for (int i = 0; i <= nswList.length - 1; i++) {
      nswPointList.add(FlSpot(i.toDouble() + 1, nswList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? nswPointList : pointStarter,
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

  List<LineChartBarData> vicLineBarData() {
    List<FlSpot> vicPointList = [];
    for (int i = 0; i <= vicList.length - 1; i++) {
      vicPointList.add(FlSpot(i.toDouble() + 1, vicList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? vicPointList : pointStarter,
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

  List<LineChartBarData> qldLineBarData() {
    List<FlSpot> qldPointList = [];
    for (int i = 0; i <= qldList.length - 1; i++) {
      qldPointList.add(FlSpot(i.toDouble() + 1, qldList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? qldPointList : pointStarter,
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

  List<LineChartBarData> saLineBarData() {
    List<FlSpot> saPointList = [];
    for (int i = 0; i <= saList.length - 1; i++) {
      saPointList.add(FlSpot(i.toDouble() + 1, saList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? saPointList : pointStarter,
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

  List<LineChartBarData> waLineBarData() {
    List<FlSpot> waPointList = [];
    for (int i = 0; i <= waList.length - 1; i++) {
      waPointList.add(FlSpot(i.toDouble() + 1, waList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? waPointList : pointStarter,
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

  List<LineChartBarData> tasLineBarData() {
    List<FlSpot> tasPointList = [];
    for (int i = 0; i <= tasList.length - 1; i++) {
      tasPointList.add(FlSpot(i.toDouble() + 1, tasList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? tasPointList : pointStarter,
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

  List<LineChartBarData> ntLineBarData() {
    List<FlSpot> ntPointList = [];
    for (int i = 0; i <= ntList.length - 1; i++) {
      ntPointList.add(FlSpot(i.toDouble() + 1, ntList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? ntPointList : pointStarter,
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

  List<LineChartBarData> actLineBarData() {
    List<FlSpot> actPointList = [];
    for (int i = 0; i <= actList.length - 1; i++) {
      actPointList.add(FlSpot(i.toDouble() + 1, actList[i]));
    }

    return [
      LineChartBarData(
        spots: dataReady ? actPointList : pointStarter,
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
