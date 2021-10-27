import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp2_dev_mobile/models/app_state.dart';

import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/screens/basket.dart';
import 'package:get_it/get_it.dart';

class Detail extends StatefulWidget {
  final Clothe clothe;

  const Detail({required this.clothe, Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final AppState appState = GetIt.instance.get<AppState>();

  bool addedTobasket = false;

  @override
  Widget build(BuildContext context) {
    double imageSize = 400.0;

    return Scaffold(
        body: FutureBuilder(
            future: appState.checkIfInBasket(widget.clothe),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                bool isInBasket = (snapshot.data ?? false) || addedTobasket;
                return Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                            height: imageSize,
                            width: double.infinity,
                            child: Image.network(widget.clothe.image,
                                fit: BoxFit.cover)),
                        Container(
                            margin: EdgeInsets.only(top: imageSize - 30),
                            height: MediaQuery.of(context).size.height -
                                imageSize +
                                30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  top: 20, left: 30, right: 30, bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      width: 70,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(50),
                                    ),
                                    child: Text(
                                      '${widget.clothe.price} €',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Text(widget.clothe.title,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ))),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      'Taille: ${widget.clothe.size}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    'Marque: ${widget.clothe.brand}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Expanded(child: Container()),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          minimumSize:
                                              const Size(double.infinity, 50)),
                                      onPressed: (!isInBasket)
                                          ? () => buy(widget.clothe)
                                          : null,
                                      child: Wrap(
                                        runAlignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 10,
                                        children: [
                                          if (!isInBasket)
                                            const Icon(Icons.add_shopping_cart),
                                          Text(
                                            isInBasket
                                                ? 'Cet article est dans votre panier'
                                                : 'Ajouter au panier',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            )),
                        const Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: TopBar(''),
                        ),
                      ],
                    )
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  void buy(Clothe clothe) async {
    print('buy ${clothe.id}');

    var userUID = appState.user?.uid ?? '';

    print('res: ' + userUID);

    await FirebaseFirestore.instance.collection('paniers').doc(userUID).update({
      'items': FieldValue.arrayUnion([clothe.id])
    }).then((_) async {
      appState.updateCartCount();
      setState(() {
        addedTobasket = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${clothe.title} ajouté au panier')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    });
  }
}
