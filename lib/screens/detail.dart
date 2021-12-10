import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import 'package:tp2_dev_mobile/models/app_state.dart';
import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/widgets/carousel.dart';
import 'package:tp2_dev_mobile/widgets/grab_indicator.dart';

import 'package:tp2_dev_mobile/widgets/topbar.dart';

class Detail extends StatefulWidget {
  final Clothe clothe;
  final AnimationController? controller;

  const Detail({required this.clothe, Key? key, this.controller})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final AppState appState = GetIt.instance.get<AppState>();

  bool addedTobasket = false;

  double imageOpacity = 0;
  double borderRadius = 0;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(updateImageOpacity);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(updateImageOpacity);
  }

  updateImageOpacity() {
    setState(() {
      double progress = widget.controller?.value ?? 0;

      imageOpacity = progress;

      double radius = (1 - progress) * 200;
      if (radius > 30) radius = 30;
      borderRadius = radius;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = 400.0;

    return FutureBuilder(
        future: appState.checkIfInBasket(widget.clothe),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool isInBasket = (snapshot.data ?? false) || addedTobasket;
            return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Opacity(
                          opacity: imageOpacity,
                          // child: CarouselSlider(
                          //   options: CarouselOptions(
                          //       height: imageSize,
                          //       viewportFraction: 1.0,
                          //       enableInfiniteScroll: false),
                          //   items: widget.clothe.images
                          //       .map(
                          //         (item) => (RegExp(r'^base64.*')
                          //                 .hasMatch(item))
                          //             ? Image.memory(
                          //                 base64Decode(
                          //                     item.substring(6, item.length)),
                          //                 fit: BoxFit.cover,
                          //                 width: double.infinity,
                          //               )
                          //             : Image.network(
                          //                 item,
                          //                 fit: BoxFit.cover,
                          //                 width: double.infinity,
                          //               ),
                          //       )
                          //       .toList(),
                          // )
                          child: Carousel(
                              height: imageSize, items: widget.clothe.images),
                        ),
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
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  top: 0, left: 30, right: 30, bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(child: GrabIndicator()),
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
                                          padding: const EdgeInsets.only(
                                              bottom: 18, top: 18),
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void buy(Clothe clothe) async {
    var userUID = appState.user?.uid ?? '';

    try {
      await FirebaseFirestore.instance
          .collection('paniers')
          .doc(userUID)
          .update({
        'items': FieldValue.arrayUnion([clothe.id])
      });
      appState.updateCartCount();
      setState(() {
        addedTobasket = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${clothe.title} ajouté au panier'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
