import 'package:curbonapp/components/history_trip_card.dart';
import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:curbonapp/trips/trips_constructor.dart';

// Instances for cloud firestore and Firebase users
final _firestore = Firestore.instance;
FirebaseUser currentUser;

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance; // for authentication
  bool showSpinner;
  bool isEdited;
  bool _isReady;
  List<Trips> tripList = [];

  // get the current user
  void getCurrentUserData() async {
    try {
      final user = await _auth.currentUser();
      currentUser = user;
      setState(() {
        showSpinner = false;
        _isReady = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
        _isReady = true;
      });
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _isReady = false;
    showSpinner = true;
    isEdited = false;
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, left: 10, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Text(
                          'History',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8),
                        ),
                      ],
                    ),
                    FlatButton(
                        // used for users if they want to remove that trip from history
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          setState(() {
                            isEdited = !isEdited;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            isEdited ? Text('Cancel') : Text('Edit '),
                            Icon(
                              Icons.edit,
                              size: 15,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.decelerate,
                  margin: EdgeInsets.only(top: _isReady ? 0 : 1000),
                  child: HistoryStream(isEdited),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// StreamBuilder class for History trips
// ignore: must_be_immutable
class HistoryStream extends StatelessWidget {
  bool isEdited;
  HistoryStream(this.isEdited);

  // a toast showing the error message
  void showErrorToast() {
    Fluttertoast.showToast(
        msg: "An error has occurred, please try again",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0x991b1b1b),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // a toast showing successful message
  void showToast() {
    Fluttertoast.showToast(
        msg: "Successfully deleted the trip",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Color(0x991b1b1b),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showDialog(BuildContext context, var documentID) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey[100].withOpacity(1),
          title: Text(
            "Alert",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Text(
            "This action will delete the selected trip. Continue?",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text(
                "Continue",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () async {
                try {
                  await _firestore
                      .collection('past_trips')
                      .document(documentID)
                      .delete();
                  Navigator.of(context).pop();
                  showToast();
                } catch (e) {
                  showErrorToast();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // format DateTime into humanreadable time
  String getTime(int epoch) {
    var formatTime = DateFormat('H:mm');
    DateTime time = DateTime.fromMillisecondsSinceEpoch(epoch);
    var timeString = formatTime.format(time);
    return timeString;
  }

  Widget dateTitle(String date) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10, bottom: 5),
        child: Text(
          date,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('past_trips')
          .where('user', isEqualTo: currentUser.email)
          .orderBy('createdTime', descending: true)
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: themeColor,
          ));
        }

        final trips = snapshot.data.documents;
        List<Widget> historyCards = [];

        for (int i = 0; i <= trips.length - 1; i++) {
          var format = DateFormat('MMM d, yyyy');
          DateTime dateTime;
          int epoch;
          var dateStringMinOne;
          var dateStringNow;

          final historyItem = HistoryCard(
            distance: trips[i].data['distance'],
            carbon: trips[i].data['carbon'],
            destination: trips[i].data['to'],
            starting: trips[i].data['from'],
            transport: trips[i].data['transport'],
            time: getTime(trips[i].data['createdTime']),
            isVisible: isEdited,
            onPress: () async {
              try {
                _showDialog(context, trips[i].documentID);
              } catch (e) {
                print(e);
              }
            },
          );
          if (i == 0) {
            epoch = trips[i].data['createdTime'];
            dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
            dateStringNow = format.format(dateTime);
            historyCards.add(Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.grey[100],
              ),
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: <Widget>[
                  dateTitle(dateStringNow),
                  historyItem,
                ],
              ),
            ));
          } else {
            epoch = trips[i].data['createdTime'];
            dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
            dateStringNow = format.format(dateTime);
            epoch = trips[i - 1].data['createdTime'];
            dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
            dateStringMinOne = format.format(dateTime);
            if (dateStringMinOne == dateStringNow) {
              historyCards.add(Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: historyItem,
              ));
            } else {
              historyCards.add(
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.grey[100],
                  ),
                  margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      dateTitle(dateStringNow),
                      historyItem,
                    ],
                  ),
                ),
              );
            }
          }
        }
        return ListView(
          children: historyCards,
        );
      },
    );
  }
}
