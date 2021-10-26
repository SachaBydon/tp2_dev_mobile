import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';

class UserState {
  final BehaviorSubject<User?> _user = BehaviorSubject.seeded(null);

  get stream$ => _user.stream;
  get current => _user.value;

  void login(User u) {
    _user.add(u);
    print('UUID: ${_user.value?.uid}');
    print('logged in !');
  }

  void logout() {
    _user.add(null);
    print('logged out !');
  }

  Future<int> getCartCount() async {
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(_user.value?.uid ?? '')
        .get();

    return basketQuery['items'].length;
  }

  Future<bool> checkIfInBasket(Clothe clothe) async {
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(_user.value?.uid ?? '')
        .get();

    for (var item in basketQuery['items']) {
      if (item == clothe.id) {
        return true;
      }
    }
    return false;
  }
}
