import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tp2_dev_mobile/models/clothe.dart';

class AppState {
  // Variables pour compter le nombre d'items dans le panier
  final BehaviorSubject<int> _basketCounter = BehaviorSubject.seeded(0);
  get streamBasketCounter => _basketCounter.stream;
  get basketCounter => _basketCounter.value;

  void setBasketCounter(int val) {
    _basketCounter.add(val);
  }

  // Variables qui contient les informations du l'utilisateur connecté
  final BehaviorSubject<User?> _user = BehaviorSubject.seeded(null);
  get streamUser => _user.stream;
  User? get user => _user.value;

  void login(User u) {
    _user.add(u);
  }

  void logout() {
    _user.add(null);
  }

  // Méthode pour récupérer le nombre d'items dans le panier dupuis la DB
  void updateCartCount() async {
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(_user.value?.uid ?? '')
        .get();

    _basketCounter.add(basketQuery['items'].length);
  }

  // Méthode pour savoir si un item est dans le panier
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

  // Variables pour les gérer la liste de tous les items dans chaque catégorie
  final BehaviorSubject<List<List<Clothe>>> _clothes = BehaviorSubject.seeded([
    [],
    [],
    [],
  ]);
  get clothesStream => _clothes.stream;
  List<List<Clothe>> get clothes => _clothes.value;

  void reloadClothesList() async {
    List<List<Clothe>> newClothes = [
      [],
      [],
      [],
    ];
    _clothes.add(newClothes);
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('clothes').get();

    for (var doc in querySnapshot.docs) {
      Clothe clothe = Clothe(doc.id, doc['titre'], doc['prix'], doc['image'],
          doc['taille'], doc['marque'], doc['category']);
      newClothes[0].add(clothe);
      if (clothe.category == 1 || clothe.category == 2) {
        newClothes[clothe.category].add(clothe);
      }
    }
    _clothes.add(newClothes);
  }
}
