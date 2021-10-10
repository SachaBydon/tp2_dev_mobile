import 'package:flutter/material.dart';
import 'package:tp2_dev_mobile/models.dart';

class Detail extends StatefulWidget {
  final Clothe clothe;

  const Detail({Key? key, required this.clothe}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  print('buy !');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
