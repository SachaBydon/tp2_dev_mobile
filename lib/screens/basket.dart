import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/models/auth.dart';
import 'package:tp2_dev_mobile/models/test_global.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  final user = GetIt.instance.get<UserState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[const TopBar('Panier'), renderedList()],
        ));
  }

  Widget renderedList() {
    var totalHeight = 50;
    var listHeight = MediaQuery.of(context).size.height - 56 - 80 - totalHeight;

    return StreamBuilder(
        stream: user.stream$,
        builder: (context, AsyncSnapshot<User?> userSnapshot) {
          String userId = userSnapshot.data?.uid ?? '';
          print('userId: ' + userId);
          return FutureBuilder(
              future: getBasketItems(userId),
              builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Wrap(children: [
                      Container(
                        constraints: BoxConstraints(maxHeight: listHeight),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (BuildContext context, int i) {
                              var clothe = snapshot.data![i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              child: Center(
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        snapshot.data![i].image,
                                                        height: 50,
                                                        width: 50,
                                                        fit: BoxFit.cover,
                                                      )))),
                                          SizedBox(
                                              height: totalHeight.toDouble(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(snapshot.data![i].title,
                                                      style: const TextStyle(
                                                          fontSize: 20)),
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
                                                          FontWeight.bold)),
                                              IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    delete(userId, clothe);
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
                        child: Text('Total: ${getTotalPrice(snapshot.data!)}€',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      )
                    ]);
                  } else {
                    return const Center(
                        child: Text(
                            'Vous n\'avez pas d\'articles dans votre panier'));
                  }
                } else {
                  return const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
              });
        });
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
          doc['taille'], doc['marque']));
    }
    return clothes;
  }

  void delete(String userId, Clothe clothe) async {
    print('delete: ' + clothe.id);
    var counter = GetIt.instance.get<Counter>();

    await FirebaseFirestore.instance.collection('paniers').doc(userId).update({
      'items': FieldValue.arrayRemove([clothe.id])
    }).then((_) async {
      int backetCounter = await user.getCartCount();
      counter.setCounter(backetCounter);
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

    return total;
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
