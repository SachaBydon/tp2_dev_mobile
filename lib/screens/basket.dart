import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/models/auth.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  @override
  Widget build(BuildContext context) {
    var authContext = context.watch<AuthModel>();

    return FutureBuilder(
        future: getBasketItems(authContext),
        builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
          if (snapshot.hasData) {
            return Wrap(children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int i) {
                    var clothe = snapshot.data![i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Center(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              snapshot.data![i].image,
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                            )))),
                                SizedBox(
                                    height: 50,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(snapshot.data![i].title,
                                            style:
                                                const TextStyle(fontSize: 20)),
                                        Text(
                                            'Taille: ${snapshot.data![i].size}'),
                                      ],
                                    )),
                              ],
                            ),
                            Text('${snapshot.data![i].price}€',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => delete(authContext, clothe))
                          ]),
                    );
                  }),
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
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  //Get clothes data from firebase
  Future<List<Clothe>> getBasketItems(AuthModel authContext) async {
    // get the user id from the global state
    // var userUID = authContext.user?.uid ?? 'Zhe8lmYksVVo3DU8XiBb8cxcwAN2';
    var userUID = authContext.user?.uid ?? '';

    //get items refs of the basket
    DocumentSnapshot<Map<String, dynamic>> basketQuery = await FirebaseFirestore
        .instance
        .collection('paniers')
        .doc(userUID)
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

  void delete(AuthModel authContext, Clothe clothe) async {
    print('delete: ' + clothe.id);

    var userUID = authContext.user?.uid ?? '';

    await FirebaseFirestore.instance.collection('paniers').doc(userUID).update({
      'items': FieldValue.arrayRemove([clothe.id])
    }).then((_) {
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
