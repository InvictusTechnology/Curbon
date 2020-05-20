import 'package:curbonapp/screen/home/history_screen.dart';
import 'package:curbonapp/screen/profile/about_us.dart';
import 'package:curbonapp/screen/profile/how_this_works.dart';
import 'package:curbonapp/screen/visualisation/visualisation1.dart';
import 'package:curbonapp/screen/visualisation/visualisation2.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curbonapp/screen/login/details_screen.dart';
import 'package:curbonapp/screen/first_screen.dart';
import 'package:curbonapp/screen/login/forgot_password_screen.dart';
import 'package:curbonapp/screen/home/home_screen.dart';
import 'package:curbonapp/screen/home/loading_home_screen.dart';
import 'package:curbonapp/screen/map/loading_screen.dart';
import 'package:curbonapp/screen/login/registration_screen.dart';
import 'package:curbonapp/screen/map/result_screen.dart';
import 'package:curbonapp/screen/visualisation/visualisation_screen.dart';
import 'package:curbonapp/screen/map/maps_screen.dart';
import 'package:curbonapp/screen/splash_screen.dart';
import 'package:curbonapp/screen/login/login_screen.dart';
import 'package:curbonapp/screen/profile/profile_screen.dart';
import 'package:curbonapp/screen/profile/introduction_pages.dart';

void main() {
  runApp(MainApp());
}

// ignore: must_be_immutable
class MainApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Assistant',
        brightness: Brightness.light,
        accentColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Color(0xFF26CB7E),
        ),
      ),
      routes: {
        '/': (context) => FirstScreen(),
        '/about': (context) => AboutUsScreen(),
        '/calculate': (context) => ResultScreen(),
        '/detail': (context) => UserDetailScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/history': (context) => HistoryScreen(),
        '/home': (context) => HomeScreen(),
        '/how': (context) => HowThisWorksWScreen(),
        '/intro_pages': (context) => IntroPages(),
        '/loading': (context) => LoadingScreen(),
        '/loading_home': (context) => LoadingHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfileScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/splash': (context) => SplashScreen(),
        '/visualisation': (context) => VisualisationScreen(),
        '/vizz1': (context) => VisualisationOne(),
        '/vizz2': (context) => VisualisationTwo(),
      },
      initialRoute: '/splash',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
