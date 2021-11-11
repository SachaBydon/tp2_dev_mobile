import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'dart:convert';

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
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 15),
                                width: 70,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
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
                                      var clothe = snapshot.data![i];
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: Center(
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: (snapshot
                                                                          .data![
                                                                              i]
                                                                          .image[0] ==
                                                                      '/')
                                                                  ? Image.memory(
                                                                      base64Decode(snapshot
                                                                          .data![
                                                                              i]
                                                                          .image),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                    )
                                                                  : Image.network(
                                                                      snapshot
                                                                          .data![
                                                                              i]
                                                                          .image,
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )))),
                                                  SizedBox(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          snapshot
                                                              .data![i].title,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      20)),
                                                      Text(
                                                          'Taille: ${snapshot.data![i].size}'),
                                                    ],
                                                  )),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: 50,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          '${snapshot.data![i].price}€',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            delete(
                                                                userId, clothe);
                                                          })
                                                    ],
                                                  ))
                                            ]),
                                      );
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
    print('delete: ' + clothe.id);

    await FirebaseFirestore.instance.collection('paniers').doc(userId).update({
      'items': FieldValue.arrayRemove([clothe.id])
    }).then((_) async {
      appState.updateCartCount();
      print('res: item updated');
    }).catchError((error) {
      print('res: error: $error');
    }).whenComplete(() {
      print('res: complete');
      setState(() {});
    });
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

class TopBar extends StatelessWidget {
  final String title;
  const TopBar(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(top: 43),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ));
  }
}
