import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Visualisation extends StatelessWidget {
  void _moveToHomeScreen(BuildContext context) =>
      Navigator.pushReplacementNamed(
          context, _hasLoggedIn == true ? '/loading_home' : '/');
  bool _hasLoggedIn;

  void checkUserLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    email != null ? _hasLoggedIn = true : _hasLoggedIn = false;
    print('--- $_hasLoggedIn');

    _moveToHomeScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    {
      return WillPopScope(
        onWillPop: () {
          // ignore: missing_return, missing_return
          checkUserLoggedIn(context);
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('CURBON'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 350,
                  child: charts.BarChart(
                    _createVisualizationData(),
                    animate: true,
                    behaviors: [
                      charts.ChartTitle('Carbon emission in 2017'),
                      charts.ChartTitle('CO2e emission (tonnes per capita)',
                          behaviorPosition: charts.BehaviorPosition.start),
                      charts.ChartTitle('State',
                          behaviorPosition: charts.BehaviorPosition.bottom)
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomBar(
            selectedIndex: 2,
          ),
        ),
      );
    }
  }

  static List<charts.Series<CompanySizeVsNumberOfCompanies, String>>
      _createVisualizationData() {
    final data = [
      CompanySizeVsNumberOfCompanies("VIC", 17),
      CompanySizeVsNumberOfCompanies("ACT", 3),
      CompanySizeVsNumberOfCompanies("NSW", 16),
      CompanySizeVsNumberOfCompanies("NT", 66),
      CompanySizeVsNumberOfCompanies("QLD", 32),
      CompanySizeVsNumberOfCompanies("SA", 12),
      CompanySizeVsNumberOfCompanies("TAS", 2),
      CompanySizeVsNumberOfCompanies("WA", 34),
    ];

    return [
      charts.Series<CompanySizeVsNumberOfCompanies, String>(
          id: 'CompanySizeVsNumberOfCompanies',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (CompanySizeVsNumberOfCompanies dataPoint, _) =>
              dataPoint.companySize,
          measureFn: (CompanySizeVsNumberOfCompanies dataPoint, _) =>
              dataPoint.numberOfCompanies,
          data: data)
    ];
  }
}

class CompanySizeVsNumberOfCompanies {
  final String companySize;
  final int numberOfCompanies;

  CompanySizeVsNumberOfCompanies(this.companySize, this.numberOfCompanies);
}
