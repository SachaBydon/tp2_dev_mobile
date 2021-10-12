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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: Image.network(widget.clothe.image),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.clothe.size,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.clothe.price}€',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.clothe.brand}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => buy(authContext, widget.clothe),
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
      print('res: item updated');
    }).catchError((error) {
      print('res: error: $error');
    });
  }
}
