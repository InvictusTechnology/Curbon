import 'package:flutter/material.dart';

class IntroPages extends StatefulWidget {
  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  List<Widget> introPages = [PageOneIntro(), PageTwoIntro(), PageThreeIntro()];
  PageController _pageController;
  int currentPageValue = 0;

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Color(0xFF26CB7E) : Color(0xFFadc4b9),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: introPages.length,
              onPageChanged: (int page) {
                getChangedPageAndMoveBar(page);
              },
              controller: _pageController,
              itemBuilder: (context, index) {
                return introPages[index];
              },
            ),
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Color(0xFF1b1b1b), fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 35),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < introPages.length; i++)
                          if (i == currentPageValue) ...[circleBar(true)] else
                            circleBar(false),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageOneIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset('assets/info1.png')),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  'As we are aware of the world\'s number 1 problem, global warming',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  'By downloading this app, you have taken the first step to ease the problem',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  'Your next step is to record all your trips. This would help you progress in reducing the carbon emission',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageTwoIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset('assets/info2.png')),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  'The purpose of data collection in this app is to help you learn about your trip behaviours',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  'This would eventually lead you to understand your contribution to the net-zero carbon emission',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageThreeIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Image.asset('assets/info3.png')),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Text(
                  'We have collected several open datasets to provide you with the most information you can get around carbon emissions',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  'You can check them out by pressing the Chart button below or from the navigation bar at almost anywhere',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.insert_chart,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/visualisation');
                  })
            ],
          ),
        ),
      ),
    );
  }
}
