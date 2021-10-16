import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tp2_dev_mobile/models/clothe.dart';
import 'package:tp2_dev_mobile/models/auth.dart';

class Detail extends StatefulWidget {
  final Clothe clothe;

  const Detail({Key? key, required this.clothe}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    var authContext = context.watch<AuthModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clothe.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => buy(authContext, widget.clothe),
        child: Icon(Icons.shopping_cart),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network(widget.clothe.image),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Taille: ${widget.clothe.size}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.clothe.price}€',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Marque: ${widget.clothe.brand}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buy(AuthModel authContext, Clothe clothe) async {
    print('buy ${clothe.id}');

    var userUID = authContext.user?.uid ?? '';

    print('res: ' + userUID);

    await FirebaseFirestore.instance.collection('paniers').doc(userUID).update({
      'items': FieldValue.arrayUnion([clothe.id])
    }).then((_) {
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
