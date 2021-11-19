import 'package:flutter/material.dart';

class GrabIndicator extends StatelessWidget {
  const GrabIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 15),
      width: 70,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
