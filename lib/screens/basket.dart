import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/widgets/grab_indicator.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  final AppState appState = GetIt.instance.get<AppState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: appState.streamUser,
                builder: (context, AsyncSnapshot<User?> userSnapshot) {
                  String userId = userSnapshot.data?.uid ?? '';
                  return FutureBuilder(
                      future: getBasketItems(userId),
                      builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(children: [
                              GrabIndicator(),
                              const Center(
                                  child: Text('Panier',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    padding: const EdgeInsets.all(16),
                                    itemBuilder: (BuildContext context, int i) {
                                      return renderItem(
                                          snapshot.data![i], userId);
                                    }),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                alignment: Alignment.centerRight,
                                child: Text(
                                    'Total: ${getTotalPrice(snapshot.data!)}€',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              )
                            ]);
                          } else {
                            return const Center(
                                child: Text(
                                    'Vous n\'avez pas d\'articles dans votre panier'));
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                })));
  }

  renderItem(clothe, userId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: (clothe.image[0] == '/')
                            ? Image.memory(
                                base64Decode(clothe.image),
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              )
                            : Image.network(
                                clothe.image,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )))),
            SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(clothe.title, style: const TextStyle(fontSize: 20)),
                Text('Taille: ${clothe.size}'),
              ],
            )),
          ],
        ),
        SizedBox(
            height: 50,
            child: Row(
              children: [
                Text('${clothe.price}€',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      delete(userId, clothe);
                    })
              ],
            ))
      ]),
    );
  }

  //Get clothes data from firebase
  Future<List<Clothe>> getBasketItems(String userId) async {
    //get items refs of the basket
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(userId)
        .get();

    var basketItems = basketQuery['items'];

    //get clothes data from from items in th list
    QuerySnapshot itemsQuery = await FirebaseFirestore.instance
        .collection('clothes')
        .where(FieldPath.documentId, whereIn: basketItems)
        .get();

    List<Clothe> clothes = [];
    for (var doc in itemsQuery.docs) {
      clothes.add(Clothe(doc.id, doc['titre'], doc['prix'], doc['image'],
          doc['taille'], doc['marque'], doc['category']));
    }
    return clothes;
  }

  void delete(String userId, Clothe clothe) async {
    await FirebaseFirestore.instance.collection('paniers').doc(userId).update({
      'items': FieldValue.arrayRemove([clothe.id])
    });

    appState.updateCartCount();
    setState(() {});
  }

  num getTotalPrice(List<Clothe>? clothes) {
    num total = 0;
    if (clothes != null) {
      for (var clothe in clothes) {
        total += clothe.price;
      }
    }

    return (total * 100).round() / 100;
  }
}
