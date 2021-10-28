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

  final BehaviorSubject<String> _profilePicture = BehaviorSubject.seeded('');
  get profilePictureStream => _profilePicture.stream;
  String get profilePicture => _profilePicture.value;

  void setProfilePicture(String val) {
    _profilePicture.add(val);
  }

  final BehaviorSubject<List<List<Clothe>>> _clothes = BehaviorSubject.seeded([
    [],
    [],
    [],
  ]);
  get clothesStream => _clothes.stream;
  List<List<Clothe>> get clothes => _clothes.value;

  void reloadClothesList() async {
    List<List<Clothe>> new_clothes = [
      [],
      [],
      [],
    ];
    _clothes.add(new_clothes);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('clothes').get();

    querySnapshot.docs.forEach((doc) {
      Clothe clothe = Clothe(doc.id, doc['titre'], doc['prix'], doc['image'],
          doc['taille'], doc['marque'], doc['category']);
      new_clothes[0].add(clothe);
      if (clothe.category == 1 || clothe.category == 2) {
        new_clothes[clothe.category].add(clothe);
      }
    });
    _clothes.add(new_clothes);
  }
}
