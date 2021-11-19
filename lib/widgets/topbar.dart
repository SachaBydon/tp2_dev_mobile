import 'package:flutter/material.dart';

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
