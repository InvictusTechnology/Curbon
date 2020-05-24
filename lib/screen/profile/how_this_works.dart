import 'package:curbonapp/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FirstHowScreen extends StatefulWidget {
  @override
  _FirstHowScreenState createState() => _FirstHowScreenState();
}

class _FirstHowScreenState extends State<FirstHowScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Image.asset('assets/how.png')),
                    Text(
                      'Once again, welcome to Curbon\n',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'In this page, we want to show you our simple calculation method in calculating the carbon emission from every trip you\'re tracking\n\nAt first, we considered in manually calculating from the average fuel consumption from typical vehicles, but then it would require a lot of assumptions which may result in inconsistent results\n\nIn the end, we decided that it would be easier and simpler to use an average of typical vehicles (calculated) emission',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  margin: EdgeInsets.only(bottom: 10 + animation.value * 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_up),
                      Text(
                        'More details',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SecondHowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '7 Different modes of transport',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Click on the link besides each icons\nArticles that we found best describe average emission of each mode of transport',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        setIcon(Icons.directions_car, 2, 'Car',
                            'https://www.greenvehicleguide.gov.au/pages/Information/VehicleEmissions'),
                        setIcon(Icons.directions_bus, 2, 'Bus',
                            'https://www.carbonindependent.org/20.html'),
                        setIcon(Icons.tram, 2, 'Tram',
                            'www.abc.net.au/tv/carboncops/factsheet/ cc_other_transport.pdf')
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        setIcon(Icons.motorcycle, 2, 'Motorcycle',
                            'https://www.co2nnect.org/help_sheets/?op_id=602&opt_id=98'),
                        setIcon(Icons.directions_bike, 2, 'Bicycle',
                            'https://www.ourstreetsmpls.org/does_bike_commuting_affect_your_carbon_footprint_and_how_much'),
                        setIcon(Icons.train, 2, 'Train',
                            'https://www.abc.net.au/tv/carboncops/factsheets/cc_other_transport.pdf'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            setIcon(Icons.directions_walk, 1, 'Walking',
                'https://www.globe.gov/explore-science/scientists-blog/archived-posts/sciblog/index.html_p=186.html')
          ],
        ),
      )),
    );
  }

  Widget setIcon(IconData icons, int flex, String text, String url) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          launch(url);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: themeColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icons,
                size: 35,
                color: themeColor,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 17.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class HowThisWorksWScreen extends StatelessWidget {
  List<Widget> howScreens = [FirstHowScreen(), SecondHowScreen()];
  PageController _controller;

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: howScreens,
      scrollDirection: Axis.vertical,
      controller: _controller,
      physics: ClampingScrollPhysics(),
    );
  }
}
