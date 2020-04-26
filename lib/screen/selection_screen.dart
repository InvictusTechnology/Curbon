import 'package:flutter/material.dart';

import 'package:fluttermapapp/components/vehicle_cards.dart';
import 'package:fluttermapapp/components/icon_content.dart';
import 'package:fluttermapapp/components/bottom_container.dart';
import 'package:fluttermapapp/constant.dart';
import 'package:fluttermapapp/calculator/calculator.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  Vehicle selectedVehicle;
  int userChoice;
  String message = 'Have not selected any transport';
  String result = '0';
  String vehicle = '';

  void calculate(int choice) {
    setState(() {
      try {
        result = (Calculator().getResult(choice)).toString();
        vehicle = Calculator().getVehicle(choice);
        message = 'Your trip using $vehicle emitted:';
      } catch (e) {
        print('Have not pressed anything');
        throw message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Collumn for type of transportations
          SizedBox(
            height: 5,
          ),
          Text(
            'Choose a Transport',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.car;
                      userChoice = 0;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.car
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.directions_car,
                    label: 'Car',
                  ),
                ),
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.bus;
                      userChoice = 1;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.bus
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.directions_bus,
                    label: 'Bus',
                  ),
                ),
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.tram;
                      userChoice = 2;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.tram
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.tram,
                    label: 'Tram',
                  ),
                ),
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.train;
                      userChoice = 3;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.train
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.train,
                    label: 'Train',
                  ),
                ),
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.bicycle;
                      userChoice = 4;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.bicycle
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.motorcycle,
                    label: 'Bicycle',
                  ),
                ),
                VehicleCard(
                  onPress: () {
                    setState(() {
                      selectedVehicle = Vehicle.walking;
                      userChoice = 5;
                      calculate(userChoice);
                    });
                  },
                  colour: selectedVehicle == Vehicle.walking
                      ? activeColor
                      : inactiveColor,
                  cardChild: IconContent(
                    icon: Icons.directions_walk,
                    label: 'Walking',
                  ),
                ),
              ],
            ),
          ),
          ResultContainer(
            message: message,
            result: result,
            vehicle: vehicle,
          )
        ],
      ),
    );
  }
}

enum Vehicle { car, bus, tram, train, bicycle, walking }
