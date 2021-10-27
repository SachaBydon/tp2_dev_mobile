import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';

class AppState {
  final BehaviorSubject<int> _basketCounter = BehaviorSubject.seeded(0);
  get streamBasketCounter => _basketCounter.stream;
  get basketCounter => _basketCounter.value;

  void setBasketCounter(int val) {
    _basketCounter.add(val);
  }

  final BehaviorSubject<User?> _user = BehaviorSubject.seeded(null);
  get streamUser => _user.stream;
  User? get user => _user.value;

  void login(User u) {
    _user.add(u);
  }

  void logout() {
    _user.add(null);
  }

  void updateCartCount() async {
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(_user.value?.uid ?? '')
        .get();

    _basketCounter.add(basketQuery['items'].length);
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
