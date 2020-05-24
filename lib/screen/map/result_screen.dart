import 'package:curbonapp/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curbonapp/calculator/calculator.dart';
import 'package:curbonapp/components/bottom_navigation_bar.dart';
import 'package:curbonapp/calculator/uploader_firebase.dart';
import 'package:badges/badges.dart';
import 'package:curbonapp/tips/tips_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curbonapp/components/level_up_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ResultScreen extends StatefulWidget {
  final double distance;
  final String destination;
  final String starting;
  final String vehicle;
  final int userChoice;

  const ResultScreen({
    this.distance,
    this.destination,
    this.starting,
    this.vehicle,
    this.userChoice,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  final _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _moveToHomeScreen(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/loading');
  PageController _pageController;
  List<Widget> whatIfPages = [];
  String result = '0';
  String vehicle = '';
  String convertedDistance;
  String dropdownValue;
  int randomNumber = 0;
  int currentPageValue = 0;
  bool showSpinner;
  bool isLevelUp;
  bool _isReady;

  int getPoint() {
    switch (widget.vehicle) {
      case 'Bicycle':
        {
          return 10;
        }
        break;
      case 'Walking':
        {
          return 10;
        }
        break;
      case 'Bus':
        {
          return 8;
        }
        break;
      case 'Tram':
        {
          return 7;
        }
        break;
      case 'Train':
        {
          return 5;
        }
        break;
      case 'Motorcycle':
        {
          return 3;
        }
        break;
      case 'Car':
        {
          return 2;
        }
        break;
      default:
        {
          return 0;
        }
        break;
    }
  }

  void setProfile() async {
    int newPoint = getPoint();
    final user = await _auth.currentUser();
    var point;
    var level;
    var profile = await _firestore
        .collection('profile')
        .where('user', isEqualTo: user.email)
        .getDocuments();

    for (var doc in profile.documents) {
      point = doc.data['point'];
      level = doc.data['level'];
    }
    point = point + newPoint;
    if (point >= 100) {
      point = point - 100;
      level = level + 1;
      isLevelUp = true;
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return LevelUpDialog();
          });
    } else {
      isLevelUp = false;
    }
    await _firestore
        .collection('profile')
        .document(user.email)
        .updateData({'point': point, 'level': level});

    print(isLevelUp);
    setState(() {
      _isReady = true;
      showSpinner = false;
    });
  }

  Widget infoText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        maxLines: 1,
        style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.6),
      ),
    );
  }

  Widget resultText(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.6),
      ),
    );
  }

  Widget calculationBox({int choice, String transport, String carbon}) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(12.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5, bottom: 7),
                child: iconChooser(choice),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 7),
                child: Text(
                  transport,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              '$carbon KgCO2',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }

  void calculate(int choice) {
    setState(() {
      try {
        result = (Calculator()
                .getResult(userChoice: choice, distance: widget.distance))
            .toString();
        vehicle = Calculator().getVehicle(choice);
      } catch (e) {
        throw e;
      }
    });
  }

  void getConvertedDistance() {
    convertedDistance = (widget.distance / 1000).toStringAsFixed(2);
  }

  String whatIfCalculate(int choice) {
    return (Calculator()
            .getResult(userChoice: choice, distance: widget.distance))
        .toString();
  }

  void assignWhatIf() {
    String carCarbon = whatIfCalculate(0);
    String busCarbon = whatIfCalculate(1);
    String tramCarbon = whatIfCalculate(2);
    String trainCarbon = whatIfCalculate(3);
    String bicycleCarbon = whatIfCalculate(4);
    String walkingCarbon = whatIfCalculate(5);
    String motorcycleCarbon = whatIfCalculate(6);

    whatIfPages = [
      calculationBox(choice: 0, transport: 'Car', carbon: carCarbon),
      calculationBox(choice: 1, transport: 'Bus', carbon: busCarbon),
      calculationBox(choice: 2, transport: 'Tram', carbon: tramCarbon),
      calculationBox(choice: 3, transport: 'Train', carbon: trainCarbon),
      calculationBox(choice: 4, transport: 'Bicycle', carbon: bicycleCarbon),
      calculationBox(choice: 5, transport: 'Walking', carbon: walkingCarbon),
      calculationBox(
          choice: 6, transport: 'Motorbike', carbon: motorcycleCarbon),
    ];
  }

  @override
  void initState() {
    super.initState();
    _isReady = false;
    setState(() {
      showSpinner = true;
    });
    getConvertedDistance();
    assignWhatIf();
    calculate(widget.userChoice);
    whatIfCalculate(widget.userChoice);

    Uploader uploader = Uploader(
      distance: convertedDistance,
      destination: widget.destination,
      starting: widget.starting,
      carbon: result,
      transport: widget.vehicle,
    );
    uploader.uploadResult();
    setProfile();
  }

  @override
  Widget build(BuildContext context) {
    int tipOne = Random().nextInt(TipsList().getTotalList());
    int tipTwo = Random().nextInt(TipsList().getTotalList() - 1);
    if (tipTwo >= tipOne) tipTwo += 1;
    return WillPopScope(
      child: Scaffold(
        bottomNavigationBar: BottomBar(
          selectedIndex: 1,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your Carbon Emission',
                      style: TextStyle(
                        fontSize: 27.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1b1b1b),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 75,
                        child: Column(
                          children: <Widget>[
                            infoText('To:'),
                            infoText('From:'),
                            infoText('Distance:'),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            resultText(widget.destination),
                            resultText(widget.starting),
                            resultText('$convertedDistance km'),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your transport',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: AnimatedSize(
                              vsync: this,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOutCirc,
                              child: Container(
                                width: 150,
                                height: _isReady ? 100 : 0,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: kBoxShadow,
                                    border: Border.all(
                                      color: Colors.grey[400],
                                    ),
                                    borderRadius: BorderRadius.circular(12.5)),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 7, bottom: 7),
                                          child: iconChooser(widget.userChoice),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 7),
                                          child: Text(
                                            widget.vehicle,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$result KG.CO2',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Text(
                                'What if',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 140,
                            padding: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(),
                            child: PageView.builder(
                              physics: ClampingScrollPhysics(),
                              itemCount: whatIfPages.length,
                              onPageChanged: (int page) {
                                getChangedPageAndMoveBar(page);
                              },
                              controller: _pageController,
                              itemBuilder: (context, index) {
                                return whatIfPages[index];
                              },
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.topStart,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    for (int i = 0; i < whatIfPages.length; i++)
                                      if (i == currentPageValue) ...[
                                        circleBar(true)
                                      ] else
                                        circleBar(false),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'What can you do?',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        AnimatedSize(
                          vsync: this,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOutCirc,
                          child: getTips(
                            '1',
                            TipsList().getTitle(tipOne),
                            TipsList().getContent(tipOne),
                            _isReady ? 10 : 1000,
                          ),
                        ),
                        AnimatedSize(
                          vsync: this,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOutCirc,
                          child: getTips(
                              '2',
                              TipsList().getTitle(tipTwo),
                              TipsList().getContent(tipTwo),
                              _isReady ? 10 : 1000),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // ignore: missing_return
      onWillPop: () {
        _moveToHomeScreen(context);
      },
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 6 : 4,
      width: isActive ? 6 : 4,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF26CB7E) : Color(0xFFadc4b9),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  Container getTips(
      String tipsNumber, String tipsTitle, String tipsContent, double margin) {
    return Container(
      margin: EdgeInsets.only(top: margin),
      decoration: BoxDecoration(
          boxShadow: kBoxShadow,
          border: Border.all(
            color: Color(0xFF1b1b1b),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF67ECAB)),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 12.5),
                child: Badge(
                  badgeColor: Colors.white,
                  shape: BadgeShape.circle,
                  borderRadius: 20,
                  toAnimate: false,
                  badgeContent: Text(tipsNumber,
                      style: TextStyle(fontSize: 15, color: Color(0xFF1b1b1b))),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text(
                    tipsTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              tipsContent,
              style: TextStyle(height: 1.4, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget iconChooser(int userChoice) {
    int i = userChoice;
    if (i == 0) {
      return Icon(
        Icons.directions_car,
        size: 35,
        color: themeColor,
      );
    } else if (i == 1) {
      return Icon(
        Icons.directions_bus,
        size: 35,
        color: themeColor,
      );
    } else if (i == 2) {
      return Icon(
        Icons.tram,
        size: 35,
        color: themeColor,
      );
    } else if (i == 3) {
      return Icon(
        Icons.train,
        size: 35,
        color: themeColor,
      );
    } else if (i == 4) {
      return Icon(
        Icons.directions_bike,
        size: 35,
        color: themeColor,
      );
    } else if (i == 5) {
      return Icon(
        Icons.directions_walk,
        size: 35,
        color: themeColor,
      );
    } else {
      return Icon(
        Icons.motorcycle,
        size: 35,
        color: themeColor,
      );
    }
  }
}
