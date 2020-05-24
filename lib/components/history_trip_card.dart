import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';

// This class is used to create the card containing trip history information. Used in HistoryScreen
// ignore: must_be_immutable
class HistoryCard extends StatefulWidget {
  String destination;
  String starting;
  String time;
  String transport;
  String carbon;
  String distance;
  bool isVisible;
  Function onPress;
  HistoryCard(
      {this.transport,
      this.distance,
      this.starting,
      this.destination,
      this.carbon,
      this.time,
      this.onPress,
      this.isVisible});
  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.bounceIn,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              boxShadow: kBoxShadow,
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.time,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 15),
                        iconSelector(widget.transport),
                        Text(
                          widget.transport,
                          style: TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.starting,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                widget.destination,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Text(
                                widget.distance,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(' km')),
                              SizedBox(width: 25),
                              Text(
                                widget.carbon,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600),
                              ),
                              Text(' kg.CO2'),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        FlatButton(
          highlightColor: Colors.white,
          splashColor: Colors.transparent,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: widget.onPress,
          child: widget.isVisible
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                )
              : Text(''),
        )
      ],
    );
  }

  // ignore: missing_return
  Icon iconSelector(String transport) {
    switch (transport) {
      case 'Car':
        {
          return Icon(
            Icons.directions_car,
            color: Colors.red,
            size: 30,
          );
        }
        break;
      case 'Bus':
        {
          return Icon(
            Icons.directions_bus,
            color: Colors.blue,
            size: 30,
          );
        }
        break;
      case 'Tram':
        {
          return Icon(
            Icons.tram,
            color: Colors.yellow[600],
            size: 30,
          );
        }
        break;
      case 'Train':
        {
          return Icon(
            Icons.train,
            color: Colors.lightGreen[400],
            size: 30,
          );
        }
        break;
      case 'Bicycle':
        {
          return Icon(
            Icons.directions_bike,
            color: themeColor,
            size: 30,
          );
        }
        break;
      case 'Walking':
        {
          return Icon(
            Icons.directions_walk,
            color: Colors.cyan[300],
            size: 30,
          );
        }
        break;
      case 'Motorcycle':
        {
          return Icon(
            Icons.motorcycle,
            color: Colors.orange,
            size: 30,
          );
        }
        break;
    }
  }
}
