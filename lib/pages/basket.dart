import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './detail.dart';
import 'package:tp2_dev_mobile/models.dart';

basket() {
  return FutureBuilder(
      future: getBasketItems(),
      builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (BuildContext context, int i) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail(
                            clothe: snapshot.data![i],
                          ),
                        ),
                      );
                    },
                    child: Container(
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
                          ]),
                    ));
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      });
}

//Get clothes data from firebase
Future<List<Clothe>> getBasketItems() async {
  //get items refs of the basket
  //TODO get id of user dynamically
  var tmpUuid = 'Zhe8lmYksVVo3DU8XiBb8cxcwAN2';
  QuerySnapshot basketQuery = await FirebaseFirestore.instance
      .collection('paniers')
      .where('user', isEqualTo: tmpUuid)
      .get();

  if (basketQuery.docs.isEmpty) return [];
  var basketItems = basketQuery.docs[0]['items'];

  //get clothes data from from items in th list
  QuerySnapshot itemsQuery = await FirebaseFirestore.instance
      .collection('clothes')
      .where(FieldPath.documentId, whereIn: basketItems)
      .get();

  List<Clothe> clothes = [];
  for (var doc in itemsQuery.docs) {
    clothes.add(Clothe(
        doc['titre'], doc['prix'], doc['image'], doc['taille'], doc['marque']));
  }
  return clothes;
}
