//import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/material.dart';
//import 'package:fl_chart/fl_chart.dart';
//
//class VisualisationThree extends StatefulWidget {
//  @override
//  _VisualisationThreeState createState() => _VisualisationThreeState();
//}
//
//class _VisualisationThreeState extends State<VisualisationThree> {
//  final _database = FirebaseDatabase.instance.reference();
//  List<BarChartGroupData> rawBarGroups;
//  List<BarChartGroupData> showingBarGroups;
//  double artsCulture = 0;
//  double commService = 0;
//  double engServices = 0;
//
//  void getArtsCulture() async {
//    var jsonData;
//    await _database
//        .child('vi3')
//        .orderByChild('Branch')
//        .equalTo('Arts and Culture')
//        .once()
//        .then((DataSnapshot snapshot) {
//      jsonData = snapshot.value;
//    });
//    for (int i = 0; i <= jsonData.length - 1; i++) {
//      try {
//        if (jsonData[i] != null) {
//          if (jsonData[''])
//        }
//      } catch (e) {
//        print(e);
//        throw e;
//      }
//    }
//    getCommService();
//  }
//
//  // 329844
//  void getEngServices() async {
//    var jsonData;
//    await _database
//        .child('vi3')
//        .orderByChild('Branch')
//        .equalTo('Engineering Services')
//        .once()
//        .then((DataSnapshot snapshot) {
//      jsonData = snapshot.value;
//    });
//    for (int i = 0; i <= jsonData.length - 1; i++) {
//      try {
//        if (jsonData[i] != null) {
//          var jj = jsonData[i]['Total Greenhouse Gases'];
//          engServices = engServices + jj;
//        }
//      } catch (e) {
//        print(e);
//        throw e;
//      }
//    }
//
//    final items = [
//      makeGroupData(3, engServices / 1000),
//    ];
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getArtsCulture();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SafeArea(
//        child: Column(
//          children: <Widget>[
//            RaisedButton(onPressed: () {
//              getArtsCulture();
//            })
//          ],
//        ),
//      ),
//    );
//  }
//
//  BarChartGroupData makeGroupData(int x, double y1) {
//    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
//      BarChartRodData(
//        y: y1,
//        color: Color(0xFF315F52),
//        width: 50,
//      ),
//    ]);
//  }
//}
