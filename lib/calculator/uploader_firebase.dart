import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Uploader {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
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

  int getPoint() {
    switch (transport) {
      case 'Walking':
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
    var profile = await _firestore
        .collection('profile')
        .where('user', isEqualTo: user.email)
        .getDocuments();

    for (var doc in profile.documents) {
      point = doc.data['point'];
    }
    point = point + newPoint;
    if (point >= 100) {
      point = point - 100;
      isLevelUp = true;
    } else {
      isLevelUp = false;
    }
    await _firestore
        .collection('profile')
        .document(user.email)
        .updateData({'point': point});

    print('-----> CALCULATOR - -> $point');
  }

  bool getLevelUp() {
    return isLevelUp;
  }

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
