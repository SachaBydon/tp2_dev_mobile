import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tp2_dev_mobile/screens/detail.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';

class Buy extends StatelessWidget {
  const Buy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vinted'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Tous',
              ),
              Tab(
                text: 'Vêtements',
              ),
              Tab(
                text: 'Accessoires',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            listRendered(0),
            listRendered(1),
            listRendered(2),
          ],
        ),
      ),
    );
  }

  listRendered(category) {
    return FutureBuilder(
        future: getAllItems(category),
        builder: (context, AsyncSnapshot<List<Clothe>> snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
                length: 3,
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    // padding: const EdgeInsets.all(16),
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 13, bottom: 13),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Center(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                              Text(
                                                  'Taille: ${snapshot.data![i].size}'),
                                            ],
                                          )),
                                    ],
                                  ),
                                  Text('${snapshot.data![i].price}€',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ]),
                          ));
                    }));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  //Get clothes data from firebase
  Future<List<Clothe>> getAllItems(category) async {
    // category = 0 -> All
    // category = 1 ->
    // category = 2 ->
    QuerySnapshot? querySnapshot = null;
    var clothesCollection = FirebaseFirestore.instance.collection('clothes');
    if (category == 0) {
      querySnapshot = await clothesCollection.get();
    } else {
      querySnapshot =
          await clothesCollection.where('category', isEqualTo: category).get();
    }

    return querySnapshot.docs.map((doc) {
      return Clothe(doc.id, doc['titre'], doc['prix'], doc['image'],
          doc['taille'], doc['marque']);
    }).toList();
  }
}
