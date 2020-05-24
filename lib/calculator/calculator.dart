import 'transportation.dart';

// A list of carbon emission from each type of transport
List<Transportation> transData = [
  Transportation(vehicle: "car", carbonEmission: 0.182),
  Transportation(vehicle: "bus", carbonEmission: 0.0274),
  Transportation(vehicle: "tram", carbonEmission: 0.06),
  Transportation(vehicle: "train", carbonEmission: 0.045),
  Transportation(vehicle: "bicycle", carbonEmission: 0.00),
  Transportation(vehicle: "walking", carbonEmission: 0.00),
  Transportation(vehicle: "motorcycle", carbonEmission: 0.094),
];

class Calculator {
  // to hold the result of emission
  String carbonResult;

  // get the result of carbon emission, by taking input from user's choice and distance
  String getResult({int userChoice, double distance}) {
    // get the carbon emitted per km of the type of transport from user's choice of transport
    double carbonEmitted = transData[userChoice].carbonEmission;
    // calculated the result from combining the input
    double result = (distance / 1000) * carbonEmitted;
    carbonResult =
        result.toStringAsFixed(2); // return the result with 2 decimal points
    return carbonResult; //the result is in kg CO2
  }

  // to return the user's choice of transport in a String
  String getVehicle(int userChoice) {
    return transData[userChoice].vehicle;
  }
}
