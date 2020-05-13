import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curbonapp/screen/details_screen.dart';
import 'package:curbonapp/screen/first_screen.dart';
import 'package:curbonapp/screen/forgot_password_screen.dart';
import 'package:curbonapp/screen/home_screen.dart';
import 'package:curbonapp/screen/loading_home_screen.dart';
import 'package:curbonapp/screen/loading_screen.dart';
import 'package:curbonapp/screen/registration_screen.dart';
import 'package:curbonapp/screen/result_screen.dart';
import 'package:curbonapp/screen/maps_screen.dart';
import 'package:curbonapp/screen/splash_screen.dart';
import 'package:curbonapp/screen/visualisation1.dart';
import 'package:curbonapp/screen/login_screen.dart';
import 'package:curbonapp/screen/profile_screen.dart';

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
        fontFamily: 'Proxima',
        brightness: Brightness.light,
        accentColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Color(0xFF26CB7E),
        ),
      ),
      routes: {
        '/': (context) => FirstScreen(),
        '/calculate': (context) => ResultScreen(),
        '/detail': (context) => UserDetailScreen(),
        '/forgot': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/loading': (context) => LoadingScreen(),
        '/loading_home': (context) => LoadingHomeScreen(),
        '/login': (context) => LoginScreen(),
        '/map': (context) => MapScreen(),
        '/profile': (context) => ProfileScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/splash': (context) => SplashScreen(),
        '/viz1': (BuildContext context) => Visualisation(),
      },
      initialRoute: '/splash',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}
