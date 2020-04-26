import 'package:flutter/material.dart';
import 'package:fluttermapapp/screen/selection_screen.dart';

void main() => runApp(home());

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Stack(
        children: <Widget>[
          SizedBox(
            height: 775,
            child: Container(
              child: SelectionScreen(),
            ),
          )
        ],
      )),
    );
  }
}
