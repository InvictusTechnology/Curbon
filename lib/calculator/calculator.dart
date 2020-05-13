import 'transportation.dart';

// Calculation is referenced from: http://www.abc.net.au/science/news/stories/s768017.htm
// An article quoting a paper from RMIT University entitled "Comparison of Emissions from the Public Transport System and Private Cars"
List<Transportation> transData = [
  Transportation(vehicle: "car", carbonEmission: 0.182),
  Transportation(vehicle: "bus", carbonEmission: 0.0274),
  Transportation(vehicle: "tram", carbonEmission: 0.06),
  Transportation(vehicle: "train", carbonEmission: 0.045),
  Transportation(vehicle: "bicycle", carbonEmission: 0.00),
  Transportation(vehicle: "walking", carbonEmission: 0.00),
];

class Calculator {
  String carbonResult;

  String getResult({int userChoice, double distance}) {
    double carbonEmitted = transData[userChoice].carbonEmission;
    double result = (distance / 1000) * carbonEmitted;
    carbonResult = result.toStringAsFixed(2);
    return carbonResult; //the result is in kg CO2
  }

  String getVehicle(int userChoice) {
    return transData[userChoice].vehicle;
  }
}
