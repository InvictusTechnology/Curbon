import 'dart:async';

import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class TipsListScreen extends StatefulWidget {
  @override
  _TipsListScreenState createState() => _TipsListScreenState();
}

class _TipsListScreenState extends State<TipsListScreen> {
  List<Widget> tipsWidget = [];
  bool _isReady;

  void getTimer() {
    Timer(Duration(seconds: 0), () {
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  void initState() {
    _isReady = false;
    super.initState();
    getTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'List of Tips',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
                child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.decelerate,
                    margin: EdgeInsets.only(top: _isReady ? 0 : 1000),
                    child: TipsStream())),
          ],
        ),
      ),
    );
  }
}

class TipsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('tips_list').snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: themeColor,
          ));
        }

        final tips = snapshot.data.documents;
        List<Widget> tipsWidget = [];

        for (int i = 0; i <= tips.length - 1; i++) {
          var title = tips[i].data['title'];
          var content = tips[i].data['content'];
          tipsWidget.add(Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
            decoration: BoxDecoration(
                boxShadow: kBoxShadow,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 2,
                        margin: EdgeInsets.only(right: 5),
                        color: themeColor,
                      ),
                      Expanded(
                        child: Text(
                          content,
                          textAlign: TextAlign.left,
                          style: TextStyle(height: 1.4, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
        }
        return ListView(
          children: tipsWidget,
        );
      },
    );
  }
}
