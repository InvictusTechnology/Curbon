import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// A class to upload the result from the user to the cloud firestore
class Uploader {
  // instances for authentication (user) and cloud firestore
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  // variables to hold the values
  String destination;
  String starting;
  String transport;
  String carbon;
  String distance;
  bool isLevelUp;

  Uploader(
      {this.distance,
      this.transport,
      this.carbon,
      this.destination,
      this.starting});

  // This will get how much points the user receive from that trip
  // Points are based on the type of transport user's using
  int getPoint() {
    switch (transport) {
      case 'Bicycle':
        {
          print(transport);
          return 10;
        }
        break;
      case 'Walking':
        {
          print('----------');
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
          return 2;
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

  // Upload the result and trip to firestore
  void uploadResult() async {
    try {
      final user = await _auth.currentUser();
      await _firestore.collection('past_trips').add({
        'user': user.email,
        'to': destination,
        'from': starting,
        'transport': transport,
        'carbon': carbon,
        'distance': distance,
        'createdTime': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
