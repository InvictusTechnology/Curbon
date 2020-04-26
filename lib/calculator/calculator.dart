import 'transportation.dart';
import 'package:fluttermapapp/sample.dart';

// Calculation is referenced from: http://www.abc.net.au/science/news/stories/s768017.htm
// An article quoting a paper from RMIT University entitled "Comparison of Emissions from the Public Transport System and Private Cars"
List<Transportation> transData = [
  Transportation(vehicle: "car", carbonEmission: 0.25),
  Transportation(vehicle: "bus", carbonEmission: 0.04),
  Transportation(vehicle: "tram", carbonEmission: 0.74),
  Transportation(vehicle: "train", carbonEmission: 0.23),
  Transportation(vehicle: "bicycle", carbonEmission: 0.00),
  Transportation(vehicle: "walking", carbonEmission: 0.00),
];

class Calculator {
  int distance = 200;
  String carbonResult;

  String getResult(int userChoice) {
    double carbonEmitted = transData[userChoice].carbonEmission;
    double result = distance * carbonEmitted;
    carbonResult = result.toStringAsFixed(2);
    return carbonResult; //the result is in kg CO2
  }

  String getVehicle(int userChoice) {
    return transData[userChoice].vehicle;
  }
}
