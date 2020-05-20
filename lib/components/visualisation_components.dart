import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget chartWidget(
    {String selectedChart, LineChartData lineChartData, String label}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: Colors.white,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 4,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: LineChart(
                      lineChartData,
                      swapAnimationDuration: const Duration(milliseconds: 250),
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
  );
}

Widget backButton(BuildContext context) {
  return IconButton(
    icon: Icon(Icons.arrow_back_ios),
    onPressed: () {
      Navigator.pushReplacementNamed(context, '/visualisation');
    },
  );
}

Container chartButton({Function onPress, String text, bool isSelected}) {
  return Container(
    margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
    decoration: BoxDecoration(
      color: isSelected ? themeColor : Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: kBoxShadow,
    ),
    child: FlatButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1),
        )),
  );
}
